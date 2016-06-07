//
//  SOSurroundMapViewController.m
//  souban
//
//  Created by 周国勇 on 11/23/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOSurroundMapViewController.h"
//#import <BaiduMapAPI_Map/BMKMapComponent.h>
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "OMHUDManager.h"
#import "kCommonMacro.h"
#import <CoreLocation/CoreLocation.h>
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "UIView+Layout.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "NSError+ErrorMessage.h"
#import "NSString+Location.h"


@interface SOSurroundMapViewController () <MAMapViewDelegate, AMapSearchDelegate>

@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLeftConstraint;
@property (strong, nonatomic) id<MAAnnotation> locationAnnotation;
@property (strong, nonatomic) NSString *keyword;
@property (nonatomic, strong) AMapSearchAPI *search;

@end


@implementation SOSurroundMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.fd_interactivePopDisabled = YES;

    self.mapView.delegate = self;
    self.mapView.showsBuildings = YES;
    self.mapView.showsCompass = YES;
    self.mapView.centerCoordinate = [self gpsLocation].AmapCoordinate;
    self.mapView.zoomLevel = 20;
    self.mapView.rotateEnabled = YES;

    [self itemButtonTapped:self.buttons.firstObject];

    MAPointAnnotation *item = [[MAPointAnnotation alloc] init];
    item.coordinate = [self gpsLocation].AmapCoordinate;
    item.title = self.userInfo[@"title"];
    self.locationAnnotation = item;
    [self.mapView addAnnotation:self.locationAnnotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _mapView.delegate = nil;
}

#pragma mark - Private
- (void)refreshMapViewWithKeyword:(NSString *)keyword
{
    self.keyword = keyword;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:[self gpsLocation].latitude longitude:[self gpsLocation].longitude];
    request.keywords = keyword;
    /* 按照距离排序. */
    request.sortrule = 1;
    request.requireExtension = YES;
    request.page = 1;
    request.offset = 50;
    request.radius = 1000;

    [self.search AMapPOIAroundSearch:request];
}

#pragma mark - Action
- (IBAction)itemButtonTapped:(UIButton *)sender
{
    NSArray *names = @[ @"餐饮", @"公交", @"地铁", @"银行", @"酒店", @"健身" ];
    [self refreshMapViewWithKeyword:names[sender.tag]];

    for (UIButton *button in self.buttons) {
        button.selected = NO;
    }
    sender.selected = YES;

    [UIView animateWithDuration:0.2 animations:^{
        self.lineViewLeftConstraint.constant = sender.width*sender.tag;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Annotation Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation;
{
    // 生成重用标示identifier
    static NSString *const AnnotationViewID = @"SOSurroundMapAnnotation";

    // 检查是否有重用的缓存
    MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];

    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置重天上掉下的效果(annotation)
        ((MAPinAnnotationView *)annotationView).animatesDrop = YES;
    }

    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    if ([[annotation title] isEqualToString:self.userInfo[@"title"]]) {
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"ic_location_red"];
        annotationView.layer.zPosition = 1;
    } else {
        annotationView.layer.zPosition = 0;
        annotationView.canShowCallout = YES;
        NSArray *names = @[ @"餐饮", @"公交", @"地铁", @"银行", @"酒店", @"健身" ];
        NSArray *imageNames = @[ @"iconMapdetailEat", @"iconMapdetailBus", @"iconMapdetailSubway", @"iconMapdetailBank", @"iconMapdetailHotel", @"iconMapdetailBodybuilding" ];
        NSInteger index = [names indexOfObject:self.keyword];
        annotationView.image = [UIImage imageNamed:imageNames[index]];
    }

    // 设置是否可以拖拽
    annotationView.draggable = NO;

    return annotationView;
}

#pragma mark - POI Search Delegate
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0) {
        [OMHUDManager showErrorWithStatus:@"暂无搜索结果"];
        return;
    }

    NSMutableArray *array = [NSMutableArray arrayWithArray:self.mapView.annotations];
    [array removeObject:self.locationAnnotation];
    [self.mapView removeAnnotations:array];

    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];

    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {

        MAPointAnnotation* item = [[MAPointAnnotation alloc]init];
        item.coordinate = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
        item.title = obj.name;
        item.subtitle = obj.address;
        [poiAnnotations addObject:item];
    }];

    [self.mapView addAnnotations:poiAnnotations];

    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [OMHUDManager showErrorWithStatus:error.errorMessage];
}

#pragma mark - Getter
- (NSString *)gpsLocation
{
    return self.userInfo[@"gpsLocation"];
}

- (AMapSearchAPI *)search
{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}
@end
