//
//  SOBuildingScreenModel.h
//  souban
//
//  Created by 周国勇 on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface SOBuildingScreenModel : JSONModel

@property (strong, nonatomic) NSNumber *areaId;
@property (strong, nonatomic) NSNumber *blockId;
@property (strong, nonatomic) NSNumber *cityId;
@property (strong, nonatomic) NSNumber *maxArea;
@property (strong, nonatomic) NSNumber *minArea;
@property (strong, nonatomic) NSNumber *maxPrice;
@property (strong, nonatomic) NSNumber *minPrice;
@property (strong, nonatomic) NSMutableArray<Ignore> *tagIds;

- (NSDictionary *)dictionaryValue;

@end


@interface NSMutableArray (Unique)

- (void)addUniqueId:(NSNumber *)number;
- (void)removeUniqueId:(NSNumber *)number;

@end
