//
//  SOCity.h
//  souban
//
//  Created by 周国勇 on 1/5/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOTag.h"
#import "SOBuildingPOI.h"

typedef NS_ENUM(NSUInteger, SOServiceType) {
    SOServiceTypeRoomDemand = 0,
    SOServiceTypeRoomSupply = 1,
    SOServiceTypeIncubator = 2,
    SOServiceTypeEnterpriseGift = 3,
    SOServiceTypePartner = 4,
    SOServiceTypeMortgage = 5,
    SOServiceTypeMonthlyPrice
};

typedef NS_ENUM(NSUInteger, SOCityDataName) {
    SOCityDataNameIncubator,
};

@protocol SOService <NSObject>

@end

@interface SOService : SOTag

@end

@protocol SOCityData <NSObject>

@end

@interface SOCityData : JSONModel

@property (strong, nonatomic) NSString *object;
@property (strong, nonatomic) NSString *objectData;

@end

@interface SOCity : SOTag

@property (strong, nonatomic) NSArray<SOCityData> *cityData;
@property (strong, nonatomic) NSArray<SOService> *services;
@property (strong, nonatomic) SOPOILocation *location;

- (NSString *)cityDataForName:(SOCityDataName)dataName;

- (BOOL)supportForService:(SOServiceType)serviceType;

- (NSArray *)supportExploreServices;

+ (void)setCity:(SOCity *)aCity;

+ (instancetype)city;// 本地存储的城市
+ (NSNumber *)currentCityId;

+ (void)getLocationCityWithBlock:(void (^)(SOCity *city))block;// 定位后的城市，如果定位到的城市不在支持的城市列表中，返回nil

+ (NSArray *)supportCitys;
+ (void)setSupportCitys:(NSArray *)array;

+ (void)checkCity;// 流程:从服务端获取城市列表->定位->判断是否支持, 结果会发送通知
@end

 