//
//  SOSubwayStopAnnotationView.m
//  souban
//
//  Created by JiaHao on 12/24/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOSubwayStopAnnotationView.h"
#import "SOSubwayStopAnnotation.h"
#import "UIView+Layout.h"
#import "UIColor+ATColors.h"
#import "UIImage+SOResizing.h"


@interface SOSubwayStopAnnotationView ()

@property (strong, nonatomic) SOSubwayStopAnnotation *annotationView;

@end


@implementation SOSubwayStopAnnotationView


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.annotationView.stopBackgroundImageView.highlighted = selected;
    self.annotationView.stopNameLabel.textColor = selected ? [UIColor whiteColor] : [UIColor at_charcoalGreyColor];
    self.annotationView.stopNumberLabel.textColor = selected ? [UIColor whiteColor] : [UIColor colorWithRed:190 / 255.0f green:2 / 255.0f blue:3 / 255.0f alpha:1.0f];
}


- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.canShowCallout = NO;
        CGRect rect = CGRectMake(0.f, 0.f, 55, 55);
        [self setBounds:rect];
        [self.annotationView setFrame:rect];
        [self addSubview:self.annotationView];
        //        self.annotationView.stopBackgroundImageView.image = [[UIImage imageNamed:@"ic_subwayStopUnselecte"]
        //                                                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, rect.size.width/2 -2, 0, rect.size.width/2 + 2) resizingMode:UIImageResizingModeStretch];
    }
    return self;
}

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    self.canShowCallout = NO;
    self.annotationView.stopNameLabel.text = annotation.title;
    self.annotationView.stopNumberLabel.text = annotation.subtitle;
    self.annotationView.userInteractionEnabled = NO;
    [self.annotationView.stopNameLabel sizeToFit];
    [self.annotationView.stopNumberLabel sizeToFit];
    CGRect rect = CGRectMake(0.f, 0.f, self.annotationView.stopNameLabel.intrinsicContentSize.width + self.annotationView.stopNumberLabel.intrinsicContentSize.width + 10, 55);
    [self setBounds:rect];
    [self.annotationView setNeedsLayout];
    [self.annotationView layoutIfNeeded];
    self.centerOffset = CGPointMake(0, -25);
    UIImage *image = [UIImage imageNamed:@"ic_subwayStopUnselecte"];
    UIImage *selectImage = [UIImage imageNamed:@"ic_subwayStopSelecte"];
    self.annotationView.stopBackgroundImageView.image = [image resizedImageWithWidth:self.annotationView.width andStretchAreaFrom:10 to:20 andFrom:image.size.width - 20 to:image.size.width - 10];
    self.annotationView.stopBackgroundImageView.highlightedImage = [selectImage resizedImageWithWidth:self.annotationView.width andStretchAreaFrom:10 to:20 andFrom:image.size.width - 20 to:image.size.width - 10];
}

- (SOSubwayStopAnnotation *)annotationView
{
    if (!_annotationView) {
        _annotationView = [[NSBundle mainBundle] loadNibNamed:@"SOSubwayStopAnnotation" owner:nil options:nil].firstObject;
    }
    return _annotationView;
}

@end
