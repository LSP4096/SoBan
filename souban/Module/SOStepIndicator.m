//
//  SOStepIndicator.m
//  souban
//
//  Created by 周国勇 on 12/29/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOStepIndicator.h"
#import "SOFilingDetail.h"
#import "OMDateFormatter.h"
#import "UIColor+OM.h"
#import "UIView+Layout.h"


@interface SOStepIndicator ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewGroups;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *statusLabelGroups;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dateLabelGroup;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *timeLabelGroup;

@end


@implementation SOStepIndicator

- (void)awakeFromNib
{
    [super awakeFromNib];
    for (UILabel *label in self.statusLabelGroups) {
        label.highlightedTextColor = [UIColor at_deepSkyBlueColor];
    }

    for (UILabel *label in self.dateLabelGroup) {
        label.hidden = YES;
        label.textColor = [UIColor at_deepSkyBlueColor];
    }

    for (UILabel *label in self.timeLabelGroup) {
        label.hidden = YES;
        label.textColor = [UIColor at_deepSkyBlueColor];
    }
}

- (void)configViewWihtModel:(SOFilingDetail *)filing
{
    NSMutableArray *dates = [NSMutableArray new];
    NSMutableArray *times = [NSMutableArray new];

    NSInteger step = 0;
    if (filing.createTime != 0) {
        step += 1;
        [dates addObject:[[OMDateFormatter sharedInstance] dotDateWithMsec:filing.createTime]];
        [times addObject:[[OMDateFormatter sharedInstance] timeWithMsec:filing.createTime]];
    }
    if (filing.lookTime != 0) {
        step += 1;
        [dates addObject:[[OMDateFormatter sharedInstance] dotDateWithMsec:filing.lookTime]];
        [times addObject:[[OMDateFormatter sharedInstance] timeWithMsec:filing.lookTime]];
    }
    if (filing.followUpTime != 0) {
        step += 1;
        [dates addObject:[[OMDateFormatter sharedInstance] dotDateWithMsec:filing.followUpTime]];
        [times addObject:[[OMDateFormatter sharedInstance] timeWithMsec:filing.followUpTime]];
    }
    if (filing.dealTime != 0) {
        step += 1;
        [dates addObject:[[OMDateFormatter sharedInstance] dotDateWithMsec:filing.dealTime]];
        [times addObject:[[OMDateFormatter sharedInstance] timeWithMsec:filing.dealTime]];
    }
    if (filing.payTime != 0) {
        step += 1;
        [dates addObject:[[OMDateFormatter sharedInstance] dotDateWithMsec:filing.payTime]];
        [times addObject:[[OMDateFormatter sharedInstance] timeWithMsec:filing.payTime]];
    }

    for (NSInteger i = 0; i < step; i++) {
        UIImageView *imageView = self.imageViewGroups[i];
        imageView.highlighted = YES;
        UILabel *statusLabel = self.statusLabelGroups[i];
        statusLabel.highlighted = YES;
        UILabel *dateLabel = self.dateLabelGroup[i];
        dateLabel.text = dates[i];
        dateLabel.hidden = NO;
        UILabel *timeLabel = self.timeLabelGroup[i];
        timeLabel.hidden = NO;
        timeLabel.text = times[i];
    }

    CGFloat lineWidth = (self.width - 30 * 5 - (self.width / 10 - 15) * 2 - 8 * 5) / 4;
    CGFloat lineOrigin = (self.width / 10 - 15) + 30 + 5;
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(lineOrigin + 30 * i + 5 * i * 2 + lineWidth * i, 14, lineWidth, 2)];
        [self addSubview:view];
        view.backgroundColor = i < step ? [UIColor at_deepSkyBlueColor] : [UIColor at_blueyGreyColor];
    }
}

@end
