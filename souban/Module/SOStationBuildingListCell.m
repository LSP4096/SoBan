//
//  SOStationBuildingListCell.m
//  souban
//
//  Created by 周国勇 on 11/12/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOStationBuildingListCell.h"
#import <UIImageView+WebCache.h>
#import "NSString+URL.h"
#import "SOStationBuildingSummary.h"
#import "NSNumber+Formatter.h"
#import "UIView+Layout.h"


@interface SOStationBuildingListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *buildingImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end


@implementation SOStationBuildingListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)configCellWithModel:(SOStationBuildingSummary *)stationSummary
{
    if (stationSummary.image.length == 0) {
        self.buildingImageView.image = [UIImage imageNamed:@"placeholder_aptmt_incubator"];
    } else {
        [self.buildingImageView sd_setImageWithURL:stationSummary.image.originURL placeholderImage:nil options:SDWebImageRetryFailed];
    }

    self.nameLabel.text = stationSummary.name;
    self.stationNumberLabel.text = [NSString stringWithFormat:@"%@个工位可租", stationSummary.inRentCount.stringValue];
    self.priceLabel.text = stationSummary.price.integerValue == 0 ? @"免费" : stationSummary.price.perStationMonth;
    self.locationLabel.text = [NSString stringWithFormat:@"%@-%@", stationSummary.location.area.name, stationSummary.location.block.name];
}

@end
