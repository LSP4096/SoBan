//
//  JSDropDownMenuHeaderCell.m
//  souban
//
//  Created by 周国勇 on 11/9/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "JSDropDownMenuHeaderCell.h"
#import "OMLineView.h"
#import "UIImage+Color.h"
#import "UIColor+OM.h"


@interface JSDropDownMenuHeaderCell ()

@property (weak, nonatomic, readwrite) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;
@property (weak, nonatomic) IBOutlet OMLineView *rightLineView;

@end


@implementation JSDropDownMenuHeaderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.indicatorImageView.highlightedImage = [self.indicatorImageView.image imageWithTintColor:[UIColor at_deepSkyBlueColor]];
}

- (void)configCellWithText:(NSString *)text displayLine:(BOOL)displayLine
{
    self.rightLineView.hidden = !displayLine;
    self.titleLabel.text = text;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    self.titleLabel.highlighted = selected;
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorImageView.transform = selected?CGAffineTransformRotate(CGAffineTransformIdentity, M_PI):CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.indicatorImageView.highlighted = selected;
    }];
}

@end
