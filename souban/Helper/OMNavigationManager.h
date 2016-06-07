//
//  OMNavigationManager.h
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMBaseControllerProtocol.h"
#import "UIStoryboard+SO.h"

/**
 *  管理各种导航的跳转
 */
@interface OMNavigationManager : NSObject

+ (void)pushController:(UIViewController *)controller;
+ (void)pushControllerWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo;

+ (void)modalController:(UIViewController *)controller;
+ (void)modalControllerWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo;
@end
