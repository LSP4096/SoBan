// Author: Oleg Andreev <oleganza@gmail.com>
// May 28, 2011
// Do What The Fuck You Want Public License <http://www.wtfpl.net>

#import <Foundation/Foundation.h>


@interface NSData (UTF8)

- (NSString *)UTF8String;
- (NSData *)dataByHealingUTF8Stream;
@end
