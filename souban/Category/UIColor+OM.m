//
//  UIColor+OM.m
//  OfficeManager
//
//  Created by 周国勇 on 8/17/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "UIColor+OM.h"
#import "UIColor+Hex.h"


@implementation UIColor (OM)

+ (UIColor *)grayLineColor
{
    return [UIColor colorWithHex:0xe0e0e0];
}

+ (UIColor *)tintBlueColor
{
    return [UIColor colorWithHex:0x682fe];
}

+ (UIColor *)slateGrey
{
    return [UIColor colorWithHex:0x5f646e];
}

+ (UIColor *)slate
{
    return [UIColor colorWithHex:0x4f5f6f];
}
@end
