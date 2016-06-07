//
//  SOBuildingDetailMapHeader.h
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewHeaderFooterView.h"


@interface SOBuildingDetailMapHeader : OMBaseTableViewHeaderFooterView

+ (CGFloat)height;
- (void)configWithAddress:(NSString *)address location:(NSString *)GPS title:(NSString *)title;

@end
