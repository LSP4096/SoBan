//
//  OMAboutTableViewViewController.m
//  OfficeManager
//
//  Created by 周国勇 on 9/5/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS


#import "OMAboutTableViewViewController.h"
#import "UIView+Layout.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Masonry.h"
#import "UIColor+PLNColors.h"


#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@interface OMAboutTableViewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;

@property (nonatomic, strong) UIScrollView *scrollView;/**<  */
@property (nonatomic, strong) UIView *contentView;/**< \ */
@end


@implementation OMAboutTableViewViewController

- (NSString *)tempText{
    return @"\u3000\u3000企业租户在寻求办公室的同时，都迫切希望马上能够有一个理想的办公环境，因此，“搜办平台”应运而生。\n\u3000\u3000“搜办平台”作为搜办办公产业链的第一个环节，主要为用户解决寻找办公室中信息获取难和效率低下两个痛点，通过优质的服务团队来抓取用户。以“找办公室，上搜办，效率真的很高”为核心准则，以“线上选房－预约咨询－免佣服务－实现交易“为标准流程，为业主方和用户之间搭建快速贴心的服务通道。\n\u3000\u3000“搜办平台”在2016年还推出了一系列企业礼包活动，主要是针对写字楼租赁的配套服务，与京东、滴滴出行、e家洁、58速运、网易等公司展开合作，涉及办公出行、企业采购、企业搬家、办公保洁、办公装修、绿植租赁等一整套企业服务的超值优惠赠送。针对创业公司，搜办也开启了众创空间的专题，帮助创业者与创业空间进行对接，并且双向不收取任何佣金。";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    
    [self setupScrollView];
    [self configContent];
    
}


- (void)setupScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView showsVerticalScrollIndicator];
    [scrollView flashScrollIndicators];
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.contentView = [[UIView alloc] init]; // WithFrame:CGRectMake(0, 0, screenW, screenH)
//    self.contentView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)configContent{
    UIImageView *iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_appIcon"]];
    
    UIImageView *textAboutusImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"textAboutus"]];
    
    UILabel *statementLabel = [[UILabel alloc] init];
    statementLabel.text = self.tempText;
    statementLabel.numberOfLines = 0;
    statementLabel.lineBreakMode = NSLineBreakByWordWrapping;
    statementLabel.font = [UIFont systemFontOfSize:14];
    statementLabel.textColor = [UIColor pln_slateGreyColor];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    companyLabel.text = @"杭州匠人网络科技有限公司";
    UILabel *copyrightLabel = [[UILabel alloc] init];
    copyrightLabel.text = @"Copyright © 2016";
    
    companyLabel.font = copyrightLabel.font = [UIFont systemFontOfSize:12];
    companyLabel.textColor = copyrightLabel.textColor = [UIColor pln_slateColor];
    companyLabel.alpha = copyrightLabel.alpha = 0.6;
    
    iconImgView.centerX = screenW / 2;
    textAboutusImgView.centerX = screenW / 2;
    statementLabel.centerX = screenW / 2;
    companyLabel.centerX = screenW / 2;
    copyrightLabel.centerX = screenW / 2;
    
    [self.contentView addSubview:iconImgView];
    [self.contentView addSubview:textAboutusImgView];
    [self.contentView addSubview:statementLabel];
    [self.contentView addSubview:companyLabel];
    [self.contentView addSubview:copyrightLabel];
    
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(50);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.equalTo(60);
        make.height.equalTo(60);
    }];
    
    [textAboutusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [statementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textAboutusImgView.mas_bottom).with.offset(20);
        make.left.equalTo(self.contentView.mas_left).with.offset(16);
        make.right.equalTo(self.contentView.mas_right).with.offset(-16);
        make.width.equalTo(screenW - 32);
    }];

    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statementLabel.mas_bottom).with.offset(50);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-25);
        make.top.equalTo(companyLabel.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
}




//- (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
//{
//    CGRect rect = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
//                    
//                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                   
//                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil]
//                    
//                                       context:nil];
//    
//    return rect.size.height;
//}

@end
