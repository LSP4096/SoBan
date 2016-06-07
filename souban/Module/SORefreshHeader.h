//
//  SORefreshHeader.h
//  souban
//
//  Created by 周国勇 on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>


@interface SORefreshHeader : MJRefreshNormalHeader

@end

@interface UIScrollView (SORefreshHeader)

- (void)setRefreshHeader:(MJRefreshHeader *)header;
- (MJRefreshHeader *)refreshHeader;

@end