//
//  SOBuildingDetailItemsHeader.h
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewHeaderFooterView.h"

/**
 *  地图以及各个条目展示的Header
 */
@class SOBuilding;


@interface SOBuildingDetailItemsHeader : OMBaseTableViewHeaderFooterView

+ (CGFloat)height;
- (void)configHeaderWithModel:(NSArray *)buildingSummaryItems;

@end
