//
//  NSError+ErrorMessage.h
//  BailkalTravel
//
//  Created by 周国勇 on 7/28/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSError (ErrorMessage)

- (NSString *)errorMessage;

- (BOOL)hudMessage;
@end
