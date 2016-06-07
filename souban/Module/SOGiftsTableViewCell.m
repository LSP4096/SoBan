//
//  SOGiftsTableViewCell.m
//  souban
//
//  Created by 周国勇 on 1/4/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOGiftsTableViewCell.h"
#import "SOGift.h"
#import <UIImageView+WebCache.h>
#import "NSString+URL.h"

@interface SOGiftsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftDescriptionLabel;
@end

@implementation SOGiftsTableViewCell

- (void)configCellWithModel:(SOGift *)gift {
    [self.giftImageView sd_setImageWithURL:gift.img.originURL placeholderImage:nil options:SDWebImageRetryFailed];
    self.giftTitleLabel.text = gift.name;
    self.giftDescriptionLabel.text = gift.giftDesc;
}

@end
