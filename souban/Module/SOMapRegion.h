//
//  SOMapRegion.h
//  souban
//
//  Created by JiaHao on 11/25/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "SOBuildingAnnotationView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@protocol SOMapSpan <NSObject>

@end
@protocol SOMapCenter <NSObject>

@end


@interface SOMapSpan : JSONModel

@property (strong, nonatomic) NSNumber *latitudeDelta;
@property (strong, nonatomic) NSNumber *longitudeDelta;

@end


@interface SOMapCenter : JSONModel

@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

@end


@interface SOMapRegion : JSONModel

@property (strong, nonatomic) SOMapCenter *center;
@property (strong, nonatomic) SOMapSpan *span;

+ (SOMapRegion *)SOMapRegionWithBMKRegion:(MACoordinateRegion)region;

@end
