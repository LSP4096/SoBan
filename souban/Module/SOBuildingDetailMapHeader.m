//
//  SOBuildingDetailMapHeader.m
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingDetailMapHeader.h"
#import "OMNavigationManager.h"
#import "SOWebViewController.h"
#import "OMHTTPClient.h"
#import <WebKit/WebKit.h>
#import "UIView+Layout.h"
#import <Masonry.h>
#import "UIImageView+WebCache.h"
#import "SOSurroundMapViewController.h"


@interface SOBuildingDetailMapHeader ()

@property (weak, nonatomic) UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (weak, nonatomic) IBOutlet UIView *addressContainerView;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *title;

@end


@implementation SOBuildingDetailMapHeader
@dynamic contentView;

+ (CGFloat)height
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    return width / 375 * 200 + 10;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressAreaTapped:)];
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addGestureRecognizer:gesture];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.mapContainerView addSubview:imageView];

    __weak __typeof(&*self) weakSelf = self;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mapContainerView.mas_left);
        make.right.mas_equalTo(weakSelf.mapContainerView.mas_right);
        make.top.mas_equalTo(weakSelf.mapContainerView.mas_top);
        make.bottom.mas_equalTo(weakSelf.mapContainerView.mas_bottom);
    }];
    imageView.userInteractionEnabled = NO;
    self.mapImageView = imageView;
    [self.mapContainerView sendSubviewToBack:imageView];
}

- (void)addressAreaTapped:(UITapGestureRecognizer *)gesture
{
    [OMNavigationManager pushControllerWithStoryboardName:kStoryboardMap identifier:[SOSurroundMapViewController storyboardIdentifier] userInfo:@{ @"gpsLocation" : self.location,
                                                                                                                                                   @"title" : self.title }];
}

- (void)configWithAddress:(NSString *)address location:(NSString *)GPS title:(NSString *)title
{
    self.addressLabel.text = address;
    self.location = GPS;
    self.title = title;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    width = width == 414 ? width * 3 : width * 2;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    height = [UIScreen mainScreen].bounds.size.width == 414 ? height * 3 : height * 2;
    width = width > 1000 ? 1000 : width;
    height = width / 375.0 * 200;

    NSString *urlString = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage?zoom=18&ak=C3B5dT4wYAVs7iIhRiYUOEDt&markers=%@&width=%@&height=%@&dpiType=ph", self.location, @(width).stringValue, @(height).stringValue];

    [self.mapImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageRetryFailed];
}

@end
