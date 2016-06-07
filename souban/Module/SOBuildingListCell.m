//
//  SOBuildingListCell.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingListCell.h"
#import "NSString+URL.h"
#import "SOBuildingSummary.h"
#import <UIImageView+WebCache.h>
#import "UIImage+Placeholder.h"
#import "NSNumber+Formatter.h"
#import "UIView+Layout.h"


@interface SOBuildingListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *buildingImageView;
@property (weak, nonatomic) IBOutlet UILabel *buildingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentingLabel;
@property (weak, nonatomic) IBOutlet UILabel *conformCountLabel;
@property (weak, nonatomic) IBOutlet UIView *conformContainerView;

@end


@implementation SOBuildingListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)configCellWithModel:(SOBuildingSummary *)buildingSummary
{
    if (buildingSummary.image.length == 0) {
        self.buildingImageView.image = [UIImage imageNamed:@"placeholder_aptmt"];
    } else {
        [self.buildingImageView sd_setImageWithURL:buildingSummary.image.originURL placeholderImage:[UIImage placeholder] options:SDWebImageRetryFailed];
    }
    self.buildingNameLabel.text = buildingSummary.name;
    self.addressLabel.text = [NSString stringWithFormat:@"%@-%@ %@", buildingSummary.location.area.name, buildingSummary.location.block.name, [buildingSummary.price buiildingPriceStringForUnit:buildingSummary.priceUnit]];
    self.rentingLabel.text = [NSString stringWithFormat:@"%@套正在出租", buildingSummary.roomCount];

    self.conformContainerView.hidden = !buildingSummary.filterCount;

    if (buildingSummary.filterCount.integerValue != -1) {
        self.conformCountLabel.text = [NSString stringWithFormat:@"%@户型符合", buildingSummary.filterCount];
    }
    self.conformContainerView.hidden = buildingSummary.filterCount.integerValue == -1;

    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.conformCountLabel.width + 24, self.conformCountLabel.height + 16)
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                           cornerRadii:CGSizeMake(4.0, 4.0)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.conformContainerView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.conformContainerView.layer.mask = maskLayer;
}

@end
