//
//  SOBuildingDetailDescriptionHeader.m
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailDescriptionHeader.h"
#import "SOBuilding.h"
#import "SOLocation.h"
#import "NSNumber+Formatter.h"
#import "SDCycleScrollView.h"
#import "UIView+Layout.h"
#import "SDCycleScrollView+MediaURL.h"
#import "SOPhotoPickerBrowserViewController.h"
#import "SOBuildingStation.h"


@interface SOBuildingDetailDescriptionHeader () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *buildingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) SOBuilding *building;
@property (strong, nonatomic) SOBuildingStation *buildingStation;

@end


@implementation SOBuildingDetailDescriptionHeader
@dynamic contentView;

+ (CGFloat)height
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return screenWidth / 375 * 250 + 81 - 10;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.contentView addSubview:self.cycleScrollView];
}

- (void)configCellWithStationModel:(SOBuildingStation *)building
{
    self.buildingStation = building;
    self.buildingNameLabel.text = building.name;
    self.areaLabel.text = [NSString stringWithFormat:@"%@ %@", building.location.area.name, building.location.block.name];
    self.saleCountLabel.text = [NSString stringWithFormat:@"%@个工位在租", building.inRentCount.stringValue];
    self.priceLabel.text = building.price.perStationMonth;

    [self.cycleScrollView setMediaURLWithMedia:building.images];
}

- (void)configCellWithModel:(SOBuilding *)building
{
    self.building = building;
    self.buildingNameLabel.text = building.name;
    self.areaLabel.text = [NSString stringWithFormat:@"%@ %@", building.location.area.name, building.location.block.name];
    self.saleCountLabel.text = [NSString stringWithFormat:@"%@套房源在租", building.roomCount.stringValue];
    self.priceLabel.text = [[building.price buiildingPriceStringForUnit:building.priceUnit] stringByAppendingString:@"起"];

    [self.cycleScrollView setMediaURLWithMedia:building.images];
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index imageView:(UIImageView *)imageView
{
    NSArray *medias = self.building ? self.building.images : self.buildingStation.images;
    [SOPhotoPickerBrowserViewController showWithMedias:medias currentIndex:index fromImageView:imageView];
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, width, width / 3 * 2)];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 4;
    }
    return _cycleScrollView;
}

@end
