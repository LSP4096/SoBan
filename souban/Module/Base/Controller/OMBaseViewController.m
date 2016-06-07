//
//  OMBaseViewController.m
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMBaseViewController.h"
#import "kCommonMacro.h"


@implementation OMBaseViewController

+ (NSString *)storyboardIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];

    if ([self.userInfo[@"title"] isKindOfClass:[NSString class]] && [self.userInfo[@"title"] length] != 0) {
        self.navigationItem.title = self.userInfo[@"title"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    DDLogVerbose(@"%@ is dealloc", NSStringFromClass(self.class));
}
@end
