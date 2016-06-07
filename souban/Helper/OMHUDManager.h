//
//  OMHUDManager.h
//  OfficeManager
//
//  Created by 周国勇 on 8/17/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OMHUDManager : NSObject

+ (void)showSuccessWithStatus:(NSString *)string;

+ (void)showErrorWithStatus:(NSString *)string;

+ (void)showInfoWithStatus:(NSString *)string;

+ (void)showActivityIndicatorMessage:(NSString *)message;

+ (void)dismiss;
@end
