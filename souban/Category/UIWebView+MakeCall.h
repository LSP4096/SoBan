//
//  UIWebView+MakeCall.h
//  souban
//
//  Created by 周国勇 on 11/4/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIWebView (MakeCall)

+ (void)callWithURL:(NSURL *)url;
+ (void)callWithString:(NSString *)phoneString;

@end
