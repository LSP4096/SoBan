//
//  OMHTTPClient+Building.h
//  souban
//
//  Created by 周国勇 on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMHTTPClient.h"
#import "SOMapRegion.h"
#import "SOSubwayRegionScreenModel.h"

@class SOBuildingScreenModel, SOBookingRequestModel, SOPageModel;


@interface OMHTTPClient (Building)

- (NSURLSessionDataTask *)getNewRoomCountWithCompletion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchBuildingListWithScreenModel:(SOBuildingScreenModel *)screenModel
                                                      page:(SOPageModel *)page
                                                completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchBuildingListWithKeyword:(NSString *)keyword
                                                  page:(SOPageModel *)page
                                            completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchStationBuildingListWithPage:(SOPageModel *)page
                                                  completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchBuildingDetailWithBuildingId:(NSNumber *)buildingId
                                                screenModel:(SOBuildingScreenModel *)screenModel
                                                 completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchStationBuildingDetailWithBuildingId:(NSNumber *)buildingId
                                                        completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchRoomsWithBuildingId:(NSNumber *)buildingId
                                              page:(SOPageModel *)page
                                        completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)starRoomWithRoomId:(NSNumber *)roomId
                                  completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)unStarRoomWithRoomId:(NSNumber *)roomId
                                    completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)submitBuildingBookingWithRequestModel:(SOBookingRequestModel *)model
                                                     completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchAreasListWithCompletion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchScreenItemsWithCompletion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchBuildingGEOsWithScreenModel:(SOBuildingScreenModel *)screenModel
                                                   keyword:(NSString *)keyword
                                                  mapLevel:(NSInteger)level
                                                    region:(SOMapRegion *)region
                                                completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchSubwayStopBuildingCountWithSOSubwayRegionScreenModels:(NSMutableArray *)subwayModels
                                                                 BuildingScreenModel:(SOBuildingScreenModel *)screenModel
                                                                          Completion:(jsonResultBlock)completion;

- (NSURLSessionDataTask *)fetchCitysWithCompletion:(jsonResultBlock)completion;
@end
