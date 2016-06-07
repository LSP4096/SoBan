//
//  NSString+URL.m
//  OfficeManager
//
//  Created by 周国勇 on 9/2/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "NSString+URL.h"
#import "NSString+URLEncoding.h"
#import "kCommonMacro.h"


@implementation NSString (URL)

- (NSURL *)originURL
{
    NSString *urlString = self;

    urlString = [urlString stringByURLDecoding];
    NSURL *url = [NSURL URLWithString:[urlString stringByURLEncoding]];

    if (!url) {
        DDLogError(@"error: URL is nil");
    }
    return url;
}

- (NSURL *)webpURL
{
    NSString *urlString = [self stringByURLEncoding];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!/format/webp", urlString]];
    
    if (!url) {
        DDLogError(@"error: URL is nil");
    }
    return url;
}

- (NSURL *)webpURLWithWidth:(CGFloat)width
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@!/fw/%0.0lf/format/webp", self, width]];
}

- (NSURL *)thumbURL
{
    NSString *urlString = [self copy];
    if ([urlString rangeOfString:@"!abc"].location != NSNotFound) {
        urlString = [urlString stringByReplacingOccurrencesOfString:@"!abc" withString:@""];
        urlString = [urlString stringByAppendingString:@"!v2"];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        DDLogError(@"error: URL is nil");
    }
    return url;
}
@end
