//
//  NSBundle+Nib.h
//  BailkalTravel
//
//  Created by 周国勇 on 7/16/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSBundle (Nib)

+ (__kindof UIView *)loadNibFromMainBundleWithClass:(Class) class;

@end
