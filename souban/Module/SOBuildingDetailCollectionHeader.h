//
//  SOBuildingDetailCollectionHeader.h
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseTableViewHeaderFooterView.h"


@interface SOBuildingDetailCollectionHeader : OMBaseTableViewHeaderFooterView
+ (CGFloat)heightForItemsCount:(NSInteger)count;
- (void)configWihtTitle:(NSString *)title array:(NSArray *)array;
@end
