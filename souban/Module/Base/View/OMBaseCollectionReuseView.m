//
//  OMBaseCollectionReuseView.m
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMBaseCollectionReuseView.h"


@implementation OMBaseCollectionReuseView

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
