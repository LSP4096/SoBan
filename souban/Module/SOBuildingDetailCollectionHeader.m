//
//  SOBuildingDetailCollectionHeader.m
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailCollectionHeader.h"
#import "SOBuildingStation.h"
#import "UICollectionView+RegisterNib.h"
#import "SOBuildingDetailTrafficCollectionCell.h"


@interface SOBuildingDetailCollectionHeader () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *items;

@end


@implementation SOBuildingDetailCollectionHeader
@dynamic contentView;

+ (CGFloat)heightForItemsCount:(NSInteger)count
{
    if (count == 0) {
        return 0;
    }
    NSInteger row = count / 4;
    row = count % 4 == 0 ? row : row + 1;
    return [SOBuildingDetailTrafficCollectionCell stationSize].height * row + 45;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerCellNibWithClassIdentifier:[SOBuildingDetailTrafficCollectionCell reuseIdentifier]];
    self.collectionView.userInteractionEnabled = NO;
}

- (void)configWihtTitle:(NSString *)title array:(NSArray *)array
{
    self.titleLabel.text = title;
    self.items = array;
    [self.collectionView reloadData];
}

#pragma mark - CollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [SOBuildingDetailTrafficCollectionCell stationSize];
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger row = self.items.count == 0 ? 0 : self.items.count / 4;
    row = self.items.count % 4 == 0 ? row : row + 1;
    return 4 * row;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SOBuildingDetailTrafficCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SOBuildingDetailTrafficCollectionCell reuseIdentifier] forIndexPath:indexPath];
    indexPath.row >= self.items.count ? [cell configWithModel:nil] : [cell configWithModel:self.items[indexPath.row]];
    return cell;
}
@end
