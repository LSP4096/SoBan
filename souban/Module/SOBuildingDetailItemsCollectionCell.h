//
//  SOBuildingDetailItemsCollectionCell.h
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseCollectionViewCell.h"


@interface SOBuildingDetailItemsCollectionCell : OMBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

+ (CGSize)cellSize;

@end
