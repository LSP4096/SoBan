//
//  SOBuildingDetailRoomCell.m
//  souban
//
//  Created by 周国勇 on 11/2/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailRoomCell.h"
#import "SORoom.h"
#import "NSString+URL.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Formatter.h"
#import "UIColor+OM.h"
#import "OMHTTPClient+Building.h"
#import "OMHUDManager.h"
#import "SOBookHouseTableViewController.h"
#import "OMNavigationManager.h"
#import "UIStoryboard+SO.h"
#import "SOPhotoPickerBrowserViewController.h"
#import "OMUser.h"
#import "NSNotificationCenter+OM.h"


@interface SOBuildingDetailRoomCell ()

@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UILabel *monthPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *aresizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fitmentLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *roomDescLabel;
@property (strong, nonatomic) SORoom *room;

@end


@implementation SOBuildingDetailRoomCell

+ (CGFloat)height
{
    return 84;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bookButton.layer.borderWidth = 1;
    self.bookButton.layer.borderColor = [UIColor at_deepSkyBlueColor].CGColor;

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    [self.roomImageView addGestureRecognizer:gesture];
    self.roomImageView.userInteractionEnabled = YES;
    self.roomImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)configCellWithModel:(SORoom *)room
{
    self.room = room;
    if (room.images.count == 0) {
        self.roomImageView.image = [UIImage imageNamed:@"placeholder_aptmtlayout"];
    } else {
        [self.roomImageView sd_setImageWithURL:[room.images.firstObject originURL] placeholderImage:nil options:SDWebImageRetryFailed];
    }
    self.monthPriceLabel.text = [@(room.price.floatValue * room.areaSize.floatValue) tenThousandPerMonthForUnit:room.priceUnit];
    self.aresizeLabel.text = room.areaSize.squareMeter;
    self.dayPriceLabel.text = [room.price buiildingPriceStringForUnit:room.priceUnit];
    self.fitmentLabel.text = room.fitment;
    self.collectButton.selected = room.collected;
    self.imageCountLabel.text = room.images.count == 0 ? @"" : @(room.images.count).stringValue;
    self.filterView.hidden = !room.filterTarget;
    self.roomDescLabel.text = room.roomDescription;
    self.descriptionView.hidden = !room.expand;
}

- (void)imageViewTapped:(UITapGestureRecognizer *)gesture
{
    [SOPhotoPickerBrowserViewController showWithMedias:self.room.images currentIndex:0 fromImageView:self.roomImageView];
}

- (IBAction)favoriteTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.room.collected = sender.selected;
    jsonResultBlock block = ^(id resultObject, NSError *error) {
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
            sender.selected = !sender.selected;
            self.room.collected = sender.selected;
        } else {
            NSString *text = sender.selected?@"添加收藏成功":@"取消收藏成功";
            [OMHUDManager showSuccessWithStatus:text];
        }
    };
    sender.selected ? [[OMHTTPClient realClient] starRoomWithRoomId:self.room.uniqueId completion:block] : [[OMHTTPClient realClient] unStarRoomWithRoomId:self.room.uniqueId completion:block];
}

- (IBAction)bookTapped:(id)sender
{
    if (self.room.uniqueId) {
        if (![OMUser user]) {
            [NSNotificationCenter postNotificationName:kAuthFailed userInfo:nil];
        } else {
            [OMNavigationManager pushControllerWithStoryboardName:kStoryboardService identifier:[SOBookHouseTableViewController storyboardIdentifier] userInfo:@{ @"roomId" : self.room.uniqueId }];
        }
    }
}


@end
