//
//  SOSearchViewController.m
//  souban
//
//  Created by 周国勇 on 10/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOSearchViewController.h"
#import "UIColor+OM.h"
#import "OMNavigationManager.h"
#import "SOBuildingListViewController.h"
#import "UIStoryboard+SO.h"
#import "SOSearchHistoryCell.h"
#import "NSNotificationCenter+OM.h"
#import "SOBuilding.h"


@interface SOSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *searchBarContainerView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) NSMutableArray *history;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@end


@implementation SOSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchBarContainerView.layer.borderColor = [UIColor at_warmGreyColor].CGColor;
    self.searchBarContainerView.layer.borderWidth = 0.5;
    [NSNotificationCenter registerNotificationWithObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification];

    [self.searchBar becomeFirstResponder];

    self.clearButton.layer.masksToBounds = YES;
    self.clearButton.layer.cornerRadius = 4;
    self.clearButton.layer.borderColor = [UIColor at_deepSkyBlueColor].CGColor;
    self.clearButton.layer.borderWidth = 1;

    self.history = [SOBuilding searchHistory].mutableCopy;
    if (self.history.count != 0) {
        [self.tableView reloadData];
    } else {
        self.tableView.hidden = YES;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat kbHeight =
        [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;

    self.tableViewBottomConstraint.constant = kbHeight;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<SOSearchViewControllerDelegate> delegate = self.delegate;
    NSString *keyword = self.history[indexPath.row];
    [self dismissViewControllerAnimated:NO completion:^{
        if ([delegate respondsToSelector:@selector(searchViewControllerDidSearchWithKeyword:)]) {
            [delegate searchViewControllerDidSearchWithKeyword:keyword];
        }
    }];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[SOSearchHistoryCell reuseIdentifier]];
    cell.nameLabel.text = self.history[indexPath.row];
    return cell;
}

#pragma mark - Action
- (IBAction)cancelButtonTapped:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (IBAction)clearHistory:(id)sender
{
    [self.history removeAllObjects];
    [SOBuilding clearHistory];
    [self.tableView reloadData];
    self.tableView.hidden = YES;
}
#pragma mark - SearchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    NSString *keyword = searchBar.text;
    [SOBuilding addSearchHistoryWithKeyword:keyword];

    id<SOSearchViewControllerDelegate> delegate = self.delegate;
    [self dismissViewControllerAnimated:NO completion:^{
        if ([delegate respondsToSelector:@selector(searchViewControllerDidSearchWithKeyword:)]) {
            [delegate searchViewControllerDidSearchWithKeyword:keyword];
        }
    }];
}

#pragma mark - Getter
- (NSMutableArray *)history
{
    if (!_history) {
        _history = [NSMutableArray new];
    }
    return _history;
}
@end
