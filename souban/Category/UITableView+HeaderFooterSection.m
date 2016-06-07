//
//  UITableView+HeaderFooterSection.m
//  OfficeManager
//
//  Created by 周国勇 on 8/27/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "UITableView+HeaderFooterSection.h"


@implementation UITableView (HeaderFooterSection)
- (NSInteger)sectionForTableViewHeader:(UIView *)header
{
    for (NSInteger i = 0; i < self.numberOfSections; i++) {
        UITableViewHeaderFooterView *temp = [self headerViewForSection:i];
        if ([header isEqual:temp]) {
            return i;
        }
    }
    return NSNotFound;
}

- (NSInteger)sectionForTableViewFooter:(UIView *)footer
{
    for (NSInteger i = 0; i < self.numberOfSections; i++) {
        UITableViewHeaderFooterView *temp = [self footerViewForSection:i];
        if ([footer isEqual:temp]) {
            return i;
        }
    }
    return NSNotFound;
}
@end
