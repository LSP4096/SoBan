//
//  SOBuildingAnnotationView.m
//  souban
//
//  Created by JiaHao on 11/19/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingAnnotationView.h"
#import "SOBuildingAnnotation.h"


@interface SOBuildingAnnotationView ()
@property (strong, nonatomic) SOBuildingAnnotation *annotationView;

@end


@implementation SOBuildingAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:3.0f];
        //        [[UIColor colorWithWhite:0.8 alpha:0.5] setFill];
        //        [roundedRect fillWithBlendMode:kCGBlendModeNormal alpha:1];

        self.annotationView.buildingNameLabel.text = annotation.title;
        self.annotationView.buildingCountLabel.text = annotation.subtitle;
        self.annotationView.bubbleWidthConstraint.constant = self.annotationView.buildingCountLabel.intrinsicContentSize.width + 16;
        [self.annotationView setNeedsLayout];
        [self.annotationView layoutIfNeeded];
        CGRect rect = CGRectMake(0.f, 0.f, self.annotationView.buildingNameLabel.intrinsicContentSize.width + self.annotationView.buildingCountLabel.intrinsicContentSize.width + 31, 37);
        [self setBounds:rect];
        self.annotationView.userInteractionEnabled = NO;
        self.centerOffset = CGPointMake(rect.size.width / 2 - 20, -19);
        self.annotationView.userInteractionEnabled = NO;
        [self.annotationView setFrame:rect];
        [self addSubview:self.annotationView];
    }
    return self;
}
- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    self.annotationView.userInteractionEnabled = NO;
    self.annotationView.buildingNameLabel.text = annotation.title;
    self.annotationView.buildingCountLabel.text = annotation.subtitle;
    self.annotationView.bubbleWidthConstraint.constant = self.annotationView.buildingCountLabel.intrinsicContentSize.width + 16;
    [self.annotationView setNeedsLayout];
    [self.annotationView layoutIfNeeded];
    self.annotationView.userInteractionEnabled = NO;
    CGRect rect = CGRectMake(0.f, 0.f, self.annotationView.buildingNameLabel.intrinsicContentSize.width + self.annotationView.buildingCountLabel.intrinsicContentSize.width + 31, 37);
    self.centerOffset = CGPointMake(rect.size.width / 2 - 20, -19);

    [self setBounds:rect];
    [self setFrame:self.frame];
}


- (SOBuildingAnnotation *)annotationView
{
    if (!_annotationView) {
        _annotationView = [[NSBundle mainBundle] loadNibNamed:@"SOBuildingAnnotation" owner:nil options:nil].firstObject;
    }
    return _annotationView;
}

@end
