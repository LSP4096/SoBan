//
//  SOBuilding.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOSurround.h"
#import "SOTraffic.h"
#import "SORoom.h"
#import "SOTag.h"
#import "SOLocation.h"

typedef NS_ENUM(NSUInteger, SOManagementDescription) {
    SOManagementDescriptionIncludeExpense = 0,
    SOManagementDescriptionUnIncludeExpense
};

typedef NS_ENUM(NSUInteger, SOProprietorType) {
    SOProprietorTypeBig = 0,
    SOProprietorTypeSmall
};

@protocol SOBuildingSummaryItem <NSObject>

@end


@interface SOBuildingSummaryItem : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *value;

@end


@interface SOParkingInfo : JSONModel

@property (strong, nonatomic) NSNumber *parkingExpensesHour;// 0免费，-1不显示
@property (strong, nonatomic) NSNumber *parkingCount;
@property (strong, nonatomic) NSNumber *parkingExpenses;// 0免费，-1不显示

@end


@interface SOBuilding : OMBaseModel

@property (strong, nonatomic) NSArray<Optional> *images;
@property (strong, nonatomic) NSString *buildingDescription;
@property (strong, nonatomic) SOParkingInfo *parkingInfo;
@property (strong, nonatomic) NSArray<SOBuildingSummaryItem> *summaryInfo;
@property (strong, nonatomic) NSMutableArray<SORoom> *rooms;
@property (strong, nonatomic) NSArray<SOSurround> *surround;
@property (strong, nonatomic) NSArray<SOTraffic> *traffic;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *priceUnit;
@property (strong, nonatomic) NSNumber *roomCount;
@property (strong, nonatomic) NSArray<SOTag, Optional> *tags;
@property (strong, nonatomic) SOLocation *location;

// 搜索记录相关
+ (NSArray *)searchHistory;
+ (void)addSearchHistoryWithKeyword:(NSString *)keyword;
+ (void)clearHistory;
@end
