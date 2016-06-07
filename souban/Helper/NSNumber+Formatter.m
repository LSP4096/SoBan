//
//  NSNumber+Formatter.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "NSNumber+Formatter.h"
#import "SOCity.h"


@implementation NSNumber (Formatter)

- (NSString *)twoBitStringValue
{
    return @([NSString stringWithFormat:@"%0.2f", self.floatValue].floatValue).stringValue;
}

#pragma mark - Price

- (NSString *)buiildingPriceString {
    return [[SOCity city] supportForService:SOServiceTypeMonthlyPrice]?self.perSquareMeterMonth:self.perSquareMeterDay;
}

- (NSString *)buiildingPriceStringForUnit:(NSString *)unit {
    return [unit isEqualToString:@"D"]?self.perSquareMeterDay:self.perSquareMeterMonth;
}

- (NSString *)perSquareMeterMonth
{
    return [NSString stringWithFormat:@"%@元/m²·月", self.twoBitStringValue];
}

- (NSString *)perSquareMeterDay
{
    return [NSString stringWithFormat:@"%@元/m²·天", self.twoBitStringValue];
}

- (NSString *)perSquareMeter
{

    NSString *value = [[SOCity city] supportForService:SOServiceTypeMonthlyPrice]?@(self.floatValue*30).twoBitStringValue:self.twoBitStringValue;
    return [NSString stringWithFormat:@"%@元/m²", value];
}

- (NSString *)tenThousandPerMonthForUnit:(NSString *)priceUnit
{
    float number = [priceUnit isEqualToString:@"D"]?30:1;
    return @(self.floatValue*number/10000).tenThousandPerMonth;
}

- (NSString *)tenThousandPerMonth
{
    return [NSString stringWithFormat:@"%@万/月", self.twoBitStringValue];
}

- (NSString *)perMonth
{
    return [NSString stringWithFormat:@"%@元/月", self.twoBitStringValue];
}

- (NSString *)perStationMonth
{
    return [NSString stringWithFormat:@"%@元/工位/月", self.twoBitStringValue];
}
#pragma mark - Build Desc Unit
- (NSString *)squareMeter
{
    return [NSString stringWithFormat:@"%@m²", self.stringValue];
}

- (NSString *)shopUnit
{
    return [NSString stringWithFormat:@"%@家", self.stringValue];
}

- (NSString *)managementUnit
{
    return [NSString stringWithFormat:@"%@元/㎡/月", self.twoBitStringValue];
}

- (NSString *)roomCountString
{
    return [NSString stringWithFormat:@"%@套", self.stringValue];
}
@end
