//
//  UIColor+Hex.m
//  HBToolkit
//
//  Created by Limboy on 12/26/13.
//  Copyright (c) 2013 Huaban. All rights reserved.
//

#import "UIColor+Hex.h"


@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha
{
    int r = (hex >> 16) & 255;
    int g = (hex >> 8) & 255;
    int b = hex & 255;

    float rf = (float)r / 255.0f;
    float gf = (float)g / 255.0f;
    float bf = (float)b / 255.0f;

    return [UIColor colorWithRed:rf green:gf blue:bf alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hex
{
    return [self colorWithHex:hex alpha:1];
}

@end
