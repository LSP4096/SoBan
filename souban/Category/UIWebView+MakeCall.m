//
//  UIWebView+MakeCall.m
//  souban
//
//  Created by 周国勇 on 11/4/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "UIWebView+MakeCall.h"


@implementation UIWebView (MakeCall)
+ (void)callWithURL:(NSURL *)url
{
    static UIWebView *webView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webView = [UIWebView new];
    });
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

+ (void)callWithString:(NSString *)phoneString
{
    [self callWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneString]]];
}
@end
