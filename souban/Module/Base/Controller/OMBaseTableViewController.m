//
//  OMBaseTableViewController.m
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMBaseTableViewController.h"
#import "UIColor+OM.h"
#import "kCommonMacro.h"


@implementation OMBaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor grayLineColor];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    self.tableView.backgroundView = view;

    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

+ (NSString *)storyboardIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)dealloc
{
    DDLogVerbose(@"%@ is dealloc", NSStringFromClass(self.class));
}
@end
