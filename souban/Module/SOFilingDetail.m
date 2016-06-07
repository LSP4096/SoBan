//
//  SOFilingDetail.m
//  souban
//
//  Created by 周国勇 on 12/29/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOFilingDetail.h"


@implementation SOFilingDetail
//@property (nonatomic) long long createTime;
//@property (nonatomic) long long dealTime;
//@property (nonatomic) long long followUpTime;
//@property (nonatomic) long long lookTime;
//@property (nonatomic) long long payTime;
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"createTime"] || [propertyName isEqualToString:@"dealTime"] || [propertyName isEqualToString:@"followUpTime"] || [propertyName isEqualToString:@"lookTime"] || [propertyName isEqualToString:@"payTime"]) {
        return YES;
    }
    return [super propertyIsOptional:propertyName];
}

@end
