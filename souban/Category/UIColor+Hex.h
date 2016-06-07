//
//  UIColor+Hex.h
//  HBToolkit
//
//  Created by Limboy on 12/26/13.
//  Copyright (c) 2013 Huaban. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(int)hex;
+ (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha;
@end
