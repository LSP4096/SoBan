//
//  SOArea.h
//  souban
//
//  Created by 周国勇 on 10/29/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOTag.h"

@protocol SOArea <NSObject>

@end


@interface SOArea : SOTag

@property (strong, nonatomic) NSMutableArray<SOTag> *blocks;

@end
