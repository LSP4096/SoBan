//
//  SOBuildingDetailItemsCollectionCell.m
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailItemsCollectionCell.h"


@interface SOBuildingDetailItemsCollectionCell ()

@end


@implementation SOBuildingDetailItemsCollectionCell

+ (CGSize)cellSize
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
    return CGSizeMake(width, 101);
}

@end
