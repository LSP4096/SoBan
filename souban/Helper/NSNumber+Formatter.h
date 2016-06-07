//
//  NSNumber+Formatter.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNumber (Formatter)

- (NSString *)twoBitStringValue;
#pragma mark - Price
- (NSString *)buiildingPriceString;
- (NSString *)buiildingPriceStringForUnit:(NSString *)unit;
- (NSString *)perSquareMeterMonth;
- (NSString *)perSquareMeterDay;
- (NSString *)perSquareMeter;
- (NSString *)tenThousandPerMonthForUnit:(NSString *)priceUnit;
- (NSString *)tenThousandPerMonth;
- (NSString *)perMonth;
- (NSString *)perStationMonth;

#pragma mark - Build Desc Unit
- (NSString *)squareMeter;
- (NSString *)shopUnit;
- (NSString *)managementUnit;

- (NSString *)roomCountString;

@end
