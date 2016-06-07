//
//  YYCache+JSONModel.m
//  souban
//
//  Created by 周国勇 on 1/8/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "YYCache+JSONModel.h"
#import "OMBaseModel.h"

@implementation YYCache (JSONModel)

+ (instancetype)cache {
    return [[[self class] alloc] initWithName:[NSBundle mainBundle].bundleIdentifier];
}

+ (void)saveObject:(id<NSCoding>)object forKey:(NSString *)key {
    [[[self class] cache] setObject:object forKey:key];
}

+ (void)saveJSONModel:(JSONModel *)model {
    [[self class] saveObject:model forKey:NSStringFromClass(model.class)];
}

+ (void)saveJSONModels:(NSArray *)models {
    JSONModel *model = models.firstObject;
    [[self class] saveObject:models forKey:NSStringFromClass(model.class)];
}

+ (void)saveJSONModel:(JSONModel *)model forKey:(NSString *)key {
    [[self class] saveObject:model forKey:key];
}

+ (void)saveJSONModels:(NSArray *)models forKey:(NSString *)key {
    [[self class] saveObject:models forKey:key];
}


+ (id<NSCoding>)objectForKey:(NSString *)key {
   return [[[self class] cache] objectForKey:key];
}

+ (__kindof JSONModel *)JSONModelForKey:(NSString *)key {
   return (id)[[self class] objectForKey:key];
}

+ (NSArray *)JSONModelsForKey:(NSString *)key {
    return (id)[[self class] objectForKey:key];
}

+ (__kindof JSONModel *)JSONModelForClass:(Class)jsonModelClass {
    return [[self class] JSONModelForKey:NSStringFromClass(jsonModelClass)];
}

+ (NSArray *)JSONModelsForClass:(Class)jsonModelClass {
    return [[self class] JSONModelsForKey:NSStringFromClass(jsonModelClass)];
}

@end
