//
//  SOFlowChartView.m
//  souban
//
//  Created by Rawlings on 16/1/22.
//  Copyright © 2016年 wajiang. All rights reserved.
//

#import "SOFlowChartView.h"
#import "UIView+Layout.h"
#import "UIColor+PLNColors.h"


#define ChartViewW [UIScreen mainScreen].bounds.size.width
#define ChartViewH 105


@interface SOFlowChartView ()

@property (nonatomic, strong) NSArray *images;/**<  */
@property (nonatomic, strong) NSArray *headers;/**<  */

@property (nonatomic, assign) NSInteger progress;/**<  */

@end

@implementation SOFlowChartView

// ***********************************************************************************
#pragma mark - API
// ***********************************************************************************
+ (instancetype)chartWithImages:(NSArray<UIImage *> *)images Headers:(NSArray<NSString *> *)headers progress:(NSInteger)progress{
    return [[self alloc] initWithImages:images Headers:headers progress:progress];
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images Headers:(NSArray<NSString *> *)headers progress:(NSInteger)progress{
    if (self = [super init]) {
        self.images = images;
        self.headers = headers;
        self.progress = progress;
        [self setupChart];
    }
    return self;
}


// ***********************************************************************************
#pragma mark - Private
// ***********************************************************************************
- (void)setupChart{
    self.frame = CGRectMake(0, 0, ChartViewW, ChartViewH);
    
    NSInteger imgCount = self.images.count;
    CGFloat unitW = ChartViewW / imgCount;
    
    for (int i = 0; i < imgCount; i++) {
        SOFlowChartUnitView *unit = [SOFlowChartUnitView chartUnitWithWidth:unitW
                                                                      index:i
                                                                   progress:self.progress
                                                                      image:self.images[i]
                                                                     header:self.headers[i]];
        
        [self addSubview:unit];
    }
}



@end



// ===================================================================================
#pragma mark - CLASS SOFlowChartUnitView
// ===================================================================================

#define TopMargin 14
#define Img2Label 9
#define AvoidLabelsTooClose 5
#define Img2Line 6
#define LineH 2

@interface SOFlowChartUnitView ()

@property (nonatomic, assign) NSInteger index;/**<  */
@property (nonatomic, assign) NSInteger progress;/**<  */
@property (nonatomic, strong) UIImage *image;/**<  */
@property (nonatomic, strong) NSString *header;/**<  */

@end
@implementation SOFlowChartUnitView

// ***********************************************************************************
#pragma mark - API
// ***********************************************************************************
+ (instancetype)chartUnitWithWidth:(CGFloat)width index:(NSInteger)index progress:(NSInteger)progress image:(UIImage *)image header:(NSString *)header{
    return [[self alloc] initWithWidth:width index:(NSInteger)index progress:(NSInteger)progress image:image header:header];
}

- (instancetype)initWithWidth:(CGFloat)width index:(NSInteger)index progress:(NSInteger)progress image:(UIImage *)image header:(NSString *)header{
    if (self = [super init]) {
        self.frame = CGRectMake(index * width, 0, width, ChartViewH);
        self.image = image;
        self.header = header;
        self.index = index;
        self.progress = progress;
        [self setup];
        
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
    }
    return self;
}

// ***********************************************************************************
#pragma mark - Private
// ***********************************************************************************
- (void)setup{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:self.image];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.width = self.width - AvoidLabelsTooClose;
    label.text = self.header;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = SSColor(79, 95, 111);
    label.font = [UIFont systemFontOfSize:12];
    [label sizeToFit];
    
    imgView.top = TopMargin;
    imgView.centerX = self.width / 2;
    label.top = TopMargin + imgView.height + Img2Label;
    label.centerX = self.width / 2;
    
    [self addSubview:imgView];
    [self addSubview:label];
    
    // Line
    CGFloat lineW = (self.width - imgView.width - Img2Line * 2) / 2;
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lineW, LineH)];
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lineW, LineH)];
    leftLine.centerY = imgView.centerY;
    rightLine.centerY = imgView.centerY;
    leftLine.left = 0;
    rightLine.left = CGRectGetMaxX(imgView.frame) + Img2Line;
    
    [self addSubview:leftLine];
    [self addSubview:rightLine];
    [self configLeftLine:leftLine rightLine:rightLine];
    
    leftLine.backgroundColor = rightLine.backgroundColor = [self LineColorChooser];
}


- (void)configLeftLine:(UIView *)leftLine rightLine:(UIView *)rightLine{
    if (self.index == 0) leftLine.alpha = 0;
    if (self.index == ChartViewW / self.width - 1) rightLine.alpha = 0;
}


- (UIColor *)LineColorChooser{
    return (self.progress > self.index) ? SSColor(6, 130, 255) : SSColor(161, 177, 194);
}

@end