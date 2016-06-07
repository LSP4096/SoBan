//
//  SOBuildingDetailSurroundFooter.h
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewHeaderFooterView.h"

@class SOBuilding;


@interface SOBuildingDetailSurroundFooter : OMBaseTableViewHeaderFooterView

+ (CGFloat)height;
- (void)configWithModel:(SOBuilding *)building;

@end
