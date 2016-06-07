//
//  SOMyOrderViewCell.m
//  souban
//
//  Created by JiaHao on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOMyOrderViewCell.h"
#import "SOOrderBuilding.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "UIImage+Placeholder.h"
#import "kCommonMacro.h"
#import "NSNumber+Formatter.h"
#import "SOPhotoPickerBrowserViewController.h"
#import "OMHUDManager.h"


@interface SOMyOrderViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *preferTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *alternateTimeLabel;

@property (strong, nonatomic) NSArray *imageArray;


@end


@implementation SOMyOrderViewCell

- (void)awakeFromNib
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImages)];
    [self.portraitImageView addGestureRecognizer:gesture];
    self.portraitImageView.userInteractionEnabled = YES;
}

- (void)showImages
{
    if (!self.imageArray.count) {
        [OMHUDManager showInfoWithStatus:@"没有图片"];
        return;
    }
    [SOPhotoPickerBrowserViewController showWithMedias:self.imageArray currentIndex:0 fromImageView:self.portraitImageView];
}

- (void)configWithBuilding:(SOOrderBuildingRoom *)room
{
    float number = [room.priceUnit isEqualToString:@"D"]?30:1;
    self.priceLabel.text = @(room.price.floatValue * room.areaSize.floatValue * number / 10000).twoBitStringValue;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", [room.areaSize squareMeter], room.fitment];
    self.subTitleLabel.text = [room.price buiildingPriceStringForUnit:room.priceUnit];
    self.preferTimeLabel.text = [NSString stringWithFormat:@"首选:      %@", room.preferredTime];
    self.alternateTimeLabel.text = [NSString stringWithFormat:@"备选:      %@", room.alternativeTime];
    self.imageArray = room.images;
    NSString *firstImageUrl = room.images.firstObject;
    if (room.images.count == 0) {
        self.portraitImageView.image = [UIImage imageNamed:@"placeholder_collection"];
    } else {
        [self.portraitImageView sd_setImageWithURL:firstImageUrl.originURL placeholderImage:[UIImage placeholder] options:SDWebImageRetryFailed];
    }
}


- (NSArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [[NSArray alloc] init];
    }
    return _imageArray;
}

@end
