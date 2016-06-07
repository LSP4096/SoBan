//
//  SOMyAccountViewController.m
//  souban
//
//  Created by JiaHao on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOMyAccountViewController.h"
#import "UIActionSheet+BlocksKit.h"
#import "OMHTTPClient+Authentication.h"
#import "OMHUDManager.h"
#import "OMUser.h"


@interface SOMyAccountViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@end


@implementation SOMyAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];
    self.mobileLabel.text = [OMUser user].phoneNum;
}


- (IBAction)logoutBtnTouched:(id)sender
{
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"确定要退出登录吗？"];
    [actionSheet bk_setDestructiveButtonWithTitle:@"确定" handler:^{
        [[OMHTTPClient realClient] logoutWithCompletion:^(id resultObject, NSError *error) {
            if (error) {
                [OMHUDManager showErrorWithStatus:error.errorMessage];
            }else{
                [OMUser setUser:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:^{
    }];
    [actionSheet showInView:self.view];
}


@end
