//
//  YYCache+JSONModel.h
//  souban
//
//  Created by 周国勇 on 1/8/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import <YYCache/YYCache.h>


@class JSONModel;
@interface YYCache (JSONModel)

+ (void)saveObject:(id<NSCoding>)object forKey:(NSString *)key;

+ (void)saveJSONModel:(JSONModel *)model;

+ (void)saveJSONModels:(NSArray *)models;

+ (void)saveJSONModel:(JSONModel *)model forKey:(NSString *)key;

+ (void)saveJSONModels:(NSArray *)models forKey:(NSString *)key;


+ (id<NSCoding>)objectForKey:(NSString *)key;

+ (__kindof JSONModel *)JSONModelForKey:(NSString *)key;

+ (NSArray *)JSONModelsForKey:(NSString *)key;

+ (__kindof JSONModel *)JSONModelForClass:(Class)jsonModelClass;

+ (NSArray *)JSONModelsForClass:(Class)jsonModelClass;

@end
