//
//  OMDateFormatter.m
//  OfficeManager
//
//  Created by 周国勇 on 9/6/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMDateFormatter.h"


@interface OMDateFormatter ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end


@implementation OMDateFormatter

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)dateTimeMinuteWithMsec:(long long)millisecond
{
    if (!millisecond) {
        return @"";
    }
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:millisecond / 1000]];
}

- (NSString *)dateTimeSecondsWithMsec:(long long)millisecond
{
    if (!millisecond) {
        return @"";
    }
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:millisecond / 1000]];
}

- (NSString *)dateTimeIgnoreYear:(long long)millisecond
{
    if (!millisecond) {
        return @" ";
    }
    [self.dateFormatter setDateFormat:@"MM-dd HH:mm"];
    return [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:millisecond / 1000]];
}

- (NSString *)dotDateWithMsec:(long long)millsecond
{
    if (millsecond == 0) {
        return nil;
    }
    [self.dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:millsecond / 1000]];
}

- (NSString *)timeWithMsec:(long long)millsecond
{
    if (millsecond == 0) {
        return nil;
    }
    [self.dateFormatter setDateFormat:@"HH:mm"];
    return [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:millsecond / 1000]];
}
#pragma mark - Getter & Setter
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

@end
