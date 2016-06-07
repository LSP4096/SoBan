//
//  SOBuildingDetailTrafficCollectionCell.m
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailTrafficCollectionCell.h"
#import "SOTraffic.h"
#import <UIImageView+WebCache.h>
#import "NSString+URL.h"
#import "UIImage+Color.h"
#import "UIColor+OM.h"
#import "SOBuildingStation.h"
#import "OMLineView.h"


@interface SOBuildingDetailTrafficCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (strong, nonatomic) SOTraffic *traffic;
@property (weak, nonatomic) IBOutlet OMLineView *bottomLineView;
@property (weak, nonatomic) IBOutlet OMLineView *rightLineView;
@property (weak, nonatomic) IBOutlet OMLineView *topLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLineViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLineViewBottomConstraint;

@end


@implementation SOBuildingDetailTrafficCollectionCell

+ (CGSize)cellSize
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
    return CGSizeMake(width, 101);
}

+ (CGSize)stationSize
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 4;
    return CGSizeMake(width, width);
}

- (void)configWithModel:(SOBuildingImageDescItem *)item
{
    [self.itemImageView sd_setImageWithURL:item.image.originURL placeholderImage:nil options:SDWebImageRetryFailed];
    self.itemNameLabel.text = item.name;
    self.bottomLineView.hidden = YES;
    self.itemImageView.hidden = !item;
    self.itemNameLabel.hidden = !item;
}

- (void)configCellWithModel:(SOTraffic *)traffic index:(NSInteger)index
{
    self.traffic = traffic;
    
    NSArray *names = @[@"ic_bus", @"ic_subway", @"ic_train"];
    NSString *selectedImageName = [names[index] stringByAppendingString:@"_blue"];
    NSString *normalImageName = [names[index] stringByAppendingString:@"_gray"];
    self.itemImageView.image = [UIImage imageNamed:normalImageName];
    self.itemImageView.highlightedImage = [UIImage imageNamed:selectedImageName];

    self.itemNameLabel.text = traffic.name;
    //    self.rightLineView.hidden = YES;
    self.rightLineViewTopConstraint.constant = [[self class] cellSize].height / 3;
    self.rightLineViewBottomConstraint.constant = [[self class] cellSize].height / 3;
    self.topLineView.hidden = YES;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.itemImageView.highlighted = selected;
    self.bottomLineView.hidden = selected;
    self.itemNameLabel.highlighted = selected;
}
@end
