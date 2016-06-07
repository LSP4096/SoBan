//
//  SOMedia.h
//  souban
//
//  Created by 周国勇 on 10/26/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import <JSONModel.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SOMediaType) {
    SOMediaTypeImage,
    SOMediaTypeImageAudio
};


@interface SOMedia : NSObject

@property (strong, nonatomic) NSString *url;
@property (nonatomic) SOMediaType type;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

+ (instancetype)mediaWithImageURL:(NSString *)urlString;

+ (NSMutableArray *)imagesToMedias:(NSArray *)images;
@end
