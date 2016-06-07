//
//  UITableView+HeaderFooterSection.h
//  OfficeManager
//
//  Created by 周国勇 on 8/27/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableView (HeaderFooterSection)

- (NSInteger)sectionForTableViewHeader:(UIView *)header;
- (NSInteger)sectionForTableViewFooter:(UIView *)footer;

@end
