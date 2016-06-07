//
//  SOTabbarViewController.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOTabbarController.h"
#import "SOBuildingListViewController.h"
#import "SOUserCenterTableViewController.h"
#import "UIStoryboard+SO.h"
#import "UIColor+OM.h"
#import "SONavigationController.h"
#import "SOBookHouseTableViewController.h"
#import "SOServiceViewController.h"
#import "OMUser.h"
#import "OMAuthenticationViewController.h"
#import "OMNavigationManager.h"
#import "SOGuideViewController.h"
#import "GVUserDefaults+OM.h"
#import "SOBuildingStationListViewController.h"
#import "NSNotificationCenter+OM.h"
#import "SOHomePageViewController.h"
#import "SOExploreRootViewController.h"
#import "SDWebImageManager.h"
#import "SOLaunchOptions.h"
#import "YYCache+JSONModel.h"
#import "NSString+URL.h"
#import "OMHTTPClient+Main.h"
#import <UIAlertView+BlocksKit.h>

@interface SOTabbarController () <UITabBarControllerDelegate>

@end


@implementation SOTabbarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    // Do any additional setup after loading the view.
    SOHomePageViewController *buildingListController = [[UIStoryboard building] instantiateViewControllerWithIdentifier:[SOHomePageViewController storyboardIdentifier]];
    buildingListController.title = @"搜办";
    SOServiceViewController *serviceController = [[UIStoryboard service] instantiateViewControllerWithIdentifier:[SOServiceViewController storyboardIdentifier]];
    serviceController.title = @"服务";
    SOUserCenterTableViewController *usercenterController = [[UIStoryboard user] instantiateViewControllerWithIdentifier:[SOUserCenterTableViewController storyboardIdentifier]];
    usercenterController.title = @"我";
    SOExploreRootViewController *explorerController = [[UIStoryboard explore] instantiateViewControllerWithIdentifier:[SOExploreRootViewController storyboardIdentifier]];
    explorerController.title = @"发现";

    UINavigationController *buildingNav = [self navigationControllerWithRoot:buildingListController selectedImage:[UIImage imageNamed:@"ic_tab_1_selected"] normalImage:[UIImage imageNamed:@"ic_tab_1_normal"]];
    UINavigationController *serviceNav = [self navigationControllerWithRoot:serviceController selectedImage:[UIImage imageNamed:@"ic_tab_2_selected"] normalImage:[UIImage imageNamed:@"ic_tab_2_normal"]];
    UINavigationController *userNav = [self navigationControllerWithRoot:usercenterController selectedImage:[UIImage imageNamed:@"ic_tab_3_selected"] normalImage:[UIImage imageNamed:@"ic_tab_3_normal"]];
    UINavigationController *stationNav = [self navigationControllerWithRoot:explorerController selectedImage:[UIImage imageNamed:@"ic_tab_4_selected"] normalImage:[UIImage imageNamed:@"ic_tab_4_normal"]];

    // config homepage
//    [self configWhiteLabelForController:buildingNav];
    [self setViewControllers:@[ buildingNav, serviceNav, stationNav, userNav ]];

    [NSNotificationCenter registerNotificationWithObserver:self selector:@selector(authenticateFailedWithNotification:) name:kAuthFailed];
    
    [self displayLaunchImageView];
    [self checkLaunOptions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)displayLaunchImageView {
    SOLaunchOptions *launch = [YYCache JSONModelForClass:[SOLaunchOptions class]];
    
    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:launch.url.webpURL.absoluteString];
    
    if (!image) {
        [self getLaunchImageFromServer];
        [NSThread sleepForTimeInterval:3];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        imageView.image = image;
        
        UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
        [containerView addSubview:imageView];
        [self.view addSubview:containerView];
//        [self.view addSubview:imageView];
//        [self.view bringSubviewToFront:imageView];
        
        [UIView animateWithDuration:0.5 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imageView.alpha = 0;
            NSLog(@"%@", containerView.backgroundColor);
        } completion:^(BOOL finished) {
            [containerView removeFromSuperview];
//            [imageView removeFromSuperview];
        }];
    }
}

- (void)getLaunchImageFromServer {
    SOLaunchOptions *options = [YYCache JSONModelForClass:[SOLaunchOptions class]];

    if (options.url) {
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:options.url.webpURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && !error) {
                [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:options.url.webpURL.absoluteString];
            }
        }];
    }
}

- (void)checkLaunOptions {
    [[OMHTTPClient realClient] fetchLaunchOptionsWithCompletion:^(SOLaunchOptions *resultObject, NSError *error) {
        if (!error) {
            SOLaunchOptions *options = [YYCache JSONModelForClass:[SOLaunchOptions class]];
            [YYCache saveJSONModel:resultObject];
            if (options.updateTime < resultObject.updateTime) {
                [self getLaunchImageFromServer];
            }
            if (resultObject.forceUpdate) {
                [UIAlertView bk_showAlertViewWithTitle:@"提示" message:resultObject.updateMessage cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex != 0) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/sou-ban-mian-zhong-jie-fei/id1062216777?mt=8"]];
                    }
                }];
            }
        }
    }];

}

- (void)authenticateFailedWithNotification:(NSNotification *)notification
{
    OMAuthenticationViewController *loginViewController = [[UIStoryboard authentication] instantiateViewControllerWithIdentifier:[OMAuthenticationViewController storyboardIdentifier]];
    [OMNavigationManager modalController:loginViewController];
}

- (void)configWhiteLabelForController:(nonnull UINavigationController *)controller
{
    controller.navigationBar.barTintColor = [UIColor at_deepSkyBlueColor];
    UILabel *label = [UILabel new];
    label.text = controller.tabBarItem.title;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    controller.viewControllers.firstObject.navigationItem.titleView = label;
}

- (__kindof UINavigationController *)navigationControllerWithRoot:(nonnull UIViewController *)controller
                                                    selectedImage:(nonnull UIImage *)selectedImage
                                                      normalImage:(nonnull UIImage *)normalImage
{
    SONavigationController *nav = [[SONavigationController alloc] initWithRootViewController:controller];
    nav.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.title = controller.title;

    return nav;
}


#pragma mark - Tabbar Delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

#pragma mark - Getter & Setter

@end
