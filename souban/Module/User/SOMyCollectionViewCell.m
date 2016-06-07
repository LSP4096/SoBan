//
//  SOMyCollectionViewCell.m
//  souban
//
//  Created by JiaHao on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOMyCollectionViewCell.h"
#import "SOCollectBuilding.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "UIImage+Placeholder.h"
#import "NSNumber+Formatter.h"
#import "OMHUDManager.h"
#import "SOPhotoPickerBrowserViewController.h"


@interface SOMyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;

@property (strong, nonatomic) SOCollectBuilding *building;
@property (strong, nonatomic) SOCollectBuildingRoom *room;
@property (strong, nonatomic) NSArray *imageArray;

@end


@implementation SOMyCollectionViewCell

- (void)awakeFromNib
{
    UITapGestureRecognizer *imageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImages)];
    self.portraitImageView.userInteractionEnabled = YES;
    [self.portraitImageView addGestureRecognizer:imageGesture];
}

- (void)showImages
{
    if (!self.imageArray.count) {
        [OMHUDManager showInfoWithStatus:@"没有图片"];
        return;
    }
    [SOPhotoPickerBrowserViewController showWithMedias:self.imageArray currentIndex:0 fromImageView:self.portraitImageView];
}

- (IBAction)unStarRoom:(id)sender
{
    [self.delegate uncollectBuilding:self.room Building:self.building];
}

- (void)configWithBuilding:(SOCollectBuildingRoom *)room Building:(SOCollectBuilding *)building
{
    self.imageArray = room.images;
    if (room.images.count == 0) {
        self.portraitImageView.image = [UIImage imageNamed:@"placeholder_collection"];
    } else {
        NSString *firstImageUrl = room.images.firstObject;
        [self.portraitImageView sd_setImageWithURL:firstImageUrl.originURL placeholderImage:[UIImage placeholder] options:SDWebImageRetryFailed];
    }
    self.building = building;
    self.room = room;
    float number = [room.priceUnit isEqualToString:@"D"]?30:1;
    self.priceLabel.text = @(room.price.floatValue * room.areaSize.floatValue * number / 10000).twoBitStringValue;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", [room.areaSize squareMeter], room.fitment];
    self.subTitleLabel.text = [room.price buiildingPriceStringForUnit:room.priceUnit];
    self.collectionLabel.text = @"已收藏";
}


- (NSArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [[NSArray alloc] init];
    }
    return _imageArray;
}

@end
