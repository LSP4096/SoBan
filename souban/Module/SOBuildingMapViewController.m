//
//  SOBuildingMapViewController.m
//  souban
//
//  Created by JiaHao on 11/18/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingMapViewController.h"

#import "SOBuildingAnnotationView.h"
#import "SOAreaAnnotationView.h"
#import "SOBlockAnnotationView.h"
#import "SOBuildingAnnotationView.h"
#import "SOProgressStatusBar.h"

#import "SODropDownMenuManager.h"
#import "UIView+Layout.h"
#import "SOBuildingListViewController.h"
#import "OMHTTPClient+Building.h"
#import "OMHUDManager.h"
#import "UIColor+ATColors.h"
#import "SOPOISummary.h"
#import "NSNumber+Formatter.h"
#import "SOMapRegion.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SOPointAnnotation.h"
#import "SOBuildingDetailViewController.h"
#import "NSString+Location.h"
#import "SOBuilding.h"
#import "OMNavigationManager.h"
#import "SOSearchViewController.h"
#import "UIViewController+TopViewController.h"
#import "SOSubwayAnnotation.h"
#import "CommonUtility.h"
#import "UIActionSheet+BlocksKit.h"
#import <ActionSheetStringPicker.h>
#import "SOSubwayStopAnnotationView.h"
#import "SOSubwayStopAnnotation.h"
#import "SOSubwayRegionScreenModel.h"
#import "SOSubwaySummary.h"
#import "NSNotificationCenter+OM.h"
#import "SOCity.h"
typedef NS_ENUM(NSUInteger, MapZoomLevel) {
    ZoomLevelArea = 11,
    ZoomLevelBlock = 13,
    ZoomLevelBuilding = 15,
};


@interface SOBuildingMapViewController () <MAMapViewDelegate, SODropDownMenuManagerDelegate, UISearchBarDelegate, SOSearchViewControllerDelegate, AMapSearchDelegate, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet SOProgressStatusBar *progressBar;
@property (weak, nonatomic) IBOutlet UIView *searchbarContainView;
@property (weak, nonatomic) IBOutlet UIView *filterBar;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;

@property (strong, nonatomic) SOPOISummary *POISummary;
@property (nonatomic) MapZoomLevel mapZoomLevel;
@property (nonatomic) BOOL shouldLoadAnnotation;
@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) NSMutableArray *requests;
@property (strong, nonatomic) NSMutableArray *subwayAnnotations;
@property (strong, nonatomic) NSMutableArray *subwayLines; // 记录去除往返重复后的线路

@property (strong, nonatomic, readwrite) NSString *keyword;
@property (strong, nonatomic) MAUserLocation *locationAnnotation;
@property (strong, nonatomic) AMapSearchAPI *search;
@property (strong, nonatomic) ActionSheetStringPicker *subwayPicker;
@property (nonatomic, assign) NSInteger pickerIndex;

@property (strong, nonatomic) MACircle *subwayCircle;
@property (strong, nonatomic) SOSubwayAnnotation *selectSubwayAnnotation;
@property (weak, nonatomic) IBOutlet UIButton *subwayButton;

@end


@implementation SOBuildingMapViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shouldLoad = NO;
    self.shouldLoadAnnotation = NO;
    self.mapView.delegate = self;
    self.pickerIndex = 0;
    [self configMapView];
    [self setSearchBarToolBar];
    [self.view addSubview:self.menuManager.dropDownMenu];


    [self subwaySearch];
    NSString *name = [[SOCity city].name substringToIndex:[SOCity city].name.length - 1];
    [self.areaButton setTitle:name forState:UIControlStateNormal];

    [NSNotificationCenter registerNotificationWithObserver:self selector:@selector(cityChanged:) name:kCityChanged];
}

#pragma mark - Network

- (void)fetchDataWithKeyword:(NSString *)keyword
{
    self.keyword = keyword;
    if (self.shouldLoad) {
        [self cancelTask];
        [self.progressBar showWithLoadingStatus];

        NSURLSessionDataTask *task = [[OMHTTPClient realClient] fetchBuildingGEOsWithScreenModel:self.menuManager.screenModel keyword:keyword mapLevel:keyword ? ZoomLevelBuilding + 1 : self.mapZoomLevel + 1 region:[SOMapRegion SOMapRegionWithBMKRegion:self.mapView.region] completion:^(id resultObject, NSError *error) {
            if (error) {
                if (![error.errorMessage isEqualToString:@"已取消"]) {
                    [OMHUDManager showErrorWithStatus:error.errorMessage];
                }
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    SOPOISummary *POISummary = resultObject;
                    CLLocationCoordinate2D centerCoordBaidu = [@"" BaiduCoordinateWithAmapCoordinate:self.mapView.region.center];
                    NSString *centerString = [NSString stringWithFormat:@"%@,%@",@(centerCoordBaidu.longitude),@(centerCoordBaidu.latitude)];
                    if ([centerString isEqualToString:POISummary.centerLocation]) {
                        self.POISummary = resultObject;
                        [self updateAnnotationsWithKeyword:keyword?YES:NO];
                    }
                });
                
            }
        }];

        if (!self.menuManager.screenItems) {
            [OMHUDManager showActivityIndicatorMessage:@"加载中..."];
            [[OMHTTPClient realClient] fetchScreenItemsWithCompletion:^(id resultObject, NSError *error) {
                if (!error.hudMessage) {
                    [OMHUDManager dismiss];
                    self.menuManager.screenItems = resultObject;
                    self.menuManager.screenModel = [SOBuildingScreenModel new];
                }
            }];
        }

        [self.requests addObject:task];
    }
}

- (void)cancelTask
{
    for (NSURLSessionDataTask *task in self.requests) {
        [task cancel];
    }
    [self.requests removeAllObjects];
}

#pragma mark - Notification
- (void)cityChanged:(NSNotification *)notification
{
    if (notification.userInfo[@"city"]) {
        [self.menuManager.dropDownMenu dismissMenu];

        self.menuManager.screenItems = nil;
        [self fetchDataWithKeyword:self.keyword];
        NSString *name = [[SOCity city].name substringToIndex:[SOCity city].name.length - 1];
        [self.areaButton setTitle:name forState:UIControlStateNormal];

        [self.mapView removeAnnotations:self.annotations];
        [self.mapView removeAnnotations:self.subwayAnnotations];
        [self.mapView removeOverlays:self.mapView.overlays];
        [self subwaySearch];

        CLLocationCoordinate2D defaultCoor = [SOCity city].location ? [SOCity city].location.coordinate2d : CLLocationCoordinate2DMake(30.3301507269, 120.2407722204);
        [self.mapView setCenterCoordinate:defaultCoor];
    }
}

#pragma mark - SOSearchControllerDelegate
- (void)searchViewControllerDidSearchWithKeyword:(NSString *)keyword
{
    self.keyword = keyword;
    self.searchTextField.text = self.keyword;
    [self fetchDataWithKeyword:self.keyword];
}

#pragma mark - SODropDownMenuManagerDelegate

- (void)needRefreshData
{
    [self fetchDataWithKeyword:nil];
}

#pragma mark - Privite Method

- (IBAction)showSubwayPicker:(id)sender
{
    [self.subwayPicker showActionSheetPicker];
}

- (IBAction)areaTapped:(id)sender
{
    [OMNavigationManager modalControllerWithStoryboardName:kStoryboardBuilding identifier:@"SOCityChooseTableViewNavigationController" userInfo:nil];
}

- (void)configMapView
{
    self.mapView.showsScale = NO;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.showsCompass = NO;
    [self.mapView setZoomLevel:ZoomLevelArea + 0.2];
    self.mapZoomLevel = ZoomLevelArea;

    CLLocationCoordinate2D defaultCoor = [SOCity city].location ? [SOCity city].location.coordinate2d : CLLocationCoordinate2DMake(30.3301507269, 120.2407722204);
    [self.mapView setCenterCoordinate:defaultCoor];
}

- (void)setSearchBarToolBar
{
    self.searchbarContainView.layer.borderColor = [UIColor at_warmGreyColor].CGColor;
    self.searchbarContainView.layer.borderWidth = 0.5;
}


- (IBAction)searchBarTapped:(id)sender
{
    SOSearchViewController *controller = [[UIStoryboard building] instantiateViewControllerWithIdentifier:[SOSearchViewController storyboardIdentifier]];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.delegate = self;
    [[UIViewController topViewController] presentViewController:controller animated:YES completion:nil];
}

- (IBAction)locationButtonTouched:(id)sender
{
    self.mapView.showsUserLocation = YES;
}


- (IBAction)toBuildingList:(id)sender
{
    [self.view endEditing:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(flipButtonTapped)]) {
        [self.delegate flipButtonTapped];
    }
}

- (void)removeAnnotations
{
    NSArray *annotations = [NSArray arrayWithArray:self.mapView.annotations];
    for (MAPointAnnotation *annotation in annotations) {
        if (![annotation.title isEqualToString:@"我的位置"] && ![annotation isMemberOfClass:[SOSubwayAnnotation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
}

- (void)updateAnnotationsWithKeyword:(BOOL)hasKeyword
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.annotations = [NSMutableArray new];
        NSInteger roomCount = 0;
        for (SOBuildingPOI *poi in self.POISummary.poiList) {
            if (!poi.location.latitude || !poi.location.longitude || !poi.title || !poi.roomCount) {
                continue;
            }
            CLLocationCoordinate2D coor;
            coor.latitude = poi.location.latitude.floatValue;
            coor.longitude = poi.location.longitude.floatValue;
            CLLocationCoordinate2D amapcoord = MACoordinateConvert(coor,MACoordinateTypeBaidu);
            SOPointAnnotation *pointAnnotation = [[SOPointAnnotation alloc]init];
            pointAnnotation.buildingId = poi.buildingId;
            pointAnnotation.title = poi.title;
            pointAnnotation.subtitle = [poi.roomCount roomCountString];
            pointAnnotation.coordinate = amapcoord;
            roomCount += poi.roomCount.integerValue;
            [self.annotations addObject:pointAnnotation];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self removeAnnotations];
            if (hasKeyword) {
                if (self.POISummary.poiList.count) {
                    SOBuildingPOI *poi = self.POISummary.poiList.firstObject;
                    CLLocationCoordinate2D keywordCoor = CLLocationCoordinate2DMake(poi.location.latitude.floatValue, poi.location.longitude.floatValue);
                    CLLocationCoordinate2D keywordCoorGD = MACoordinateConvert(keywordCoor,MACoordinateTypeBaidu);
                    self.mapZoomLevel = ZoomLevelBuilding;
                    [self.mapView setZoomLevel:ZoomLevelBuilding];
                    [self.mapView setCenterCoordinate:keywordCoorGD];
                    [self.progressBar showWithMessage:[NSString stringWithFormat:@"共为您找到%@套房源",@(roomCount)]];
                }else{
                    [self.progressBar showWithMessage:@"没有查找到房源"];
                }
            }else{
                [self.progressBar showWithMessage:[NSString stringWithFormat:@"共为您找到%@套房源",@(roomCount)]];
            }
           
            [self.mapView addAnnotations:self.annotations];
            [self.mapView removeAnnotation:self.locationAnnotation];
            [self.mapView addAnnotation:self.locationAnnotation];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressBar hide];
            });
          
        });
    });
}

- (void)showSubwayWithBusLineKeyword:(NSString *)keyword
{
    void (^addSubwayStop)(AMapBusLine *line) = ^void(AMapBusLine *line) {
        for (AMapBusStop *busStop in line.busStops) {
            SOSubwayAnnotation *pointAnnotation = [[SOSubwayAnnotation alloc] init];
            pointAnnotation.title = busStop.name;
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(busStop.location.latitude, busStop.location.longitude);
            pointAnnotation.uid = busStop.uid;
            // 去重
            NSInteger index = [self.subwayAnnotations indexOfObjectPassingTest:^BOOL(SOSubwayAnnotation *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.uid isEqualToString:busStop.uid]) {
                    *stop = YES;
                    return YES;
                }
                return NO;
            }];
            if (index == NSNotFound) {
                [self.subwayAnnotations addObject:pointAnnotation];
            }
        }
    };


    [self.mapView removeAnnotations:self.subwayAnnotations];
    [self.subwayAnnotations removeAllObjects];
    [self.mapView removeOverlays:self.mapView.overlays];

    if ([keyword isEqualToString:@"关闭"]) {
        return;
    }

    [self.mapView setZoomLevel:12 animated:YES];

    for (AMapBusLine *busline in self.subwayLines) {
        if ([busline.name containsString:keyword]) {
            addSubwayStop(busline);
            MAPolyline *polyline = [CommonUtility polylineForBusLine:busline];
            [self.mapView addOverlay:polyline];
        }
    }

    NSMutableArray *geoRegions = [NSMutableArray new];
    for (SOSubwayAnnotation *annotation in self.subwayAnnotations) {
        SOSubwayRegionScreenModel *screenRegionModel = [SOSubwayRegionScreenModel new];
        screenRegionModel.center = [SOPOILocation new];
        screenRegionModel.stationId = annotation.uid;
        CLLocationCoordinate2D coor;
        coor.latitude = annotation.coordinate.latitude;
        coor.longitude = annotation.coordinate.longitude;
        CLLocationCoordinate2D centerBaidu = [@"" BaiduCoordinateWithAmapCoordinate:coor];

        screenRegionModel.center.latitude = @(centerBaidu.latitude);
        screenRegionModel.center.longitude = @(centerBaidu.longitude);
        [geoRegions addObject:screenRegionModel.toDictionary];
    }
    [[OMHTTPClient realClient] fetchSubwayStopBuildingCountWithSOSubwayRegionScreenModels:geoRegions BuildingScreenModel:self.menuManager.screenModel Completion:^(id resultObject, NSError *error) {
        if (!error.hudMessage) {
            for (SOSubwaySummary *subwaySummary in resultObject) {
                for (SOSubwayAnnotation *annotation in self.subwayAnnotations) {
                    if ([subwaySummary.stationId isEqualToString:annotation.uid]) {
                        annotation.subtitle = subwaySummary.totalCount.stringValue;
                    }
                }
            }
            [self.mapView addAnnotations:self.subwayAnnotations];
        }
    }];
}

- (void)subwaySearch
{
    self.subwayButton.enabled = NO;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapBusLineNameSearchRequest *request = [[AMapBusLineNameSearchRequest alloc] init];
    request.keywords = @"地铁*号线";
    request.requireExtension = YES;
    request.city = [SOCity city].name ? [SOCity city].name : @"杭州";
    [self.search AMapBusLineNameSearch:request];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    self.mapView.showsUserLocation = NO;
    self.locationAnnotation = userLocation;
    self.locationAnnotation.title = @"我的位置";
    CLLocationCoordinate2D defaultCoor = CLLocationCoordinate2DMake(30.3301507269, 120.2407722204);
    [self.mapView setCenterCoordinate:userLocation.location.coordinate.longitude == 0 ? defaultCoor : userLocation.location.coordinate];
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineView *polylineRenderer = [[MAPolylineView alloc] initWithPolyline:(MAPolyline *)overlay];
        polylineRenderer.lineWidth = 5.f;
        polylineRenderer.strokeColor = [UIColor redColor];
        return polylineRenderer;
    } else if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:(MACircle *)overlay];
        circleView.lineWidth = 2.f;
        circleView.strokeColor = [UIColor redColor];
        circleView.fillColor = [UIColor clearColor];
        circleView.layer.zPosition = 1;
        return circleView;
    } else {
        return nil;
    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MAAnnotationView *view in views) {
        if ([view isMemberOfClass:[SOBuildingAnnotationView class]] || [view isMemberOfClass:[SOBlockAnnotationView class]]) {
            [[view superview] sendSubviewToBack:view];
        }
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    static NSString *AnnotationViewArea = @"AnnotationViewReuseID1";
    static NSString *AnnotationViewBlock = @"AnnotationViewReuseID2";
    static NSString *AnnotationViewBuilding = @"AnnotationViewReuseID3";
    static NSString *AnnotationViewSubway = @"AnnotationViewReuseID4";

    static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";

    if ([annotation isMemberOfClass:[MAUserLocation class]]) {
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"ic_location_red"];
        annotationView.layer.zPosition = 1;
        return annotationView;
    } else if ([annotation isMemberOfClass:[SOSubwayAnnotation class]]) {
        SOSubwayStopAnnotationView *annotationView = (SOSubwayStopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewSubway];
        if (annotationView == nil) {
            annotationView = [[SOSubwayStopAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:AnnotationViewSubway];
        }
        annotationView.layer.zPosition = 1;
        return annotationView;
    } else {
        if (self.mapZoomLevel <= ZoomLevelArea) {
            SOAreaAnnotationView *annotationView = (SOAreaAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewArea];
            if (annotationView) {
                annotationView.annotation = annotation;
            } else {
                annotationView = [[SOAreaAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewArea];
            }
            return annotationView;
        } else if (self.mapZoomLevel > ZoomLevelArea && self.mapZoomLevel <= ZoomLevelBlock) {
            SOBlockAnnotationView *annotationView = (SOBlockAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewBlock];
            if (annotationView) {
                annotationView.annotation = annotation;
            } else {
                annotationView = [[SOBlockAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewBlock];
            }
            return annotationView;
        } else if (self.mapZoomLevel > ZoomLevelBlock) {
            SOBuildingAnnotationView *annotationView = (SOBuildingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewBuilding];
            if (annotationView) {
                annotationView.annotation = annotation;
            } else {
                annotationView = [[SOBuildingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewBuilding];
            }
            annotationView.canShowCallout = NO;
            return annotationView;

        } else {
            return nil;
        }
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view isMemberOfClass:[SOSubwayStopAnnotationView class]]) {
        self.selectSubwayAnnotation = (SOSubwayAnnotation *)view.annotation;
        NSLog(@"%@,%@", @(self.selectSubwayAnnotation.coordinate.latitude), @(self.selectSubwayAnnotation.coordinate.longitude));

        if (self.subwayCircle) {
            [self.mapView removeOverlay:self.subwayCircle];
        }
        [self.mapView setZoomLevel:ZoomLevelBuilding];
        SOSubwayAnnotation *annotation = (SOSubwayAnnotation *)view.annotation;
        self.subwayCircle = [MACircle circleWithCenterCoordinate:annotation.coordinate radius:1000];
        [self.mapView addOverlay:self.subwayCircle];
        [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    } else {
        CLLocationCoordinate2D coordinate = view.annotation.coordinate;
        if (self.mapZoomLevel <= ZoomLevelArea) {
            [self removeAnnotations];
            [self.mapView setCenterCoordinate:coordinate animated:NO];
            self.mapZoomLevel = ZoomLevelBlock;
            [self.mapView setZoomLevel:ZoomLevelBlock];
        } else if (self.mapZoomLevel <= ZoomLevelBlock && self.mapZoomLevel > ZoomLevelArea) {
            [self removeAnnotations];
            [self.mapView setCenterCoordinate:coordinate animated:NO];
            self.mapZoomLevel = ZoomLevelBuilding;
            [self.mapView setZoomLevel:ZoomLevelBuilding];
        } else {
            if ([view.annotation isKindOfClass:[SOPointAnnotation class]]) {
                SOPointAnnotation *annotation = (SOPointAnnotation *)view.annotation;
                if (annotation.buildingId) {
                    self.shouldLoadAnnotation = YES;
                    SOBuildingDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SOBuildingDetailViewController"];
                    controller.userInfo = @{ @"buildingId" : annotation.buildingId,
                                             @"screenModel" : self.menuManager.screenModel,
                                             @"title" : annotation.title };
                    [OMNavigationManager pushController:controller];
                }
                [mapView deselectAnnotation:view.annotation animated:NO];
            }
        }
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    [self.mapView removeOverlay:self.subwayCircle];
    self.subwayCircle = nil;
}

- (void)mapViewDidFinishLoading:(MAMapView *)mapView
{
    [self fetchDataWithKeyword:nil];
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (mapView.zoomLevel != self.mapZoomLevel) {
        self.mapZoomLevel = mapView.zoomLevel;
        if (self.subwayCircle && mapView.zoomLevel < 15) {
            [mapView deselectAnnotation:self.selectSubwayAnnotation animated:NO];
            [mapView removeOverlay:self.subwayCircle];
        }
        self.keyword = nil;
        self.searchTextField.text = nil;
        [self removeAnnotations];
        [self fetchDataWithKeyword:nil];
    } else {
        self.mapZoomLevel = mapView.zoomLevel;
        if (!self.keyword) {
            [self fetchDataWithKeyword:nil];
        }
    }
}

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self cancelTask];
}


- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    self.subwayButton.enabled = YES;
    [self.subwayLines removeAllObjects];
    for (AMapBusLine *busLine in response.buslines) {
        NSInteger index = [response.buslines indexOfObject:busLine];
        if (index % 2) {
            [self.subwayLines addObject:busLine];
        }
    }
}


#pragma mark - Getters and Setters

- (NSArray *)subwayPickerTitles
{
    NSMutableArray *array = @[ @"关闭" ].mutableCopy;
    for (AMapBusLine *busline in self.subwayLines) {
        NSMutableString *muStr = [NSMutableString stringWithString:busline.name];
        // 去除括号中的字
        while (1) {
            NSRange range = [muStr rangeOfString:@"("];
            NSRange range1 = [muStr rangeOfString:@")"];
            if (range.location != NSNotFound) {
                NSInteger loc = range.location;
                NSInteger len = range1.location - range.location;
                [muStr deleteCharactersInRange:NSMakeRange(loc, len + 1)];
            } else {
                break;
            }
        }
        NSInteger index = [array indexOfObjectPassingTest:^BOOL(NSString *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            return [obj isEqualToString:muStr];
        }];
        if (index == NSNotFound) {
            [array addObject:muStr];
        }
    }
    return array;
}

- (SODropDownMenuManager *)menuManager
{
    if (!_menuManager) {
        _menuManager = [[SODropDownMenuManager alloc] initWithFrame:CGRectMake(10, 66, self.view.width - 20, 35) showType:TypeMap];
        _menuManager.delegate = self;
    }
    return _menuManager;
}

- (void)setScreenItems:(SOScreenItems *)screenItems
{
    _menuManager.screenItems = screenItems;
    [self fetchDataWithKeyword:nil];
}

- (void)setShouldLoad:(BOOL)shouldLoad
{
    _shouldLoad = shouldLoad;
    if (shouldLoad) {
        [self fetchDataWithKeyword:nil];
    }
}
- (void)setMapZoomLevel:(MapZoomLevel)mapZoomLevel
{
    if (mapZoomLevel <= ZoomLevelArea) {
        _mapZoomLevel = ZoomLevelArea;
    } else if (mapZoomLevel > ZoomLevelArea && mapZoomLevel <= ZoomLevelBlock) {
        _mapZoomLevel = ZoomLevelBlock;
    } else if (mapZoomLevel > ZoomLevelBlock) {
        _mapZoomLevel = ZoomLevelBuilding;
    } else {
    }
}
- (NSMutableArray *)requests
{
    if (_requests == nil) {
        _requests = [[NSMutableArray alloc] init];
    }
    return _requests;
}

- (NSMutableArray *)annotations
{
    if (_annotations == nil) {
        _annotations = [[NSMutableArray alloc] init];
    }
    return _annotations;
}

- (NSMutableArray *)subwayAnnotations
{
    if (_subwayAnnotations == nil) {
        _subwayAnnotations = [[NSMutableArray alloc] init];
    }
    return _subwayAnnotations;
}

- (NSMutableArray *)subwayLines
{
    if (_subwayLines == nil) {
        _subwayLines = [[NSMutableArray alloc] init];
    }
    return _subwayLines;
}

- (ActionSheetStringPicker *)subwayPicker
{
    _subwayPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"地铁选择" rows:[self subwayPickerTitles] initialSelection:self.pickerIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self showSubwayWithBusLineKeyword:selectedValue];
        _pickerIndex = selectedIndex;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    } origin:self.view];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setBackgroundColor:[UIColor at_deepSkyBlueColor]];
    [_subwayPicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    return _subwayPicker;
}

@end
