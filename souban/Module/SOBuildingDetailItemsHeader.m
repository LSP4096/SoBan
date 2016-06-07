//
//  SOBuildingDetailItemsHeader.m
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailItemsHeader.h"
#import "SOBuildingDetailItemsCollectionCell.h"
#import "UICollectionView+RegisterNib.h"
#import "SOBuilding.h"
#import "NSNumber+Formatter.h"
#import "OMHTTPClient.h"
#import "OMNavigationManager.h"
#import "SOWebViewController.h"


@interface SOBuildingDetailItemsHeader () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSArray *buildingSummaryItems;

@end


@implementation SOBuildingDetailItemsHeader
@dynamic contentView;

+ (CGFloat)height
{
    return 223;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.collectionView registerCellNibWithClassIdentifier:[SOBuildingDetailItemsCollectionCell reuseIdentifier]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)configHeaderWithModel:(NSArray *)buildingSummaryItems
{
    self.buildingSummaryItems = buildingSummaryItems;
    [self.collectionView reloadData];
}

#pragma mark - CollectionViewLayout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 1) / 3;
    return CGSizeMake(width, 101);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5f;
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.buildingSummaryItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SOBuildingDetailItemsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SOBuildingDetailItemsCollectionCell reuseIdentifier] forIndexPath:indexPath];
    SOBuildingSummaryItem *item = self.buildingSummaryItems[indexPath.row];
    cell.itemNameLabel.text = item.name;
    cell.valueLabel.text = item.value;
    return cell;
}

#pragma mark - Getter & Setter

@end
