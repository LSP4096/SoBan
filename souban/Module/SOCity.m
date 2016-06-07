//
//  SOCity.m
//  souban
//
//  Created by 周国勇 on 1/5/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOCity.h"
#import "GVUserDefaults+OM.h"
#import "NSNotificationCenter+OM.h"
#import "kCommonMacro.h"
#import "OMHTTPClient+Building.h"
#import "UIAlertView+BlocksKit.h"
#import <FCCurrentLocationGeocoder.h>

@implementation SOCity

+ (NSArray *)allServices {
    return @[@"roomDemand", @"roomSupply", @"incubator", @"enterpriseGift", @"partner", @"mortgage", @"monthlyPrice"];
}

+ (NSArray *)exploreServices {
    return @[@"incubator", @"enterpriseGift", @"partner"];
}

+ (NSArray *)allCityDataName {
    return @[@"incubator"];
}

- (NSString *)cityDataForName:(SOCityDataName)dataName {
    NSString *name = [[self class] allCityDataName][dataName];
    for (SOCityData *data in self.cityData) {
        if ([data.object isEqualToString:name]) {
            return data.objectData;
        }
    }
    return nil;
}

- (BOOL)supportForService:(SOServiceType)serviceType
{
    NSString *name = [[self class] allServices][serviceType];
    for (SOService *service in self.services) {
        if ([service.name isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)supportExploreServices;
{
    NSMutableArray *array = [NSMutableArray new];
    
    if ([self supportForService:SOServiceTypePartner]) {
        [array addObject:@(SOServiceTypePartner)];
    }
    if ([self supportForService:SOServiceTypeIncubator]) {
        [array addObject:@(SOServiceTypeIncubator)];
    }
    if ([self supportForService:SOServiceTypeEnterpriseGift]) {
        [array addObject:@(SOServiceTypeEnterpriseGift)];
    }
    return array;
}

+ (void)setCity:(SOCity *)aCity
{
    [GVUserDefaults standardUserDefaults].cityString = aCity.toJSONString;
    NSDictionary *userinfo = @{@"city":aCity};
    [NSNotificationCenter postNotificationName:kCityChanged userInfo:userinfo];
}

+ (instancetype)city
{
    NSError *error = nil;
    SOCity *city = [[SOCity alloc] initWithString:[GVUserDefaults standardUserDefaults].cityString error:&error];
    if (error) {
        DDLogError(@"error:%@", error);
        return nil;
    }
    return city;
}

+ (NSNumber *)currentCityId {
    SOCity *city = [[self class] city];
    return city.uniqueId;
}

+ (void)getLocationCityWithBlock:(void (^)(SOCity *))block {
    FCCurrentLocationGeocoder *geoCoder = [FCCurrentLocationGeocoder sharedGeocoder];
    geoCoder.canUseIPAddressAsFallback = NO;

    if (![geoCoder canGeocode]) {
        block(nil);
    } else {
        if ([geoCoder isGeocoding]) {
            [geoCoder cancelGeocode];
        }
        
        [geoCoder reverseGeocode:^(BOOL success) {
            NSInteger index = NSNotFound;
            if(success)
            {
                for (SOCity *city in [[self class] supportCitys]) {
                    if ([city.name isEqualToString:geoCoder.locationCity] || [[geoCoder.locationCity substringToIndex:geoCoder.locationCity.length-1] isEqualToString:city.name]) {
                        index = [[[self class] supportCitys] indexOfObject:city];
                        block(city);
                        break;
                    }
                }
            } else {
                block(nil);
            }
        }];
    }
}

+ (NSArray *)supportCitys {
    NSArray *dics = [NSArray arrayWithContentsOfFile:[[self class] filePath]];
    return [SOCity arrayOfModelsFromDictionaries:dics];
}

+ (void)setSupportCitys:(NSArray *)array {
    if (array.count == 0) {
        return;
    }
    NSMutableArray *dicArray = [NSMutableArray new];
    for (SOCity *city in array) {
        [dicArray addObject:city.toDictionary];
    }
    [dicArray writeToFile:[[self class] filePath] atomically:YES];
}

+ (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"city_list"];
    return path;
}

+ (void)checkCity // 流程:从服务端获取城市列表->定位->判断是否支持
{
    [[OMHTTPClient realClient] fetchCitysWithCompletion:^(id resultObject, NSError *error) {
        if (error) {
            if ([[self class] supportCitys].count != 0) {
                [self checkLocation];
            } else {
                [NSNotificationCenter postNotificationName:kCityChanged userInfo:nil];
            }
        } else {
            [[self class] setSupportCitys:resultObject];
            // 如果本地没有选中的city就默认选择第一个
            if (![[self class] city]) {
                [[self class] setCity:[resultObject firstObject]];
            }
            [self checkLocation];
        }
    }];
}

+ (void)checkLocation {
    [[self class] getLocationCityWithBlock:^(SOCity *city) {
        if (!city) {
            [NSNotificationCenter postNotificationName:kCityChanged userInfo:nil];
        } else {
            // 判断当前定位的城市与上次记录的id是否一样
            if (![[[self class] currentCityId] isEqualToNumber:city.uniqueId]) {
                // 提示是否更换
                NSString *message = [NSString stringWithFormat:@"定位显示您在%@，是否查看该城市的房源？", city.name];
                [UIAlertView bk_showAlertViewWithTitle:@"提示" message:message cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex != 0) {
                        [[self class] setCity:city];
                    } else {
                        [NSNotificationCenter postNotificationName:kCityChanged userInfo:nil];
                    }
                }];
            }else {
                [NSNotificationCenter postNotificationName:kCityChanged userInfo:nil];
            }
        }
    }];

}
@end

@implementation SOService

@end

@implementation SOCityData


@end