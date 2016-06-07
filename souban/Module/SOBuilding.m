//
//  SOBuilding.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuilding.h"


@implementation SOBuilding

+ (NSArray *)searchHistory
{
    return [NSArray arrayWithContentsOfFile:[[self class] filePath]];
}

+ (void)addSearchHistoryWithKeyword:(NSString *)keyword
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[self class] searchHistory]];
    NSInteger index = [array indexOfObject:keyword];
    if (index == NSNotFound) {
        [array insertObject:keyword atIndex:0];
        [array writeToFile:[self filePath] atomically:YES];
    }
}

+ (void)clearHistory
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[self class] searchHistory]];
    [array removeAllObjects];
    [array writeToFile:[self filePath] atomically:YES];
}

+ (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"search_history"];
    return path;
}
@end


@implementation SOBuildingSummaryItem

@end


@implementation SOParkingInfo

@end
