//
//  NSString+UUID.m
//  HBToolkit
//
//  Created by Limboy on 12/25/13.
//  Copyright (c) 2013 Huaban. All rights reserved.
//

#import "NSString+UUID.h"


@implementation NSString (UUID)

+ (NSString *)stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil); //create a new UUID

    //get the string representation of the UUID
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);

    CFRelease(uuidObj);
    return uuidString;
}

@end
