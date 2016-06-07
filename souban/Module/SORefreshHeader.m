//
//  SORefreshHeader.m
//  souban
//
//  Created by 周国勇 on 10/27/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SORefreshHeader.h"


@implementation SORefreshHeader

@end

@implementation UIScrollView (SORefreshHeader)

- (void)setRefreshHeader:(MJRefreshHeader *)header {
    self.mj_header = header;
}

- (MJRefreshHeader *)refreshHeader {
    return self.mj_header;
}

@end