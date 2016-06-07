//
//  SOFinancialViewController.m
//  souban
//
//  Created by Rawlings on 16/1/22.
//  Copyright © 2016年 wajiang. All rights reserved.
//

#import "SOFinancialViewController.h"
#import "SOMortgageViewController.h"
#import "SOInstallmentViewController.h"
#import "SOManageViewController.h"



@interface SOFinancialViewController ()

@end

@implementation SOFinancialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜办金融服务";
}




- (IBAction)mortgageClick:(id)sender {
    SOMortgageViewController *vc = [[UIStoryboard storyboardWithName:@"Service" bundle:nil] instantiateViewControllerWithIdentifier:@"SOMortgageViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)installmentClick:(id)sender {
    SOInstallmentViewController *vc = [[UIStoryboard storyboardWithName:@"Service" bundle:nil] instantiateViewControllerWithIdentifier:@"SOInstallmentViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)manageClick:(id)sender {
    SOManageViewController *vc = [[UIStoryboard storyboardWithName:@"Service" bundle:nil] instantiateViewControllerWithIdentifier:@"SOManageViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
