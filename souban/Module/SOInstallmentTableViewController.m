//
//  SOInstallmentTableViewController.m
//  souban
//
//  Created by Rawlings on 1/26/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOInstallmentTableViewController.h"
#import "UIWebView+MakeCall.h"
#import "OMHUDManager.h"
#import "SOFinancialInstallmentRequestModel.h"
#import "OMHTTPClient+Service.h"
#import "UIColor+PLNColors.h"

@interface SOInstallmentTableViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *buildingTextField;
@property (weak, nonatomic) IBOutlet UITextField *jobTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation SOInstallmentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"业主按揭放大贷";
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self setupTextFieldToolBar];
}


- (IBAction)makePhoneCall:(id)sender {
    [UIWebView callWithString:@"4000571806"];
}

// ***********************************************************************************
#pragma mark - Private
// ***********************************************************************************
- (void)setupTextFieldToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneEdit)];
    [barButtonItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : SSColor(45, 116, 250) } forState:UIControlStateNormal];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    self.nameTextField.inputAccessoryView = toolbar;
    self.phoneNumTextField.inputAccessoryView = toolbar;
    self.buildingTextField.inputAccessoryView = toolbar;
    self.jobTextField.inputAccessoryView = toolbar;
    self.moneyTextField.inputAccessoryView = toolbar;
    self.remarkTextView.inputAccessoryView = toolbar;
}

- (void)doneEdit
{
    [self.view endEditing:YES];
}


// ***********************************************************************************
#pragma mark - Networking
// ***********************************************************************************
- (IBAction)commitBtnClick:(id)sender {
    if (!self.buildingTextField.text.length || !self.jobTextField.text.length || !self.moneyTextField.text.length || !self.nameTextField.text.length) {
        [OMHUDManager showErrorWithStatus:@"请填写正确且完整的信息"];
        return;
    }
    if (self.phoneNumTextField.text.length != 11) {
        [OMHUDManager showErrorWithStatus:@"请正确填写11位手机号码"];
        return;
    }
    
    SOFinancialInstallmentRequestModel *request = [SOFinancialInstallmentRequestModel new];
    request.buildingName = self.buildingTextField.text;
    request.job = self.jobTextField.text;
    request.monthlyAmount = @(self.moneyTextField.text.floatValue);
    request.name = self.nameTextField.text;
    request.phoneNum = self.phoneNumTextField.text;
    request.remarks = self.remarkTextView.text;
    
    [OMHUDManager showActivityIndicatorMessage:@"提交中"];
    
    [[OMHTTPClient realClient] installmentWithRequestModel:request completion:^(id resultObject, NSError *error) {
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            [OMHUDManager showSuccessWithStatus:@"感谢您的提交，我们的专属客服经理将会联系到您！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

// ***********************************************************************************
#pragma mark - UITextView Delegate
// ***********************************************************************************
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.placeholderLabel.text = @"";
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeholderLabel.text = @"请在这里输入您更多的需求!";
    }
}

@end
