//
//  SOBlockAnnotationView.m
//  souban
//
//  Created by JiaHao on 11/19/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBlockAnnotationView.h"
#import "SOBlockAnnotation.h"


@interface SOBlockAnnotationView ()

@property (strong, nonatomic) SOBlockAnnotation *annotationView;
@end


@implementation SOBlockAnnotationView


- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.annotationView.userInteractionEnabled = NO;
        self.canShowCallout = NO;
        [self addSubview:self.annotationView];
    }
    return self;
}

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    self.annotationView.blockLabel.text = annotation.title;
    self.annotationView.buildingCountLabel.text = annotation.subtitle;
    [self.annotationView.blockLabel sizeToFit];
    [self.annotationView.buildingCountLabel sizeToFit];
    self.annotationView.userInteractionEnabled = NO;
    CGRect rect = CGRectMake(0.f, 0.f, self.annotationView.buildingCountLabel.intrinsicContentSize.width + self.annotationView.blockLabel.intrinsicContentSize.width + 30, 31);
    [self setBounds:rect];
    [self.annotationView setFrame:rect];
}


- (SOBlockAnnotation *)annotationView
{
    if (!_annotationView) {
        _annotationView = [[NSBundle mainBundle] loadNibNamed:@"SOBlockAnnotation" owner:nil options:nil].firstObject;
    }
    return _annotationView;
}
@end
