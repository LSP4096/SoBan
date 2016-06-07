//
//  OMBaseModel+Select.m
//  OfficeManager
//
//  Created by 周国勇 on 9/9/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMBaseModel+Select.h"
#import <objc/runtime.h>


@implementation OMBaseModel (Select)

static void *OMPromiseSelectedKey = &OMPromiseSelectedKey;
- (void)setSelected:(BOOL)selected
{
    objc_setAssociatedObject(self, &OMPromiseSelectedKey,
                             @(selected), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)selected
{
    return [objc_getAssociatedObject(self, &OMPromiseSelectedKey) boolValue];
}

@end
