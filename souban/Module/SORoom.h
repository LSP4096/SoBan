//
//  SORoom.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"

@protocol SORoom <NSObject>

@end


@interface SORoom : OMBaseModel

@property (nonatomic) BOOL booked;
@property (nonatomic) BOOL collected;
@property (strong, nonatomic) NSNumber *areaSize;
@property (strong, nonatomic) NSArray<Optional> *images;
@property (strong, nonatomic) NSNumber<Optional> *price;
@property (strong, nonatomic) NSString *priceUnit;
@property (nonatomic) NSString<Optional> *fitment;
@property (nonatomic) BOOL filterTarget; // 是否匹配筛选条件
@property (strong, nonatomic) NSString<Optional> *roomDescription;
@property (nonatomic, getter=isExpand) BOOL expand;

@end
