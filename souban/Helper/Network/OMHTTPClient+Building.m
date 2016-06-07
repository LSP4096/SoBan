//
//  OMHTTPClient+Building.m
//  souban
//
//  Created by 周国勇 on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMHTTPClient+Building.h"
#import "SOBuildingSummary.h"
#import "SOBuildingScreenModel.h"
#import "SOBookingRequestModel.h"
#import "SOScreenItems.h"
#import "SOBuilding.h"
#import "SORoom.h"
#import "SOBuildingStation.h"
#import "SOStationBuildingSummary.h"
#import "JSONCategory.h"
#import "SOPOISummary.h"
#import "SOPageModel.h"
#import "SOMapRegion.h"
#import "SOSubwaySummary.h"
#import "SOCity.h"


@implementation OMHTTPClient (Building)

- (NSURLSessionDataTask *)getNewRoomCountWithCompletion:(jsonResultBlock)completion
{
    return [self getWithRoutePath:@"newRoomCount" params:nil parseClass:nil block:completion];
}

- (NSURLSessionDataTask *)fetchBuildingListWithScreenModel:(SOBuildingScreenModel *)screenModel
                                                      page:(SOPageModel *)page
                                                completion:(jsonResultBlock)completion
{
    NSDictionary *dic = [screenModel dictionaryValue];

    NSMutableDictionary *para = page.toDictionary.mutableCopy;
    if (dic.allKeys.count != 0) {
        para[@"filter"] = [dic.JSONString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return [self getWithRoutePath:@"buildings" params:para parseClass:[SOBuildingSummary class] block:completion];
}

- (NSURLSessionDataTask *)submitBuildingBookingWithRequestModel:(SOBookingRequestModel *)model
                                                     completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = model.toDictionary.mutableCopy ? model.toDictionary.mutableCopy : @{}.mutableCopy;
    return [self postWithRoutePath:@"m_addBook_api" params:dic parseClass:nil block:completion];
}

- (NSURLSessionDataTask *)fetchBuildingListWithKeyword:(NSString *)keyword
                                                  page:(SOPageModel *)page
                                            completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = @{ @"keyword" : keyword }.mutableCopy;
    [dic setValuesForKeysWithDictionary:page.toDictionary];

    return [self getWithRoutePath:@"buildings" params:dic parseClass:[SOBuildingSummary class] block:completion];
}

- (NSURLSessionDataTask *)fetchStationBuildingListWithPage:(SOPageModel *)page
                                                  completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = page.toDictionary.mutableCopy;

    return [self getWithRoutePath:@"incubators" params:dic parseClass:[SOStationBuildingSummary class] block:completion];
}

- (NSURLSessionDataTask *)fetchBuildingDetailWithBuildingId:(NSNumber *)buildingId
                                                screenModel:(SOBuildingScreenModel *)screenModel
                                                 completion:(jsonResultBlock)completion
{
    NSDictionary *dic = [screenModel dictionaryValue];
    NSMutableDictionary *para = @{ @"buildingId" : buildingId }.mutableCopy;
    if (dic.allKeys.count != 0) {
        para[@"filter"] = [dic.JSONString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return [self getWithRoutePath:@"buildingDetail" params:para parseClass:[SOBuilding class] block:completion];
}

- (NSURLSessionDataTask *)fetchStationBuildingDetailWithBuildingId:(NSNumber *)buildingId
                                                        completion:(jsonResultBlock)completion
{
    return [self getWithRoutePath:@"incubatorDetail" params:@{ @"incubatorId" : buildingId } parseClass:[SOBuildingStation class] block:completion];
}

- (NSURLSessionDataTask *)fetchRoomsWithBuildingId:(NSNumber *)buildingId
                                              page:(SOPageModel *)page
                                        completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = @{ @"buildingId" : buildingId }.mutableCopy;
    [dic setValuesForKeysWithDictionary:page.toDictionary];
    return [self getWithRoutePath:@"rooms" params:dic parseClass:[SORoom class] block:completion];
}

- (NSURLSessionDataTask *)starRoomWithRoomId:(NSNumber *)roomId
                                  completion:(jsonResultBlock)completion
{
    return [self postWithRoutePath:@"m_collect_api" params:@{ @"objectId" : roomId,
                                                              @"object" : @(1) }
                        parseClass:nil
                             block:completion];
}

- (NSURLSessionDataTask *)unStarRoomWithRoomId:(NSNumber *)roomId
                                    completion:(jsonResultBlock)completion
{
    return [self postWithRoutePath:@"m_deleteCollect_api" params:@{ @"roomId" : roomId } parseClass:nil block:completion];
}

- (NSURLSessionDataTask *)fetchAreasListWithCompletion:(jsonResultBlock)completion
{
    return [self getWithRoutePath:@"areas" params:nil parseClass:[SOArea class] block:completion];
}

- (NSURLSessionDataTask *)fetchScreenItemsWithCompletion:(jsonResultBlock)completion
{

    [self setVersion:@"1.3"];
    return [self getWithRoutePath:@"filterItems" params:nil parseClass:[SOScreenItems class] block:completion];
}

- (NSURLSessionDataTask *)fetchBuildingGEOsWithScreenModel:(SOBuildingScreenModel *)screenModel
                                                   keyword:(NSString *)keyword
                                                  mapLevel:(NSInteger)level
                                                    region:(SOMapRegion *)region
                                                completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = screenModel.toDictionary.mutableCopy ? screenModel.toDictionary.mutableCopy : @{}.mutableCopy;
    [dic removeObjectForKey:@"areaId"];
    [dic removeObjectForKey:@"blockId"];
    if (screenModel.tagIds.count != 0) {
        NSMutableArray *array = [NSMutableArray new];
        for (NSNumber *tagId in screenModel.tagIds) {
            [array addObject:tagId.stringValue];
        }
        dic[@"tagIds"] = [array componentsJoinedByString:@","];
    }

    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"level"] = @(level);

    para[@"geoRegion"] = [region.toDictionary.JSONString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (dic.allKeys.count != 0) {
        para[@"filter"] = [dic.JSONString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (keyword) {
        para[@"keyword"] = keyword;
        [dic removeObjectForKey:@"filter"];
    }
    return [self postWithRoutePath:@"buildingGEOs" params:para parseClass:[SOPOISummary class] block:completion];
}

- (NSURLSessionDataTask *)fetchSubwayStopBuildingCountWithSOSubwayRegionScreenModels:(NSMutableArray *)subwayModels
                                                                 BuildingScreenModel:(SOBuildingScreenModel *)screenModel
                                                                          Completion:(jsonResultBlock)completion
{
    NSMutableDictionary *dic = screenModel.toDictionary.mutableCopy ? screenModel.toDictionary.mutableCopy : @{}.mutableCopy;
    [dic removeObjectForKey:@"areaId"];
    [dic removeObjectForKey:@"blockId"];
    if (screenModel.tagIds.count != 0) {
        NSMutableArray *array = [NSMutableArray new];
        for (NSNumber *tagId in screenModel.tagIds) {
            [array addObject:tagId.stringValue];
        }
        dic[@"tagIds"] = [array componentsJoinedByString:@","];
    }
    NSMutableDictionary *para = @{}.mutableCopy;
    para[@"geoRegions"] = [subwayModels.JSONString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (dic.allKeys.count != 0) {
        para[@"filter"] = [dic.JSONString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return [self getWithRoutePath:@"buildings/geos/metro" params:para parseClass:[SOSubwaySummary class] block:completion];
}

- (NSURLSessionDataTask *)fetchCitysWithCompletion:(jsonResultBlock)completion
{
    return [self getWithRoutePath:@"cities" params:nil parseClass:[SOCity class] block:completion];
}
@end
