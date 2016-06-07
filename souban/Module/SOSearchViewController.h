//
//  SOSearchViewController.h
//  souban
//
//  Created by 周国勇 on 10/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseViewController.h"

@class SOSearchViewController;
@protocol SOSearchViewControllerDelegate <NSObject>

- (void)searchViewControllerDidSearchWithKeyword:(NSString *)keyword;

@end

/**
 *  搜索页面，关键词会在dismisscallback中传回：{keyword：NSString}
 */
@interface SOSearchViewController : OMBaseViewController

@property (weak, nonatomic) id<SOSearchViewControllerDelegate> delegate;

@end
