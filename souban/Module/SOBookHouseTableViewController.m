//
//  SOBookHouseTableViewController.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBookHouseTableViewController.h"
#import "OMDateFormatter.h"
#import "OMHUDManager.h"
#import "OMHTTPClient+Building.h"
#import "SOBookingRequestModel.h"
#import "NSDate+CC.h"
#import "UIColor+PLNColors.h"


@interface SOBookHouseTableViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *timePicker;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UITextField *firstResponderTextField;

@property (weak, nonatomic) IBOutlet UITextField *preferTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *preferDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *alternateDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *alternateTimeTextField;

@end


@implementation SOBookHouseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预约看房";

    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = view;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [self setupPickView];
    [self setupTextFieldToolBar];
}


#pragma mark - Private Method

- (void)setupPickView
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];

    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(startDateSelected:) forControlEvents:UIControlEventValueChanged];

    self.timePicker = [UIPickerView new];
    self.timePicker.backgroundColor = [UIColor whiteColor];
    self.timePicker.delegate = self;
}

- (void)setupTextFieldToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 35.0f)];
    toolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneEdit)];
    [barButtonItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : SSColor(45, 116, 250) } forState:UIControlStateNormal];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    self.preferTimeTextField.inputAccessoryView = toolbar;
    self.preferDateTextField.inputAccessoryView = toolbar;
    self.alternateDateTextField.inputAccessoryView = toolbar;
    self.alternateTimeTextField.inputAccessoryView = toolbar;
}


- (void)doneEdit
{
    [self.view endEditing:YES];
}

- (IBAction)submit:(id)sender
{
    if (!self.preferTimeTextField.text.length || !self.preferDateTextField.text.length || !self.alternateDateTextField.text.length || !self.alternateTimeTextField.text.length) {
        [OMHUDManager showErrorWithStatus:@"请填写完整信息"];
        return;
    }
    [self.view endEditing:YES];
    SOBookingRequestModel *request = [[SOBookingRequestModel alloc] init];
    request.roomId = self.userInfo[@"roomId"];
    request.preferredTime = [NSString stringWithFormat:@"%@ %@", self.preferDateTextField.text, self.preferTimeTextField.text];
    request.alternativeTime = [NSString stringWithFormat:@"%@ %@", self.alternateDateTextField.text, self.alternateTimeTextField.text];

    [[OMHTTPClient realClient] submitBuildingBookingWithRequestModel:request completion:^(id resultObject, NSError *error) {
        if (error) {
            [OMHUDManager showErrorWithStatus:error.errorMessage];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"感谢您的提交，我们的专属客服经理将会联系到您！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)startDateSelected:(UIDatePicker *)datePicker
{
    if ([datePicker.date isEarlierThanDate:[NSDate date]]) {
        [datePicker setDate:[NSDate date]];
    }
    self.firstResponderTextField.text = [self.dateFormatter stringFromDate:datePicker.date];
}


#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.preferTimeTextField] || [textField isEqual:self.alternateTimeTextField]) {
        textField.inputView = self.timePicker;
        textField.text = [self.timePicker selectedRowInComponent:0] == 0 ? @"上午" : @"下午";
    } else {
        textField.inputView = self.datePicker;
        textField.text = [self.dateFormatter stringFromDate:self.datePicker.date];
    }
    self.firstResponderTextField = textField;
    return YES;
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}


#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"上午";
    } else {
        return @"下午";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *pickTime = row == 0 ? @"上午" : @"下午";
    self.firstResponderTextField.text = pickTime;
}

@end
