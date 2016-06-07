//
//  SDCycleScrollView+MediaURL.m
//  souban
//
//  Created by 周国勇 on 11/3/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SDCycleScrollView+MediaURL.h"
#import "NSString+URL.h"


@implementation SDCycleScrollView (MediaURL)

- (void)setMediaURLWithMedia:(NSArray<NSString *> *)medias
{
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *media in medias) {
        if (media.originURL) {
            [array addObject:media.originURL];
        }
    }
    [self setImageURLsGroup:array];
}

@end
