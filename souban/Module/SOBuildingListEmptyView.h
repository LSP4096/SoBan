//
//  SOBuildingListEmptyView.h
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SOBuildingListEmptyView : UIView

- (void)configWithDescription:(NSString *)description buttonTitle:(NSString *)title buttonAction:(void (^)())buttonAction;

@end
