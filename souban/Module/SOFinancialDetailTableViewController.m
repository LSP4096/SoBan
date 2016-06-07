//
//  SOFinancialDetailTableViewController.m
//  souban
//
//  Created by Rawlings on 1/26/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOFinancialDetailTableViewController.h"
#import "SOFlowChartView.h"
#import "UIView+Layout.h"

@interface SOFinancialDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *containerView;


@end

@implementation SOFinancialDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets insets = {-98, 0, 0, 0};
    self.tableView.contentInset = insets;
    
}


- (void)setImgArr:(NSArray *)imgArr{
    _imgArr = imgArr;
    
    if (imgArr && _textArr) {
        [self setupChart];
    }
}

- (void)setTextArr:(NSArray *)textArr{
    _textArr = textArr;
    
    if (textArr && _imgArr) {
        [self setupChart];
    }
}

- (void)setupChart{
    SOFlowChartView *chart = [SOFlowChartView chartWithImages:_imgArr Headers:_textArr progress:5];
    [self.containerView addSubview:chart];
}

@end
