//
//  SOBuildingDetailDescriptionCell.m
//  souban
//
//  Created by 周国勇 on 11/2/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailDescriptionCell.h"


@interface SOBuildingDetailDescriptionCell ()

@property (weak, nonatomic) IBOutlet UIView *lookMoreContainerView;
@property (weak, nonatomic) IBOutlet UILabel *lookMoreLabel;

@end


@implementation SOBuildingDetailDescriptionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookmoreButtonTapped:)];
    [self.lookMoreContainerView addGestureRecognizer:gesture];
    self.lookMoreContainerView.userInteractionEnabled = YES;
}

- (void)lookmoreButtonTapped:(UITapGestureRecognizer *)gesture
{
    [self.delegate buildingDetailDescriptionCellLookMoreTapped:self];
}

- (void)configCellWithText:(NSString *)text expand:(BOOL)expand
{
    self.descriptionLabel.numberOfLines = expand ? 0 : 3;
    self.descriptionLabel.text = text;
    self.lookMoreLabel.text = !expand ? @"点击查看更多" : @"收起描述";

    CGAffineTransform transform = expand ? CGAffineTransformRotate(CGAffineTransformIdentity, (M_PI)) : CGAffineTransformIdentity;
    self.indicatorImageView.transform = transform;
}
@end
