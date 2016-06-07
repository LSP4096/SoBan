//
//  SOBuildingDetailTrafficCollectionCell.h
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseCollectionViewCell.h"

@class SOTraffic, SOBuildingImageDescItem;


@interface SOBuildingDetailTrafficCollectionCell : OMBaseCollectionViewCell

+ (CGSize)cellSize;
+ (CGSize)stationSize;
- (void)configCellWithModel:(SOTraffic *)traffic index:(NSInteger)index;
- (void)configWithModel:(SOBuildingImageDescItem *)item;

@end
