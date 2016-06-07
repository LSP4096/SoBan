//
//  SOMortgageTableViewController.m
//  souban
//
//  Created by Rawlings on 1/26/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOMortgageTableViewController.h"
#import "UIWebView+MakeCall.h"
#import "ActionSheetStringPicker.h"
#import "OMHUDManager.h"
#import "SOFinancialAreasModel.h"
#import "OMHTTPClient+Service.h"
#import "SOFinancialMortgageRequestModel.h"
#import "UIColor+PLNColors.h"


@interface SOMortgageTableViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *districtTextField;/**< 商圈 */
@property (weak, nonatomic) IBOutlet UITextField *buildingTextField;
@property (weak, nonatomic) IBOutlet UITextField *rentStateTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyNumTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;


@property (nonatomic, strong) ActionSheetStringPicker *pickerCity;/**<  */
@property (nonatomic, strong) ActionSheetStringPicker *pickerBlock;/**<  */
@property (nonatomic, strong) ActionSheetStringPicker *pickerRent;/**<  */
@property (nonatomic, strong) NSArray *pickerCityRows;/**<  */
@property (nonatomic, strong) NSArray *pickerBlockRows;/**<  */
@property (nonatomic, strong) NSArray *pickerRentRows;/**<  */

@property (nonatomic, strong) NSNumber *selectedBlockID;/**<  */

@property (nonatomic, strong) NSArray<SOFinancialAreasModel *> *areaList;/**<  */
@property (nonatomic, strong) NSString *requestTextFieldClickedFlag;/**< 控制 TextField 点击时请求未完成时的 HUD 显示 */
@property (nonatomic, strong) NSString *fetchAreaListResultFlag;/**< fetchAreaList请求结果 */

@end

@implementation SOMortgageTableViewController

// ***********************************************************************************
#pragma mark - Setter / Getter
// ***********************************************************************************
- (void)setAreaList:(NSArray<SOFinancialAreasModel *> *)areaList{
    if (areaList.count == 0) {
        [OMHUDManager showErrorWithStatus:@"请求数据失败"];
        return;
    }
    
    _areaList = areaList;
    
    self.pickerCity = [[ActionSheetStringPicker alloc] initWithTitle:@"城市/区域" rows:self.pickerCityRows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.locationTextField.text = selectedValue;
        [self configPickerBlocksWithIndex:selectedIndex];
    } cancelBlock:^(ActionSheetStringPicker *picker) { } origin:self.view];
    
    self.pickerRent = [[ActionSheetStringPicker alloc] initWithTitle:@"租赁状态" rows:self.pickerRentRows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.rentStateTextField.text = selectedValue;
    } cancelBlock:^(ActionSheetStringPicker *picker) { } origin:self.view];
}

- (NSArray *)pickerCityRows{
    if (!_pickerCityRows) {
        NSMutableArray *arr = [NSMutableArray array];
        for (SOFinancialAreasModel *model in self.areaList) {
            [arr addObject:model.name];
        }
        _pickerCityRows = arr;
    }
    return _pickerCityRows;
}

- (NSArray *)pickerRentRows{
    _pickerRentRows = @[@"已租", @"未租"]; //@[ @"是", @"否" ];
    return _pickerRentRows;
}

// ***********************************************************************************
#pragma mark - lifeCycle
// ***********************************************************************************
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物业抵押贷";
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self fetchAreaList];
    [self setupTextFieldToolBar];
}

// ***********************************************************************************
#pragma mark - Private
// ***********************************************************************************
- (void)configPickerBlocksWithIndex:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    for (SOFinancialAreasBlockModel *blockModel in [(SOFinancialAreasModel *)self.areaList[index] blocks]) {
        [arr addObject:blockModel.name];
    }
    self.pickerBlockRows = arr;
    
    self.pickerBlock = [[ActionSheetStringPicker alloc] initWithTitle:@"商圈" rows:self.pickerBlockRows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.districtTextField.text = selectedValue;
        NSArray *blockArr = [(SOFinancialAreasModel *)self.areaList[index] blocks];
        self.selectedBlockID = [(SOFinancialAreasBlockModel *)blockArr[selectedIndex] uniqueId];
    } cancelBlock:^(ActionSheetStringPicker *picker) { } origin:self.view];
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
//    self.locationTextField.inputAccessoryView = toolbar;
//    self.districtTextField.inputAccessoryView = toolbar;
    self.buildingTextField.inputAccessoryView = toolbar;
    self.rentStateTextField.inputAccessoryView = toolbar;
    self.moneyNumTextField.inputAccessoryView = toolbar;
    self.remarkTextView.inputAccessoryView = toolbar;
}

- (void)doneEdit
{
    [self.view endEditing:YES];
}

// ***********************************************************************************
#pragma mark - Networking
// ***********************************************************************************
- (void)fetchAreaList{
    [[OMHTTPClient realClient] fetchAreasListWithCompletion:^(id resultObject, NSError *error) {
        if (error) {
            self.fetchAreaListResultFlag = @"Failed";
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            self.fetchAreaListResultFlag = @"Succeed";
            if (self.requestTextFieldClickedFlag) {
                self.requestTextFieldClickedFlag = nil;
                [OMHUDManager showSuccessWithStatus:@"户籍列表获取成功"];
            }
            self.areaList = resultObject;
        }
    }];
}

- (IBAction)commitBtnClick:(id)sender {
    if (!self.locationTextField.text.length || !self.districtTextField.text.length || !self.rentStateTextField.text.length || !self.buildingTextField.text.length || !self.moneyNumTextField.text.length || !self.nameTextField.text.length) {
        [OMHUDManager showErrorWithStatus:@"请填写正确且完整的信息"];
        return;
    }
    if (self.phoneNumTextField.text.length != 11) {
        [OMHUDManager showErrorWithStatus:@"请正确填写11位手机号码"];
        return;
    }
    
    SOFinancialMortgageRequestModel *request = [SOFinancialMortgageRequestModel new];
    request.applyAmount = @(self.moneyNumTextField.text.floatValue);
    request.blockId = self.selectedBlockID;
    request.buildingName = self.buildingTextField.text;
    request.leaseStatus = [self.rentStateTextField.text isEqualToString:@"已租"] ? @"是" : @"否";
    request.name = self.nameTextField.text;
    request.phoneNum = self.phoneNumTextField.text;
    request.remarks = self.remarkTextView.text;
    
    [OMHUDManager showActivityIndicatorMessage:@"提交中"];
    
    [[OMHTTPClient realClient] MortgageWithRequestModel:request completion:^(id resultObject, NSError *error) {
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
#pragma mark - IBAction
// ***********************************************************************************
- (IBAction)makePhoneCall:(id)sender {
    [UIWebView callWithString:@"4000571806"];
}

// ***********************************************************************************
#pragma mark - textField Delegate
// ***********************************************************************************
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.locationTextField] || [textField isEqual:self.districtTextField]) {
        if (!self.areaList.count) {
            if ([self.fetchAreaListResultFlag isEqualToString:@"Failed"]) {
                [self fetchAreaList]; // request again
            }else{
                self.requestTextFieldClickedFlag = @"request didn't return yet";
            }
            [OMHUDManager showActivityIndicatorMessage:@"正在获取户籍列表"];
            
            return NO;
        }
    }
    
    if ([textField isEqual:self.locationTextField]){
        [self.pickerCity showActionSheetPicker];
        [self.view endEditing:YES];
        return NO;
    }else if ([textField isEqual:self.districtTextField]){
        if (self.locationTextField.text.length) {
            [self.pickerBlock showActionSheetPicker];
            [self.view endEditing:YES];
            return NO;
        }else{
            [OMHUDManager showInfoWithStatus:@"请先选择 城市/区域 "];
            [self.view endEditing:YES];
            return NO;
        }
    }else if ([textField isEqual:self.rentStateTextField]) {
        [self.pickerRent showActionSheetPicker];
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
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
