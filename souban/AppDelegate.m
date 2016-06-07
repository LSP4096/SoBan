//
//  AppDelegate.m
//  souban
//
//  Created by 周国勇 on 10/23/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "AppDelegate.h"
#import "kCommonMacro.h"
#import <PonyDebugger.h>
#import <FirVersionCompare.h>
#import "UIColor+OM.h"
//#import <BugHD/BugHD.h>
#import "UIWebView+MakeCall.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AFNetworking.h>
#import "OMHTTPClient.h"
#import "OMResponse.h"
#import "SOBuilding.h"
#import <MobClick.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "OMNavigationManager.h"
#import "NSURL+Parameters.h"
#import "SOWebViewController.h"
#import "SOApplyPartnerTableViewController.h"
#import "SOGiftsDetailViewController.h"
#import "OMHTTPClient+Building.h"
#import "SOCity.h"


@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTintColor:[UIColor slateGrey]];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, -2, 0);
    UIImage *backArrowImage = [[UIImage imageNamed:@"iconBackArrow"] imageWithAlignmentRectInsets:insets];

    [[UINavigationBar appearance] setBackIndicatorImage:backArrowImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backArrowImage];

    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                [UIColor at_slateGreyColor], NSForegroundColorAttributeName,
                                                                [UIFont boldSystemFontOfSize:18], NSFontAttributeName,
                                                                nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

    [MAMapServices sharedServices].apiKey = kMapKey;
    [AMapSearchServices sharedServices].apiKey = kMapKey;

    [MobClick setCrashReportEnabled:NO];

#ifdef RELEASE
    [MobClick startWithAppkey:kUMengKey reportPolicy:BATCH channelId:@"Fir"];
    [FirVersionCompare compareVersionWithApiKey:kFirApiKey];

#endif

#ifdef DISTRIBUTION
    [MobClick startWithAppkey:kUMengKey reportPolicy:BATCH channelId:@"AppStore"];
#endif


#if DEBUG
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger connectToURL:[NSURL URLWithString:@"ws://10.0.0.18:9000/device"]];
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];

#endif
    
    [SOCity checkCity];

#ifndef DEBUG
    [Fabric with:@[ [Crashlytics class] ]];
#endif

    self.window.backgroundColor = [UIColor whiteColor];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    if ([url.scheme isEqualToString:kOMUniversalScheme]) {
        NSString *type = url.parameters[@"type"];
        NSString *uniqueId = url.parameters[@"id"];
        if ([type isEqualToString:@"gift"] || uniqueId ) {
            SOGiftsDetailViewController *controller = [[UIStoryboard explore] instantiateViewControllerWithIdentifier:[SOGiftsDetailViewController storyboardIdentifier]];
            controller.userInfo = @{@"url":[NSString stringWithFormat:@"http://m.91souban.com/enterprise/gift?id=%@", uniqueId]};
            [OMNavigationManager pushController:controller];
        } else if ([type isEqualToString:@"joinPartners"]) {
            SOApplyPartnerTableViewController *controller = [[UIStoryboard explore] instantiateViewControllerWithIdentifier:[SOApplyPartnerTableViewController storyboardIdentifier]];
            [OMNavigationManager pushController:controller];
        }
        return YES;
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
