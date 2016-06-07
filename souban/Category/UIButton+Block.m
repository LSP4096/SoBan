//
//  UIButton+Block.m
//  OfficeManager
//
//  Created by JiaHao on 9/23/15.
//  Copyright © 2015 whalefin. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>
static const void *UIButtonBlockKey = &UIButtonBlockKey;


@implementation UIButton (Block)

- (void)addActionHandler:(ActionBlock)touchHandler
{
    objc_setAssociatedObject(self, UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)actionTouched:(UIButton *)btn
{
    ActionBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        block(btn.tag);
    }
}

@end
