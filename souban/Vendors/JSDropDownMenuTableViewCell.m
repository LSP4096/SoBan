//
//  JSDropDownMenuTableViewCell.m
//  JSDropDownMenuDemo
//
//  Created by 周国勇 on 10/28/15.
//  Copyright © 2015 jsfu. All rights reserved.
//

#import "JSDropDownMenuTableViewCell.h"
#import "OMLineView.h"


@interface JSDropDownMenuTableViewCell ()

@property (nonatomic) BOOL showCheck;
@property (weak, nonatomic) IBOutlet OMLineView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLeftConstraint;

@end


@implementation JSDropDownMenuTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)configCellWithText:(NSString *)text selected:(BOOL)selected showCheckImage:(BOOL)showCheck tableType:(JSIndexTableType)tableType showSeparatorLine:(BOOL)showSeparator
{
    self.itemTextLabel.text = text;
    self.checkImageView.hidden = !showCheck || !selected;

    UIView *view = [UIView new];
    view.backgroundColor = showCheck ? [UIColor whiteColor] : [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    self.backgroundView = view;
    //    self.itemTextLabel.textColor = selected?[UIColor colorWithRed:6/255.0 green:130/255.0 blue:1 alpha:1]:[UIColor colorWithRed:79/255.0 green:95/255.0 blue:111/255.0 alpha:1];

    self.showCheck = showCheck;

    self.lineViewLeftConstraint.constant = tableType == JSIndexTableTypeLeft ? 0 : 10;
    self.lineView.hidden = !showSeparator;
    self.itemTextLabel.textAlignment = tableType == JSIndexTableTypeLeft ? NSTextAlignmentCenter : NSTextAlignmentLeft;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
    self.itemTextLabel.textColor = selected ? [UIColor colorWithRed:6 / 255.0 green:130 / 255.0 blue:1 alpha:1] : [UIColor colorWithRed:79 / 255.0 green:95 / 255.0 blue:111 / 255.0 alpha:1];

    self.checkImageView.hidden = !self.showCheck || !selected;

    UIView *view = [UIView new];
    view.backgroundColor = selected || self.showCheck ? [UIColor whiteColor] : [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    self.backgroundView = view;
}

@end
