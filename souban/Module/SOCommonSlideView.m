//
//  SOCommonSlideView.m
//  souban
//
//  Created by 周国勇 on 12/28/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOCommonSlideView.h"
#import "SOSlideButton.h"
#import "UIView+Layout.h"
#import "UIColor+ATColors.h"
#import "UIColor+OM.h"
#import "Masonry.h"

#define SlideViewW [UIScreen mainScreen].bounds.size.width
#define SlideViewH 45
#define tagBottomViewH 2

/// 分隔线
#define separatorW 0.5
#define separatorH 15


@interface SOCommonSlideView ()

@property (nonatomic, assign) BOOL separatorShowed;                   /**< 是否显示分隔线 */
@property (nonatomic, strong) NSMutableArray<NSString *> *tagsArray;  /**< 标签 title 字符数组 */
@property (nonatomic, strong) NSMutableArray<UIButton *> *tagButtons; /**< 标签 Button 数组 */
@property (nonatomic, strong) UIView *tagBottomView;                  /**< 标签栏底部指示条 */
@property (nonatomic, strong) SOSlideButton *selectedBtn;             /**< 当前选中的 button */


@end


@implementation SOCommonSlideView

- (NSMutableArray<UIButton *> *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

// ***********************************************************************************
#pragma mark - init
// ***********************************************************************************
+ (instancetype)slideViewWithTagsArray:(NSArray<NSString *> *)tagsArray
{
    return [self slideViewWithTagsArray:tagsArray separatorShowed:YES bottomViewShowed:YES];
}
- (instancetype)initWithTagsArray:(NSArray<NSString *> *)tagsArray
{
    return [self initWithTagsArray:tagsArray separatorShowed:YES bottomViewShowed:YES];
}

+ (instancetype)slideViewWithTagsArray:(NSArray<NSString *> *)tagsArray separatorShowed:(BOOL)separatorShowed bottomViewShowed:(BOOL)bottomViewShowed
{
    return [[self alloc] initWithTagsArray:tagsArray
                           separatorShowed:separatorShowed
                          bottomViewShowed:bottomViewShowed];
}

- (instancetype)initWithTagsArray:(NSArray<NSString *> *)tagsArray
                  separatorShowed:(BOOL)separatorShowed
                 bottomViewShowed:(BOOL)bottomViewShowed
{
    if (self = [super init]) {
        self.tagsArray = [[NSMutableArray alloc] initWithArray:tagsArray];
        self.separatorShowed = separatorShowed;
        [self setupTagView];
        if (!bottomViewShowed) {
            self.tagBottomView.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

// ***********************************************************************************
#pragma mark - Private
// ***********************************************************************************
- (void)setupTagView
{
    self.frame = CGRectMake(0, 0, SlideViewW, SlideViewH);
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];

    NSInteger tagsCount = self.tagsArray.count;
    CGFloat tagBtnW = SlideViewW / tagsCount;
    CGFloat tagBtnH = SlideViewH;

    for (int i = 0; i < tagsCount; i++) {
        SOSlideButton *tagBtn = [SOSlideButton buttonWithType:UIButtonTypeCustom];
        [tagBtn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tagBtn];
        [self.tagButtons addObject:tagBtn];

        tagBtn.frame = CGRectMake(i * tagBtnW, 0, tagBtnW, tagBtnH);

        __weak __typeof(&*self) weakSelf = self;
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).with.offset(i * tagBtnW);
            make.top.equalTo(weakSelf.mas_top);
            make.bottom.equalTo(weakSelf.mas_bottom);
            make.width.mas_equalTo(tagBtnW);
        }];

        NSString *title = self.tagsArray[i];
        [tagBtn setTitle:title forState:UIControlStateNormal];

        // 分隔线
        if (self.separatorShowed) {
            if (i > 0) {
                UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(tagBtnW * i, (SlideViewH - separatorH) / 2, separatorW, separatorH)];
                separator.backgroundColor = [UIColor grayLineColor];
                [self addSubview:separator];
            }
        }
    }

    UIView *tagBottomView = [[UIView alloc] init];
    tagBottomView.height = tagBottomViewH;
    tagBottomView.top = self.height - tagBottomView.height - 5;
    tagBottomView.backgroundColor = [self.tagButtons.lastObject titleColorForState:UIControlStateSelected];

    [self addSubview:tagBottomView];
    self.tagBottomView = tagBottomView;
    // 默认点击第一个标签
    SOSlideButton *firstTagBtn = (SOSlideButton *)self.tagButtons.firstObject;
    [firstTagBtn.titleLabel sizeToFit]; // 此时 Label 还未渲染,宽度为0, 需要手动渲染一次
    //------------------------------------------------------------ 提前设置一次 frame 避免初始动画
    self.tagBottomView.width = firstTagBtn.titleLabel.width;
    self.tagBottomView.centerX = firstTagBtn.centerX;
    //------------------------------------------------------------------------------------
    [self tagClick:firstTagBtn];
}

// ***********************************************************************************
#pragma mark - Action
// ***********************************************************************************
- (void)tagClick:(SOSlideButton *)btn
{
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;

    [UIView animateWithDuration:0.25 animations:^{
        self.tagBottomView.width = btn.titleLabel.width;
        self.tagBottomView.centerX = btn.centerX;
    }];

    if ([self.delegate respondsToSelector:@selector(slideView:didSelectedTagWithIndex:button:)]) {
        [self.delegate slideView:self didSelectedTagWithIndex:[self.tagButtons indexOfObject:btn] button:btn];
    }
}

@end
