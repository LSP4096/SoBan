//
//  SOManageTableViewController.m
//  souban
//
//  Created by Rawlings on 1/26/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOManageTableViewController.h"
#import "UIWebView+MakeCall.h"
//#import "ActionSheetStringPicker.h"
#import "OMHUDManager.h"
#import "SOFinancialManageRequestModel.h"
#import "SOFinancialProviceModel.h"
//#import "ActionSheetCustomPickerDelegate.h"
//#import "ActionSheetCustomPicker.h"
#import "OMHTTPClient+Service.h"
#import "UIColor+PLNColors.h"
#import <objc/runtime.h>


@interface SOManageTableViewController ()<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate> // , ActionSheetCustomPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;/**<  户籍 */
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *socialSecurityTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (nonatomic, strong) UIPickerView *pickerLocation;/**<  */
@property (nonatomic, strong) UIPickerView *pickerSocialSecurity;/**<  */

@property (nonatomic, strong) NSArray *pickerSocialSecurityRows;/**<  */

@property (nonatomic, strong) NSArray<SOFinancialProviceModel *> *proviceList;/**<  */
@property (nonatomic, strong) NSArray<SOFinancialCityModel *> *cityList;/**<  */
@property (nonatomic, strong) NSArray<SOFinancialAreaModel *> *areaList;/**<  */

@property (nonatomic, strong) NSString *fetchAreaListResultFlag;/**< fetchAreaList 请求结果 */
@property (nonatomic, strong) NSString *requestTextFieldClickedFlag;/**< 控制 TextField 点击时请求未完成时的 HUD 显示 */

@property (nonatomic, strong) NSString *selectedProvice;/**<  */
@property (nonatomic, strong) NSString *selectedCity;/**<  */
@property (nonatomic, strong) NSString *selectedArea;/**<  */

@property (nonatomic, strong) NSString *lifePoint_RecordLocation;/**< 用于跟踪本控制器的生命周期 */
@property (nonatomic, strong) NSString *lifePoint_RecordsocialSecurity;/**< 用于跟踪本控制器的生命周期 */

@end

@implementation SOManageTableViewController
// ***********************************************************************************
#pragma mark - Setter / Getter
// ***********************************************************************************
- (void)setProviceList:(NSArray<SOFinancialProviceModel *> *)proviceList{
    if (proviceList.count == 0) {
        [OMHUDManager showErrorWithStatus:@"请求数据失败"];
        return;
    }
    _proviceList = proviceList;
}

- (NSArray *)pickerSocialSecurityRows{
    if (!_pickerSocialSecurityRows) {
        _pickerSocialSecurityRows = @[@"有", @"无"]; //@[ @"是", @"否" ];
    }
    return _pickerSocialSecurityRows;
}

- (void)setCityList:(NSArray<SOFinancialCityModel *> *)cityList{
    _cityList = cityList;
    
    NSInteger selectedCityIndex = [self.pickerLocation selectedRowInComponent:1]; // 第一次默认为0
    selectedCityIndex = (selectedCityIndex >= self.cityList.count) ? (self.cityList.count - 1) : selectedCityIndex;
    _areaList = [(SOFinancialCityModel *)cityList[selectedCityIndex] areas];
}


- (NSString *)selectedProvice{
    NSInteger selectedProviceIndex = [self.pickerLocation selectedRowInComponent:0];
    NSString *proviceName = [(SOFinancialProviceModel *)self.proviceList[selectedProviceIndex] name];
    return proviceName;
}

- (NSString *)selectedCity{
    NSInteger selectedCityIndex = [self.pickerLocation selectedRowInComponent:1];
    selectedCityIndex = (selectedCityIndex >= self.cityList.count) ? (self.cityList.count - 1) : selectedCityIndex;
    NSString *cityName = [(SOFinancialCityModel *)self.cityList[selectedCityIndex] name];
    return cityName;
}

- (NSString *)selectedArea{
    NSInteger selectedAreaIndex = [self.pickerLocation selectedRowInComponent:2];
    selectedAreaIndex = (selectedAreaIndex >= self.areaList.count) ? (self.areaList.count - 1) : selectedAreaIndex;
    NSString *areaName = [(SOFinancialAreaModel *)self.areaList[selectedAreaIndex] name];
    return areaName;
}

// ***********************************************************************************
#pragma mark - lifeCycle
// ***********************************************************************************
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"租客经营支持贷";
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self fetchAreaList];
    [self setupPickView];
    [self setupTextFieldToolBar];
}

// ***********************************************************************************
#pragma mark - Private
// ***********************************************************************************
- (void)updateLocationTextField{
    self.locationTextField.text = [NSString stringWithFormat:@"%@ %@ %@", self.selectedProvice, self.selectedCity, self.selectedArea];
}

- (void)setupPickView
{
    self.pickerLocation = [UIPickerView new];
    self.pickerLocation.backgroundColor = [UIColor whiteColor];
    self.pickerLocation.delegate = self;
    self.locationTextField.inputView = self.pickerLocation;
    
    self.pickerSocialSecurity = [UIPickerView new];
    self.pickerSocialSecurity.backgroundColor = [UIColor whiteColor];
    self.pickerSocialSecurity.delegate = self;
    self.socialSecurityTextField.inputView = self.pickerSocialSecurity;
}

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
    self.locationTextField.inputAccessoryView = toolbar;
    self.socialSecurityTextField.inputAccessoryView = toolbar;
    self.moneyTextField.inputAccessoryView = toolbar;
    self.remarkTextView.inputAccessoryView = toolbar;
}

- (void)doneEdit
{
    [self.view endEditing:YES];
}

// ***********************************************************************************
#pragma mark - IBAction
// ***********************************************************************************
- (IBAction)makePhoneCall:(id)sender {
    [UIWebView callWithString:@"4000571806"];
}


// ***********************************************************************************
#pragma mark - Networking
// ***********************************************************************************
- (void)fetchAreaList{
    [[OMHTTPClient realClient] fetchProviceListWithCompletion:^(id resultObject, NSError *error) {
        if (error) {
            self.fetchAreaListResultFlag = @"Failed";
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            self.fetchAreaListResultFlag = @"Succeed";
            if (self.requestTextFieldClickedFlag) {
                self.requestTextFieldClickedFlag = nil;
                [OMHUDManager showSuccessWithStatus:@"城市列表获取成功"];
            }
            self.proviceList = resultObject;
        }
    }];
}

- (IBAction)commitBtnClick:(id)sender {
    if (!self.locationTextField.text.length || !self.moneyTextField.text.length || !self.nameTextField.text.length || !self.socialSecurityTextField.text.length) {
        [OMHUDManager showErrorWithStatus:@"请填写正确且完整的信息"];
        return;
    }
    if (self.phoneNumTextField.text.length != 11) {
        [OMHUDManager showErrorWithStatus:@"请正确填写11位手机号码"];
        return;
    }
    
    SOFinancialManageRequestModel *request = [SOFinancialManageRequestModel new];
    request.areaCode = self.locationTextField.text;
    request.monthlyWage = @(self.moneyTextField.text.floatValue);
    request.name = self.nameTextField.text;
    request.phoneNum = self.phoneNumTextField.text;
    request.remarks = self.remarkTextView.text;
    request.socialSecurity = [self.socialSecurityTextField.text  isEqualToString:@"有"] ? @"是" : @"否";
    
    [OMHUDManager showActivityIndicatorMessage:@"提交中"];
    
    [[OMHTTPClient realClient] manageWithRequestModel:request completion:^(id resultObject, NSError *error) {
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
#pragma mark - UITextField Delegate
// ***********************************************************************************
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.locationTextField]) {
        if (!self.proviceList.count) {
            if ([self.fetchAreaListResultFlag isEqualToString:@"Failed"]) {
                [self fetchAreaList]; // request again
            }else{
                self.requestTextFieldClickedFlag = @"request didn't return yet";
            }
            [OMHUDManager showActivityIndicatorMessage:@"正在获取城市列表"];
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if ([textField isEqual:self.locationTextField]) {
        if (_lifePoint_RecordLocation) return;
        [self pickerView:self.pickerLocation didSelectRow:0 inComponent:0];
        _lifePoint_RecordLocation = @"Once Done";
        
    }else if ([textField isEqual:self.socialSecurityTextField]) {
        if (_lifePoint_RecordsocialSecurity) return;
        [self pickerView:self.pickerSocialSecurity didSelectRow:0 inComponent:0];
        _lifePoint_RecordsocialSecurity = @"Once Done";
    }
}

// ***********************************************************************************
#pragma mark - UIPickerViewDataSource
// ***********************************************************************************
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([pickerView isEqual:self.pickerLocation]) {
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.pickerLocation]) {
        switch (component) {
            case 0: return self.proviceList.count;
            case 1: return self.cityList.count;
            case 2: return self.areaList.count;
            default:break;
        }
        return 0;
    }else{
        return self.pickerSocialSecurityRows.count;
    }
}

// ***********************************************************************************
#pragma mark - UIPickerViewDelegate
// ***********************************************************************************
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.pickerLocation]) {
        switch (component) {
            case 0: return [(SOFinancialProviceModel *)self.proviceList[row] name];
            case 1: return [(SOFinancialCityModel *)self.cityList[row] name];
            case 2: return [(SOFinancialAreaModel *)self.areaList[row] name];
            default:break;
        }
        return nil;
    }else{
        return self.pickerSocialSecurityRows[row];
    }
}

/// update Action

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.pickerLocation]) {
        switch (component) {
            case 0:{
                self.cityList = [(SOFinancialProviceModel *)self.proviceList[row] citys];// 更新 areaList 在 Setter 方法中
                [pickerView reloadAllComponents];
                [self updateLocationTextField];
                return;
            }
            case 1:{
                self.areaList = [(SOFinancialCityModel *)self.cityList[row] areas];
                [pickerView reloadAllComponents];
                [self updateLocationTextField];
                return;
            }
            case 2:{
                [self updateLocationTextField];
                return;
            }
            default:break;
        }
    }else{
        self.socialSecurityTextField.text = self.pickerSocialSecurityRows[row];
    }
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
