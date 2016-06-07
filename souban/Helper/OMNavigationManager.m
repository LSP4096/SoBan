//
//  OMNavigationManager.m
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMNavigationManager.h"
#import "UIViewController+TopViewController.h"


@implementation OMNavigationManager

+ (void)pushController:(UIViewController *)controller
{
    if ([UIViewController topViewController].navigationController && controller) {
        [[UIViewController topViewController].navigationController pushViewController:controller animated:YES];
    }
}

+ (void)pushControllerWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    id controller = identifier.length == 0 ? [storyboard instantiateInitialViewController] : [storyboard instantiateViewControllerWithIdentifier:identifier];

    if ([controller isKindOfClass:[UINavigationController class]]) {
        controller = [controller viewControllers].firstObject;
    }
    if ([controller conformsToProtocol:@protocol(OMBaseControllerProtocol)]) {
        [controller setUserInfo:userInfo];
    }
    [[self class] pushController:controller];
}

+ (void)modalController:(UIViewController *)controller
{
    id targetController = controller;
    if (![controller isKindOfClass:[UINavigationController class]]) {
        targetController = [[UINavigationController alloc] initWithRootViewController:controller];
    }
    if ([UIViewController topViewController] && targetController) {
        [[UIViewController topViewController] presentViewController:targetController animated:YES completion:nil];
    }
}

+ (void)modalControllerWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    id controller = identifier.length == 0 ? [storyboard instantiateInitialViewController] : [storyboard instantiateViewControllerWithIdentifier:identifier];
    id targetController = controller;

    if ([controller isKindOfClass:[UINavigationController class]]) {
        controller = [controller viewControllers].firstObject;
    }
    if ([controller conformsToProtocol:@protocol(OMBaseControllerProtocol)]) {
        [controller setUserInfo:userInfo];
    }
//    if ([UIViewController topViewController] && controller) {
//        [[UIViewController topViewController] presentViewController:targetController animated:YES completion:nil];
//    }
    [[self class] modalController:targetController];
}
@end
