//
//  SOInstallmentViewController.m
//  souban
//
//  Created by Rawlings on 1/25/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOInstallmentViewController.h"
#import "SOFlowChartView.h"
#import "SOFinancialDetailTableViewController.h"
#import "SOInstallmentTableViewController.h"

@interface SOInstallmentViewController ()

@end

@implementation SOInstallmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"业主按揭放大贷";
    
    [self configNext];
}

- (void)configNext{
    SOFinancialDetailTableViewController *childVC = (SOFinancialDetailTableViewController *)self.childViewControllers.firstObject;
    
    NSArray *imgArr = @[[UIImage imageNamed:@"iconFlowApply"],
                        [UIImage imageNamed:@"iconExamineAndApprove"],
                        [UIImage imageNamed:@"iconFlowContract"],
                        [UIImage imageNamed:@"iconFlowMoney"]
                        ];
    NSArray *textArr = @[@"1.提出申请提交资料", @"2.审批", @"3.签订合同", @"4.放款"];
    
    childVC.imgArr = imgArr;
    childVC.textArr = textArr;
}


- (IBAction)applyBtnClick:(id)sender {
    SOInstallmentTableViewController *vc = [[UIStoryboard storyboardWithName:@"Service" bundle:nil] instantiateViewControllerWithIdentifier:@"SOInstallmentTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
