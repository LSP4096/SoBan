//
//  OMHTTPClient+Main.m
//  souban
//
//  Created by 周国勇 on 1/13/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "OMHTTPClient+Main.h"
#import "SOLaunchOptions.h"

@implementation OMHTTPClient (Main)

- (NSURLSessionDataTask *)fetchLaunchOptionsWithCompletion:(jsonResultBlock)completion
{
    NSString *localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    CGFloat coefficient = [UIScreen mainScreen].bounds.size.width == 414?3:2;

    NSDictionary *para = @{@"width":@([UIScreen mainScreen].bounds.size.width*coefficient),
                           @"height":@([UIScreen mainScreen].bounds.size.height*coefficient),
                           @"version":localVersion,
                           @"type":@(1)};
    return [self getWithRoutePath:@"launchOptions" params:para parseClass:[SOLaunchOptions class] block:completion];
}

@end
