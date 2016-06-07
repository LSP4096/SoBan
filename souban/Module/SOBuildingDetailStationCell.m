//
//  SOBuildingDetailStationCell.m
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailStationCell.h"
#import "SOBuildingStation.h"
#import <UIImageView+WebCache.h>
#import "SOPhotoPickerBrowserViewController.h"
#import "NSString+URL.h"


@interface SOBuildingDetailStationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *stationImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageNumberLabel;
@property (strong, nonatomic) SOBuildingStation *station;

@end


@implementation SOBuildingDetailStationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stationImageViewTapped:)];
    [self.stationImageView addGestureRecognizer:gesture];
    self.stationImageView.userInteractionEnabled = YES;
}

+ (CGFloat)height
{
    return 84;
}

- (void)configCellWithModel:(SOBuildingStation *)station
{
    if (station.incubatorImages.count == 0) {
        self.stationImageView.image = [UIImage imageNamed:@"placeholder_aptmtlayout"];
    } else {
        NSString *media = station.incubatorImages.firstObject;
        [self.stationImageView sd_setImageWithURL:media.originURL placeholderImage:nil options:SDWebImageRetryFailed];
    }
    self.imageNumberLabel.text = station.incubatorImages.count == 0 ? @"" : [@(station.incubatorImages.count).stringValue stringByAppendingString:@" pic"];

    self.titleLabel.text = station.title;
    self.subTitleLabel.text = station.subTitle;
    self.station = station;
}

- (void)stationImageViewTapped:(UITapGestureRecognizer *)gesture
{
    [SOPhotoPickerBrowserViewController showWithMedias:self.station.incubatorImages currentIndex:0 fromImageView:self.stationImageView];
}

@end
