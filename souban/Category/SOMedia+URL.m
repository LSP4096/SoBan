//
//  SOMedia+URL.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOMedia+URL.h"
#import "kCommonMacro.h"


@implementation SOMedia (URL)
- (NSURL *)originURL
{
    NSString *urlString = self.url;
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        DDLogError(@"error: URL is nil");
    }
    return url;
}

- (NSURL *)webpURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@!/format/webp", self.url]];
}

- (NSURL *)webpURLWithWidth:(CGFloat)width
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@!/fw/%0.0lf/format/webp", self.url, width]];
}

- (NSURL *)thumbURL
{
    NSString *urlString = [self.url copy];
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
