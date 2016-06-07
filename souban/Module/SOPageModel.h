//
//  SOPageModel.h
//  souban
//
//  Created by 周国勇 on 11/20/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

static NSInteger const kPageSize = 10;


@interface SOPageModel : JSONModel

@property (strong, nonatomic) NSNumber *limit;
@property (strong, nonatomic) NSNumber *currentCount;
@property (strong, nonatomic) NSNumber *lastObjectId;

+ (instancetype)pageWithObjects:(NSArray *)objects limit:(NSInteger)limit;

+ (instancetype)pageWithLimit:(NSInteger)limit currentCount:(NSInteger)currentCount lastObjectId:(NSNumber *)lastObject;

+ (instancetype)pageWithLimit:(NSInteger)limit;

- (instancetype)initWithLimit:(NSInteger)limit currentCount:(NSInteger)currentCount lastObjectId:(NSNumber *)lastObject;

@end
