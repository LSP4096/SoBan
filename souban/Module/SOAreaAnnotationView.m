//
//  SOAreaAnnotation.m
//  souban
//
//  Created by JiaHao on 11/19/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOAreaAnnotationView.h"
#import "SOAreaAnnotation.h"


@interface SOAreaAnnotationView ()

@property (strong, nonatomic) SOAreaAnnotation *annotationView;

@end


@implementation SOAreaAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.canShowCallout = NO;
        CGRect rect = CGRectMake(0.f, 0.f, 55, 55);
        [self setBounds:rect];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 55 / 2;
        [self.annotationView setFrame:rect];
        [self addSubview:self.annotationView];
    }
    return self;
}

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    self.annotationView.areaLabel.text = annotation.title;
    self.annotationView.buildingCountLabel.text = annotation.subtitle;
    self.annotationView.userInteractionEnabled = NO;
}

- (SOAreaAnnotation *)annotationView
{
    if (!_annotationView) {
        _annotationView = [[NSBundle mainBundle] loadNibNamed:@"SOAreaAnnotation" owner:nil options:nil].firstObject;
    }
    return _annotationView;
}
@end
