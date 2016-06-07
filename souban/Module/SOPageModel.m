//
//  SOPageModel.m
//  souban
//
//  Created by 周国勇 on 11/20/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOPageModel.h"
#import "OMBaseModel.h"


@implementation SOPageModel

+ (instancetype)pageWithObjects:(NSArray *)objects limit:(NSInteger)limit
{
    OMBaseModel *model = objects.lastObject;
    return [[self alloc] initWithLimit:limit currentCount:objects.count lastObjectId:model.uniqueId];
}

+ (instancetype)pageWithLimit:(NSInteger)limit currentCount:(NSInteger)currentCount lastObjectId:(NSNumber *)lastObject
{
    return [[self alloc] initWithLimit:limit currentCount:currentCount lastObjectId:lastObject];
}

+ (instancetype)pageWithLimit:(NSInteger)limit
{
    return [[self alloc] initWithLimit:limit currentCount:0 lastObjectId:nil];
}

- (instancetype)initWithLimit:(NSInteger)limit currentCount:(NSInteger)currentCount lastObjectId:(NSNumber *)lastObject
{
    if (self = [super init]) {
        self.limit = @(limit);
        self.currentCount = @(currentCount);
        self.lastObjectId = lastObject ? lastObject : @(0);
    }
    return self;
}

@end
