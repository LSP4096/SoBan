//
//  OMBaseTableViewController.h
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMBaseControllerProtocol.h"
#import <MJRefresh.h>


@interface OMBaseTableViewController : UITableViewController <OMBaseControllerProtocol>
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, copy) dismissCallback dismissCallback;

+ (NSString *)storyboardIdentifier;

@end
