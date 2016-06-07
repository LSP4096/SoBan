//
//  OMHUDManager.m
//  OfficeManager
//
//  Created by 周国勇 on 8/17/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMHUDManager.h"
#import <SVProgressHUD.h>


@implementation OMHUDManager

+ (void)showSuccessWithStatus:(NSString *)string
{
    [SVProgressHUD showSuccessWithStatus:string];
}


+ (void)showErrorWithStatus:(NSString *)string
{
    [SVProgressHUD showErrorWithStatus:string];
}

+ (void)showInfoWithStatus:(NSString *)string
{
    [SVProgressHUD showInfoWithStatus:string];
}

+ (void)showActivityIndicatorMessage:(NSString *)message
{
    [SVProgressHUD showWithStatus:message
                         maskType:SVProgressHUDMaskTypeBlack];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

@end
