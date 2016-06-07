//
//  NSString+Location.h
//  souban
//
//  Created by 周国勇 on 11/30/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface NSString (Location)

- (CLLocationDegrees)latitude;
- (CLLocationDegrees)longitude;
- (NSString *)AmapLocationString;
- (CLLocationCoordinate2D)AmapCoordinate;

- (CLLocationCoordinate2D)BaiduCoordinateWithAmapCoordinate:(CLLocationCoordinate2D)amapCoordinate;

@end
