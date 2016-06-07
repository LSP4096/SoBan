//
//  SOFilingDetail.h
//  souban
//
//  Created by 周国勇 on 12/29/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOFiling.h"


@interface SOFilingDetail : SOFiling

@property (nonatomic) long long createTime;
@property (nonatomic) long long dealTime;
@property (nonatomic) long long followUpTime;
@property (nonatomic) long long lookTime;
@property (nonatomic) long long payTime;
@property (strong, nonatomic) NSString *phoneNum;

@end
