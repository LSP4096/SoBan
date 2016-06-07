//
//  NSBundle+Nib.m
//  BailkalTravel
//
//  Created by 周国勇 on 7/16/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "NSBundle+Nib.h"
#import <UIKit/UIKit.h>


@implementation NSBundle (Nib)

+ (__kindof UIView *)loadNibFromMainBundleWithClass:(Class) class
{
    id object = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(class) owner:nil options:nil].lastObject;
    if (![object isKindOfClass:class]) {
        NSLog(@"%@ is not kindof %@", object, NSStringFromClass(class));
    }
    return object;
}

@end
