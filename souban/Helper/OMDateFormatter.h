//
//  OMDateFormatter.h
//  OfficeManager
//
//  Created by 周国勇 on 9/6/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OMDateFormatter : NSObject

+ (instancetype)sharedInstance;

/**
 *  转换毫秒到字符串
 *
 *  @param millisecond 1937年至今的毫秒数
 *
 *  @return ex:2015-12-12 15:20
 */
- (NSString *)dateTimeMinuteWithMsec:(long long)millisecond;

- (NSString *)dateTimeSecondsWithMsec:(long long)millisecond;

- (NSString *)dateTimeIgnoreYear:(long long)millisecond;

// 2015.1.1
- (NSString *)dotDateWithMsec:(long long)millsecond;
- (NSString *)timeWithMsec:(long long)millsecond;
@end
