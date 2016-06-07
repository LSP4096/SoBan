//
//  UIImage+Placeholder.m
//  OfficeManager
//
//  Created by 周国勇 on 9/11/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "UIImage+Placeholder.h"


@implementation UIImage (Placeholder)
+ (UIImage *)placeholder
{
    return nil;
    //    return [UIImage imageNamed:@"ic_user_placeholder" inBundle:nil compatibleWithTraitCollection:nil];
}

+ (UIImage *)bannerPlaceholder
{
    return [UIImage imageNamed:@"banner_placeholder" inBundle:nil compatibleWithTraitCollection:nil];
}

@end
