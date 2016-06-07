//
//  SOMapRegion.m
//  souban
//
//  Created by JiaHao on 11/25/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOMapRegion.h"
#import "NSString+Location.h"


@implementation SOMapSpan

@end


@implementation SOMapCenter

@end


@implementation SOMapRegion

+ (SOMapRegion *)SOMapRegionWithBMKRegion:(MACoordinateRegion)region
{
    SOMapRegion *regionModel = [[self alloc] init];
    regionModel.center = [SOMapCenter new];
    regionModel.span = [SOMapSpan new];
    CLLocationCoordinate2D centerBaidu = [@"" BaiduCoordinateWithAmapCoordinate:region.center];
    regionModel.center.latitude = @(centerBaidu.latitude);
    regionModel.center.longitude = @(centerBaidu.longitude);
    regionModel.span.latitudeDelta = @(region.span.latitudeDelta / 2);
    regionModel.span.longitudeDelta = @(region.span.longitudeDelta / 2);
    return regionModel;
}

@end
