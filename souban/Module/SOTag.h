//
//  SOTag.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "OMBaseModel.h"

@protocol SOTag <NSObject>

@end


@interface SOTag : OMBaseModel

@property (strong, nonatomic) NSString *name;

@end

@protocol SOTagContainer <NSObject>

@end


@interface SOTagContainer : SOTag

@property (strong, nonatomic) NSArray<SOTag, Optional> *subTags;

@end
