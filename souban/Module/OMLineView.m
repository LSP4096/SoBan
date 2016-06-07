//
//  OMLineView.m
//  OfficeManager
//
//  Created by 周国勇 on 8/17/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMLineView.h"
#import "UIColor+OM.h"


@implementation OMLineView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor grayLineColor];
}

@end
