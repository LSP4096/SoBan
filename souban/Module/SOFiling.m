//
//  SOFiling.m
//  souban
//
//  Created by 周国勇 on 12/23/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOFiling.h"


@implementation SOFiling

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"male"]) {
        return YES;
    }
    return [super propertyIsIgnored:propertyName];
}

- (BOOL)male
{
    return [self.gender isEqualToString:@"M"];
}

- (void)setMale:(BOOL)male
{
    self.gender = male ? @"M" : @"F";
}
@end
