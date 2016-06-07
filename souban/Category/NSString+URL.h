//
//  NSString+URL.h
//  OfficeManager
//
//  Created by 周国勇 on 9/2/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (URL)

- (NSURL *)originURL;
- (NSURL *)webpURL;
- (NSURL *)webpURLWithWidth:(CGFloat)width;
- (NSURL *)thumbURL;

@end
