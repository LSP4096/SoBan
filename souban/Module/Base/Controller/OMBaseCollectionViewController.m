//
//  OMBaseCollectionViewController.m
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMBaseCollectionViewController.h"
#import "kCommonMacro.h"
#import "UIColor+OM.h"


@implementation OMBaseCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    self.collectionView.backgroundView = view;
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
