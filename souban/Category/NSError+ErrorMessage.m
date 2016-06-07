//
//  NSError+ErrorMessage.m
//  BailkalTravel
//
//  Created by 周国勇 on 7/28/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "NSError+ErrorMessage.h"
#import <UIKit/UIKit.h>
#import "OMHTTPClient.h"
#import "OMHUDManager.h"


@implementation NSError (ErrorMessage)

- (NSString *)errorMessage
{
    if (self.code == kCFURLErrorTimedOut) {
        return @"请求超时，请稍后重试";
    }
    if ([self.domain isEqualToString:[NSBundle mainBundle].bundleIdentifier]) {
        if (self.code == kJSONConvertError) {
            return @"数据解析异常";
        }
        return self.userInfo[@"errorMsg"];
    }
    return [NSString stringWithFormat:@"%@", self.localizedDescription];
}

- (BOOL)hudMessage
{
    if (self.errorMessage.length == 0) {
        return NO;
    }
    [OMHUDManager showErrorWithStatus:self.errorMessage];
    return YES;
}
@end
