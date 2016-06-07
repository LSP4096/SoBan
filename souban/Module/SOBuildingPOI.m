//
//  SOBuildingPOI.m
//  souban
//
//  Created by JiaHao on 11/18/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingPOI.h"


@implementation SOPOILocation

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"coordinate2d"]) {
        return YES;
    }
    return [super propertyIsIgnored:propertyName];
}

- (CLLocationCoordinate2D)coordinate2d {
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}
@end


@implementation SOBuildingPOI

@end
