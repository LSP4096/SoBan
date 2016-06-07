//
//  SOManageViewController.m
//  souban
//
//  Created by Rawlings on 1/25/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOManageViewController.h"
#import "SOFlowChartView.h"
#import "SOFinancialDetailTableViewController.h"
#import "SOManageTableViewController.h"

@interface SOManageViewController ()

@end

@implementation SOManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"租客经营支持贷";
    
    [self configNext];
}

- (void)configNext{
    SOFinancialDetailTableViewController *childVC = (SOFinancialDetailTableViewController *)self.childViewControllers.firstObject;
    
    NSArray *imgArr = @[[UIImage imageNamed:@"iconFlowApply"],
                        [UIImage imageNamed:@"iconExamineAndApprove"],
                        [UIImage imageNamed:@"iconFlowContract"],
                        [UIImage imageNamed:@"iconFlowMoney"]
                        ];
    NSArray *textArr = @[@"1.提出申请提交资料", @"2.审批", @"3.签订合同", @"4.提供用途并放款"];
    
    childVC.imgArr = imgArr;
    childVC.textArr = textArr;
}

- (IBAction)applyBtnClick:(id)sender {
    SOManageTableViewController *vc = [[UIStoryboard storyboardWithName:@"Service" bundle:nil] instantiateViewControllerWithIdentifier:@"SOManageTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
