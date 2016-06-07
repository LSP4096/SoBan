//
//  OMLimitTextfield.m
//  OfficeManager
//
//  Created by JiaHao on 9/6/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMLimitTextfield.h"


@interface OMLimitTextfield ()

@property (strong, nonatomic) UIImageView *rightImageView;

@end


@implementation OMLimitTextfield

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self _initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}

- (void)setRightViewImage:(UIImage *)rightViewImage
{
    _rightViewImage = rightViewImage;
    self.rightImageView.image = _rightViewImage;
}

- (void)setIsCorrectText:(BOOL)isCorrectText
{
    _isCorrectText = isCorrectText;
    self.rightView.hidden = !isCorrectText;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, _indent, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, _indent, 0);
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 10;
    return textRect;
}

#pragma mark - Private

- (void)_initialize
{
    self.rightViewMode = UITextFieldViewModeAlways;
    _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GreenMark"]];
    self.rightView = _rightImageView;
    self.rightView.hidden = YES;
}


@end
