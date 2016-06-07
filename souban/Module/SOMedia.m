//
//  SOMedia.m
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOMedia.h"


@implementation SOMedia

+ (instancetype)mediaWithImageURL:(NSString *)urlString
{
    SOMedia *media = [SOMedia new];
    media.url = urlString;
    media.type = SOMediaTypeImage;
    return media;
}
+ (NSMutableArray *)imagesToMedias:(NSArray *)images
{
    NSMutableArray *medias = [NSMutableArray new];
    for (NSString *imageUrl in images) {
        [medias addObject:[SOMedia mediaWithImageURL:imageUrl]];
    }
    return medias;
}
@end
