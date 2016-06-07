//
//  SOPledgeLoadTableViewController.m
//  souban
//
//  Created by JiaHao on 12/25/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOPledgeLoadTableViewController.h"
#import "UIWebView+MakeCall.h"
#import "OMHUDManager.h"
#import "SOLoadRequestModel.h"
#import "OMHTTPClient+Service.h"
#import "UIColor+PLNColors.h"


@interface SOPledgeLoadTableViewController () <UITextFieldDelegate, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *buildingNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *rentStatusTextField;
@property (weak, nonatomic) IBOutlet UITextField *linkmanTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) NSArray *rentStatusTitles;

@end


@implementation SOPledgeLoadTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"抵押贷款";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = view;

    self.rentStatusTitles = @[ @"已租", @"未租" ];
    [self setupPickView];
    [self setupTextFieldToolBar];
}

- (void)setupTextFieldToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle = UIBarStyleDefault;

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneEdit)];
    [barButtonItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : SSColor(45, 116, 250) } forState:UIControlStateNormal];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];

    self.areaTextField.inputAccessoryView = toolbar;
    self.buildingNameTextField.inputAccessoryView = toolbar;
    self.mobileTextField.inputAccessoryView = toolbar;
    self.rentStatusTextField.inputAccessoryView = toolbar;
    self.linkmanTextField.inputAccessoryView = toolbar;
}

- (void)setupPickView
{
    self.pickView = [UIPickerView new];
    self.pickView.backgroundColor = [UIColor whiteColor];
    self.pickView = [UIPickerView new];
    self.pickView.backgroundColor = [UIColor whiteColor];
    self.pickView.delegate = self;
    self.rentStatusTextField.delegate = self;
    self.rentStatusTextField.inputView = self.pickView;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.rentStatusTextField]) {
        self.rentStatusTextField.text = self.rentStatusTitles[[self.pickView selectedRowInComponent:0]];
    }
    return YES;
}

- (void)doneEdit
{
    [self.view endEditing:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.rentStatusTextField]) {
        return NO;
    }
    return YES;
}


#pragma UIPickView Delegate &DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.rentStatusTitles.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.rentStatusTitles[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.rentStatusTextField.text = self.rentStatusTitles[row];
}


- (IBAction)submit:(id)sender
{
    if (!self.areaTextField.text.length || !self.buildingNameTextField.text.length || !self.rentStatusTextField.text.length || !self.linkmanTextField.text.length || !self.mobileTextField.text.length) {
        [OMHUDManager showErrorWithStatus:@"请填写完整的信息"];
        return;
    }
    SOLoadRequestModel *request = [SOLoadRequestModel new];
    request.leaseState = self.rentStatusTextField.text;
    request.areaSize = @(self.areaTextField.text.floatValue);
    request.name = self.linkmanTextField.text;
    request.phoneNum = self.mobileTextField.text;
    request.buildingName = self.buildingNameTextField.text;

    [OMHUDManager showActivityIndicatorMessage:@"提交中"];

    [[OMHTTPClient realClient] loanWithRequestModel:request completion:^(id resultObject, NSError *error) {
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            [OMHUDManager showSuccessWithStatus:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (IBAction)call:(id)sender
{
    [UIWebView callWithString:@"4000571806"];
}


- (NSArray *)rentStatusTitles
{
    if (_rentStatusTitles == nil) {
        _rentStatusTitles = [[NSArray alloc] init];
    }
    return _rentStatusTitles;
}

@end
