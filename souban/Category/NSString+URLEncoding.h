//
//  NSString+URLEncoding.h
//  HBToolkit
//
//  Created by Limboy on 12/25/13.
//  Copyright (c) 2013 Huaban. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (URLEncoding)

/** Encoding suitable for use in URLs.
 
 stringByAddingPercentEscapes does not replace serveral characters which are problematics in URLs.
 
 @return The encoded version of the receiver.
 */
- (NSString *)stringByURLEncoding;

- (NSString *)stringByURLDecoding;

- (NSString *)urlencode;
@end
