//
//  SOHomePageViewController.m
//  souban
//
//  Created by 周国勇 on 12/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOHomePageViewController.h"
#import "UIColor+OM.h"
#import "SOBuildingMapViewController.h"
#import "SOBuildingListViewController.h"
#import "UIStoryboard+SO.h"
#import "Masonry.h"
#import "OMNavigationManager.h"
#import "SOSearchViewController.h"
#import "NSNotificationCenter+OM.h"
#import "SORefreshHeader.h"
#import "UIViewController+TopViewController.h"
#import "OMHTTPClient+Building.h"
#import "OMHUDManager.h"
#import "SOCity.h"

@interface SOHomePageViewController () <SOBuildingMapViewControllerDelegate, SOSearchViewControllerDelegate>

@property (strong, nonatomic) SOBuildingMapViewController *mapViewController;
@property (strong, nonatomic) SOBuildingListViewController *listViewController;
@property (weak, nonatomic) IBOutlet UIView *searchBarContarnerView;
@property (weak, nonatomic) IBOutlet UILabel *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


@end


@implementation SOHomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.barTintColor = [UIColor at_deepSkyBlueColor];

    self.mapViewController.delegate = self;

    [self.view addSubview:self.mapViewController.view];
    [self.view addSubview:self.listViewController.view];
    [self.mapViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.top.equalTo(self.view.mas_top);
    }];

    [self.listViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);

        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.top.equalTo(self.mas_topLayoutGuide);
    }];
    [NSNotificationCenter registerNotificationWithObserver:self selector:@selector(cityChanged:) name:kCityChanged];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    NSString *name = [[SOCity city].name substringToIndex:[SOCity city].name.length-1];
    self.cityLabel.text = name.length==0?@"杭州":name;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.barTintColor = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor at_deepSkyBlueColor];

    if ([self.view.subviews.lastObject isEqual:self.mapViewController.view]) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private
- (void)cityChanged:(NSNotification *)notification {
    if (notification.userInfo[@"city"]) {
        NSString *name = [[SOCity city].name substringToIndex:[SOCity city].name.length-1];
        self.cityLabel.text = name.length==0?@"杭州":name;
    }
}

#pragma mark - Action
- (IBAction)searchBarTapped:(id)sender {
    SOSearchViewController *controller = [[UIStoryboard building] instantiateViewControllerWithIdentifier:[SOSearchViewController storyboardIdentifier]];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.delegate = self;
    [[UIViewController topViewController] presentViewController:controller animated:YES completion:nil];
}

- (IBAction)leftBarButtonTapped:(id)sender {
    [OMNavigationManager modalControllerWithStoryboardName:kStoryboardBuilding identifier:@"SOCityChooseTableViewNavigationController" userInfo:nil];
}
#pragma mark - System
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.view.subviews.lastObject isEqual:self.listViewController.view] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

#pragma mark - SOBuildingMapViewControllerDelegate
- (void)flipButtonTapped
{
    [UIView beginAnimations:@"doflip" context:nil];
    [UIView setAnimationDuration:0.5];                                                                 // 动画时长
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];                                          // 设置动画淡入淡出
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES]; // 动画翻转方向
    [self.view bringSubviewToFront:self.listViewController.view];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    [UIView commitAnimations]; // 动画结束
}

- (void)animationDidStop
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.listViewController.menuManager.screenModel = self.mapViewController.menuManager.screenModel;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Action
- (IBAction)rightBarbuttonTapped:(id)sender
{
    [self setNeedsStatusBarAppearanceUpdate];

    self.navigationController.navigationBarHidden = YES;

    self.mapViewController.menuManager.screenModel = self.listViewController.menuManager.screenModel;
    self.mapViewController.menuManager.screenItems = self.listViewController.menuManager.screenItems;
    self.mapViewController.shouldLoad = YES;
    [UIView beginAnimations:@"doflip" context:nil];
    [UIView setAnimationDuration:0.5];                                                                 // 动画时长
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];                                          // 设置动画淡入淡出
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES]; // 动画翻转方向
    [self.view bringSubviewToFront:self.mapViewController.view];
    [self setNeedsStatusBarAppearanceUpdate];

    [UIView setAnimationDelegate:self];

    [UIView commitAnimations]; // 动画结束
}

#pragma mark - SOSearchController Delegate
- (void)searchViewControllerDidSearchWithKeyword:(NSString *)keyword
{
    OMBaseViewController *controller = [[UIStoryboard building] instantiateViewControllerWithIdentifier:[SOBuildingListViewController storyboardIdentifier]];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userInfo = @{ @"hideScreenBar" : @YES,
                             @"keyword" : keyword };
//    self.searchTextField.text = keyword;
    [OMNavigationManager pushController:controller];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToSearch"]) {
        SOSearchViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - Getter
- (SOBuildingMapViewController *)mapViewController
{
    if (!_mapViewController) {
        _mapViewController = [[UIStoryboard building] instantiateViewControllerWithIdentifier:[SOBuildingMapViewController storyboardIdentifier]];
    }
    return _mapViewController;
}

- (SOBuildingListViewController *)listViewController
{
    if (!_listViewController) {
        _listViewController = [[UIStoryboard building] instantiateViewControllerWithIdentifier:[SOBuildingListViewController storyboardIdentifier]];
    }
    return _listViewController;
}
@end
