//
//  SORoom.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SORoom.h"


@implementation SORoom

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"expand"]) {
        return YES;
    }
    return [super propertyIsIgnored:propertyName];
}

@end
