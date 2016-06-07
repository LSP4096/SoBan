//
//  SOBuildingDetailTrafficHeader.m
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailTrafficHeader.h"
#import "SOBuildingDetailTrafficCollectionCell.h"
#import "UICollectionView+RegisterNib.h"
#import "SOTraffic.h"
#import "NSNumber+Formatter.h"
#import "SOBuilding.h"
#import "SOBuildingStation.h"
#import "Masonry.h"


@interface SOBuildingDetailTrafficHeader () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parkingViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *parkingLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;
@property (strong, nonatomic) SOBuilding *building;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) SOBuildingStation *buildingStation;
@property (weak, nonatomic) IBOutlet UIView *parkingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trafficHeightConstraint;

@end


@implementation SOBuildingDetailTrafficHeader
@dynamic contentView;

+ (CGFloat)heightForBuilding:(SOBuilding *)building
{
    if (building.traffic.count == 0) {
        return 52 + 10;
    }
    return 277;
}

+ (CGFloat)stationHeightForBuilding:(SOBuildingStation *)building
{
    if (building.traffic.count == 0) {
        return 0;
    }
    return 277 - 52 - 10;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.collectionView registerCellNibWithClassIdentifier:[SOBuildingDetailTrafficCollectionCell reuseIdentifier]];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)configCellWithBuilding:(SOBuilding *)building
{
    self.building = building;
    [self.collectionView reloadData];
    if (self.building.traffic.count == 0) {
        self.trafficHeightConstraint.constant = 0;
        self.bottomConstraint.constant = 0;
    }
    NSString *countString = [NSString stringWithFormat:@"共%@个停车位", building.parkingInfo.parkingCount];
    
    NSString *hourString = nil;
    NSString *monthString = nil;

    if (building.parkingInfo.parkingExpensesHour.integerValue == 0) {
        hourString = @"，临时停车免费";
    } else if (building.parkingInfo.parkingExpensesHour.integerValue > 0) {
        hourString = [NSString stringWithFormat:@"，每小时%@元", building.parkingInfo.parkingExpensesHour];
    }
    
    if (building.parkingInfo.parkingExpenses.integerValue == 0) {
        monthString = @"，包月免费";
    } else if (building.parkingInfo.parkingExpenses.integerValue > 0) {
        monthString = [NSString stringWithFormat:@"，%@", building.parkingInfo.parkingExpenses.perMonth];
    }
    
    if (hourString) {
        countString = [countString stringByAppendingString:hourString];
    }
    if (monthString){
        countString = [countString stringByAppendingString:monthString];
    }
    
    self.parkingLabel.text = countString;
    SOTraffic *model = self.building.traffic.firstObject;
    self.itemDescriptionLabel.text = model.trafficDescription;
}

- (void)configCellWithStation:(SOBuildingStation *)station
{
    self.building = nil;
    self.parkingViewHeightConstraint.constant = 0;
    self.bottomConstraint.constant = 0;
    
    __weak __typeof(&*self)weakSelf = self;
    [self.parkingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.height.mas_equalTo(0);
    }];

    self.parkingView.hidden = YES;
    self.buildingStation = station;
    [self.collectionView reloadData];
    
    if (self.buildingStation.traffic.count == 0) {
        self.trafficHeightConstraint.constant = 0;
    }

    SOTraffic *model = self.buildingStation.traffic.firstObject;
    self.itemDescriptionLabel.text = model.trafficDescription;
}

#pragma mark - CollectionViewLayout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [SOBuildingDetailTrafficCollectionCell cellSize];
}

#pragma mark - CollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *traffic = self.building ? self.building.traffic : self.buildingStation.traffic;
    return traffic.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SOBuildingDetailTrafficCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SOBuildingDetailTrafficCollectionCell reuseIdentifier] forIndexPath:indexPath];
    NSArray *traffic = self.building ? self.building.traffic : self.buildingStation.traffic;
    [cell configCellWithModel:traffic[indexPath.item] index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedIndexPath.row) {
        cell.selected = YES;
    } else {
        cell.selected = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *traffic = self.building ? self.building.traffic : self.buildingStation.traffic;

    SOTraffic *model = traffic[indexPath.row];
    self.itemDescriptionLabel.text = model.trafficDescription;

    self.selectedIndexPath = indexPath;
    [collectionView reloadData];
}

#pragma mark - Getter
- (NSIndexPath *)selectedIndexPath
{
    if (!_selectedIndexPath) {
        _selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }
    return _selectedIndexPath;
}
@end
