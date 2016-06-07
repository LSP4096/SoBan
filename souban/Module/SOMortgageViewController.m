//
//  SOMortgageViewController.m
//  souban
//
//  Created by Rawlings on 1/25/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOMortgageViewController.h"
#import "SOFlowChartView.h"
#import "SOFinancialDetailTableViewController.h"
#import "SOMortgageTableViewController.h"

@interface SOMortgageViewController ()

@property (weak, nonatomic) IBOutlet UIView *ContainerView;


@end

@implementation SOMortgageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物业抵押贷";
    
    [self configNext];
    

}

- (void)configNext{
    SOFinancialDetailTableViewController *childVC = (SOFinancialDetailTableViewController *)self.childViewControllers.firstObject;
    
    NSArray *imgArr = @[[UIImage imageNamed:@"iconFlowApply"],
                        [UIImage imageNamed:@"iconExamineAndApprove"],
                        [UIImage imageNamed:@"iconFlowContract"],
                        [UIImage imageNamed:@"iconFlowCheckIn"],
                        [UIImage imageNamed:@"iconFlowMoney"]
                        ];
    NSArray *textArr = @[@"1.提出申请提交资料", @"2.审批", @"3.签订合同", @"4.办理抵押登记", @"5.提供用途并放款"];
    
    childVC.imgArr = imgArr;
    childVC.textArr = textArr;
}

- (IBAction)applyBtnClick:(id)sender {
    SOMortgageTableViewController *vc = [[UIStoryboard storyboardWithName:@"Service" bundle:nil] instantiateViewControllerWithIdentifier:@"SOMortgageTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
