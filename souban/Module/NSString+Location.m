//
//  NSString+Location.m
//  souban
//
//  Created by 周国勇 on 11/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "NSString+Location.h"
#import <MAMapKit/MAMapKit.h>


@implementation NSString (Location)

- (CLLocationDegrees)latitude
{
    NSArray *array = [self componentsSeparatedByString:@","];
    return [array.lastObject doubleValue];
}

- (CLLocationDegrees)longitude
{
    NSArray *array = [self componentsSeparatedByString:@","];
    return [array.firstObject doubleValue];
}

- (CLLocationCoordinate2D)baidu2AmapWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    return MACoordinateConvert(CLLocationCoordinate2DMake(latitude, longitude), MACoordinateTypeBaidu);
}

- (CLLocationCoordinate2D)AmapCoordinate
{
    return [self baidu2AmapWithLatitude:self.latitude longitude:self.longitude];
}

- (NSString *)AmapLocationString
{
    CLLocationCoordinate2D location = [self baidu2AmapWithLatitude:self.latitude longitude:self.longitude];
    return [NSString stringWithFormat:@"%@,%@", @(location.longitude), @(location.latitude)];
}

- (CLLocationCoordinate2D)BaiduCoordinateWithAmapCoordinate:(CLLocationCoordinate2D)amapCoordinate
{
    double x = amapCoordinate.longitude, y = amapCoordinate.latitude;

    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    return CLLocationCoordinate2DMake(z * sin(theta) + 0.006, z * cos(theta) + 0.0065);
}

@end
