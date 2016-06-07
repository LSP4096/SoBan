//
//  UIStoryboard+SO.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kStoryboardMain = @"Main";
static NSString *const kStoryboardAuthentication = @"Authentication";
static NSString *const kStoryboardBuilding = @"Building";
static NSString *const kStoryboardService = @"Service";
static NSString *const kStoryboardUser = @"User";
static NSString *const kStoryboardMap = @"Map";
static NSString *const kStoryboardCommon = @"Common";
static NSString *const kStoryboardExplore = @"Explore";


@interface UIStoryboard (SO)

+ (instancetype)main;
+ (instancetype)authentication;
+ (instancetype)building;
+ (instancetype)service;
+ (instancetype)user;
+ (instancetype)map;
+ (instancetype)common;
+ (instancetype)explore;

@end
