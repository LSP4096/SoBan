//
//  SOBuildingScreenModel.m
//  souban
//
//  Created by 周国勇 on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOBuildingScreenModel.h"
#import "JSONCategory.h"


@implementation SOBuildingScreenModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (NSMutableArray *)tagIds
{
    if (!_tagIds) {
        _tagIds = [NSMutableArray new];
    }
    return _tagIds;
}

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *dic = self.toDictionary.mutableCopy ? self.toDictionary.mutableCopy : @{}.mutableCopy;
    if (dic[@"blockId"]) {
        [dic removeObjectForKey:@"areaId"];
    }
    if (self.tagIds.count != 0) {
        NSMutableArray *array = [NSMutableArray new];
        for (NSNumber *tagId in self.tagIds) {
            [array addObject:tagId.stringValue];
        }
        dic[@"tagIds"] = [array componentsJoinedByString:@","];
    }
    return dic.allKeys.count == 0 ? nil : dic;
}

@end


@implementation NSMutableArray (Unique)

- (void)addUniqueId:(NSNumber *)number
{
    if ([self containsObject:number]) {
        [self addObject:number];
    }
}

- (void)removeUniqueId:(NSNumber *)number
{
    if ([self containsObject:number]) {
        [self removeObject:number];
    }
}

@end
