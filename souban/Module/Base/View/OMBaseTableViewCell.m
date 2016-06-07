//
//  OMBaseTableViewCell.m
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMBaseTableViewCell.h"


@implementation OMBaseTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([self respondsToSelector:@selector(separatorInset)]) {
        self.separatorInset = UIEdgeInsetsZero;
    }
    if ([self respondsToSelector:@selector(preservesSuperviewLayoutMargins)]) {
        self.preservesSuperviewLayoutMargins = false;
    }
    if ([self respondsToSelector:@selector(layoutMargins)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    }
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
