//
//  BTBaseModel.m
//  BailkalTravel
//
//  Created by 周国勇 on 7/24/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import "OMBaseModel.h"


@implementation OMBaseModel

/**
 *  mapperFromUnderscoreCaseToCamelCase, convert 'id' to 'uniqueId'.
 *
 *  @return JSONKeyMapper Instance
 */
+ (JSONKeyMapper *)keyMapper
{
    //    JSONKeyMapper *jsonKeyMapper = [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];

    JSONModelKeyMapBlock toModel = ^NSString *(NSString *keyName)
    {
        if ([keyName isEqualToString:@"id"]) return @"uniqueId";
        //        if ([keyName isEqualToString:@"description"]) return @"goodsDescription";

        //        return jsonKeyMapper.JSONToModelKeyBlock(keyName);
        return keyName;
    };

    JSONModelKeyMapBlock toJSON = ^NSString *(NSString *keyName)
    {
        if ([keyName isEqualToString:@"uniqueId"]) return @"id";
        //        if ([keyName isEqualToString:@"goodsDescription"]) return @"description";

        //        return jsonKeyMapper.modelToJSONKeyBlock(keyName);
        return keyName;
    };

    return [[JSONKeyMapper alloc] initWithJSONToModelBlock:toModel
                                          modelToJSONBlock:toJSON];
}


+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"selected"]) {
        return YES;
    }
    return NO;
}

@end
