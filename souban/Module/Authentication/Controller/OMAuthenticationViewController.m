//
//  OMResetPasswordViewController.m
//  OfficeManager
//
//  Created by JiaHao on 9/6/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMAuthenticationViewController.h"
#import "OMLimitTextfield.h"
#import "OMHTTPClient+Authentication.h"
#import "OMCountDownButton.h"
#import "OMHUDManager.h"
#import "NSError+ErrorMessage.h"
#import "OMResponse.h"
#import "OMUser.h"


@interface OMAuthenticationViewController ()

@property (weak, nonatomic) IBOutlet OMLimitTextfield *mobileTextField;
@property (weak, nonatomic) IBOutlet OMLimitTextfield *authCodeTextField;
@property (weak, nonatomic) IBOutlet OMCountDownButton *verifyCodeButton;


@end


@implementation OMAuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.mobileTextField addTarget:self
                             action:@selector(textFieldDidChanged)
                   forControlEvents:UIControlEventEditingChanged];
    [self.authCodeTextField addTarget:self
                               action:@selector(textFieldDidChanged)
                     forControlEvents:UIControlEventEditingChanged];

    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = view;
}

- (IBAction)cancelTapped:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextStep:(id)sender
{
    if (self.mobileTextField.text.length != 11) {
        [OMHUDManager showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if (self.authCodeTextField.text.length == 0) {
        [OMHUDManager showErrorWithStatus:@"请输入手机验证码"];
        return;
    }

    [OMHUDManager showActivityIndicatorMessage:@"请求中..."];
    [[OMHTTPClient realClient] loginByMobile:self.mobileTextField.text authCode:self.authCodeTextField.text completion:^(id resultObject, NSError *error) {
        if (!error.hudMessage) {
            [OMUser setUser:resultObject];
            [OMHUDManager showSuccessWithStatus:@"登录成功"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)requestVerifyCode:(id)sender
{
    if (self.mobileTextField.text.length != 11) {
        [OMHUDManager showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    [OMHUDManager showActivityIndicatorMessage:@"发送中..."];
    [[OMHTTPClient realClient] requestVertificationCodeByMobile:self.mobileTextField.text completion:^(id resultObject, NSError *error) {
        if (!error.hudMessage) {
            [OMHUDManager dismiss];
            [self.verifyCodeButton beginCountDownWithSecond:60];
        }
    }];
}

- (void)textFieldDidChanged
{
    self.mobileTextField.isCorrectText = self.mobileTextField.text.length == 11 ? YES : NO;
}


@end
