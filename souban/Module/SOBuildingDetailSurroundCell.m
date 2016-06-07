//
//  SOBuildingDetailSurroundCell.m
//  souban
//
//  Created by 周国勇 on 11/2/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailSurroundCell.h"
#import "SOSurround.h"
#import "NSString+URL.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Formatter.h"


@interface SOBuildingDetailSurroundCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *namesLabel;

@end


@implementation SOBuildingDetailSurroundCell

+ (CGFloat)height
{
    return 50;
}

- (void)configCellWithModel:(SOSurround *)surround
{
    [self.iconImageView sd_setImageWithURL:surround.image.originURL placeholderImage:nil options:SDWebImageRetryFailed];
    self.itemNameLabel.text = surround.name;
    self.countLabel.text = surround.count.shopUnit;
    self.namesLabel.text = surround.shops;
}

@end
