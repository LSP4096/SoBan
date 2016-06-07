//
//  SODropDownMenuManager.h
//  JSDropDownMenuDemo
//
//  Created by 周国勇 on 10/27/15.
//  Copyright © 2015 jsfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSDropDownMenu.h"


typedef NS_ENUM(NSUInteger, ShowType) {
    TypeList = 0,
    TypeMap = 1, //地图没有区域选择;
};


@class SOBuildingScreenModel, SOScreenItems;

@protocol SODropDownMenuManagerDelegate <NSObject>

@optional
- (void)needRefreshData;

@end


@interface SODropDownMenuManager : NSObject <JSDropDownMenuDelegate, JSDropDownMenuDataSource>

@property (strong, nonatomic) JSDropDownMenu *dropDownMenu;

@property (strong, nonatomic) SOBuildingScreenModel *screenModel;
@property (strong, nonatomic) SOScreenItems *screenItems;
@property (nonatomic) id<SODropDownMenuManagerDelegate> delegate;
@property (nonatomic) ShowType showType;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame showType:(ShowType)type;

@end
