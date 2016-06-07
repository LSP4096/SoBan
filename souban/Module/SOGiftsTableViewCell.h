//
//  SOGiftsTableViewCell.h
//  souban
//
//  Created by 周国勇 on 1/4/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "OMBaseTableViewCell.h"

@class SOGift;
@interface SOGiftsTableViewCell : OMBaseTableViewCell

- (void)configCellWithModel:(SOGift *)gift;

@end
