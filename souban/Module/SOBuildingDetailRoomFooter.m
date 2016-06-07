//
//  SOBuildingDetailRoomFooter.m
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailRoomFooter.h"
#import "SOBuilding.h"


@interface SOBuildingDetailRoomFooter ()

@property (weak, nonatomic) IBOutlet UILabel *roomCountLabel;
@property (weak, nonatomic) IBOutlet UIView *roomCountConainterView;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end


@implementation SOBuildingDetailRoomFooter
@dynamic contentView;

+ (CGFloat)height
{
    return 48;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookmoreButtonTapped:)];
    [self.roomCountConainterView addGestureRecognizer:gesture];
    self.roomCountConainterView.userInteractionEnabled = YES;
}

- (void)configCellWithText:(NSString *)text
{
    self.roomCountLabel.text = text;
}

- (void)lookmoreButtonTapped:(UITapGestureRecognizer *)gesture
{
    [self.delegate buildingDetailRoomFooterLookMoreTapped];
}
@end
