//
//  SOSubwaySummary.h
//  souban
//
//  Created by JiaHao on 12/25/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SOSubwayLocation <NSObject>
@end

@protocol SOSubwayBuilding <NSObject>
@end


@interface SOSubwayLocation : JSONModel

@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;
@end


@interface SOSubwayBuilding : JSONModel

@property (strong, nonatomic) NSString<Optional> *title;
@property (strong, nonatomic) NSNumber *buildingId;
@property (strong, nonatomic) NSNumber *roomCount;
@property (strong, nonatomic) SOSubwayLocation<Optional> *location;

@end


@interface SOSubwaySummary : JSONModel

@property (strong, nonatomic) NSNumber *totalCount;
@property (strong, nonatomic) NSString *centerLocation;
@property (strong, nonatomic) NSString *stationId;

@end
