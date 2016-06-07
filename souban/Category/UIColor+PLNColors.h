//
//  UIColor+PLNColors.h
//
//  Generated by Zeplin on 12/29/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PLNColors)

+ (UIColor *)pln_slate60Color;
+ (UIColor *)pln_slateColor;
+ (UIColor *)pln_grapefruitColor;
+ (UIColor *)pln_blueyGreyColor;
+ (UIColor *)pln_whiteColor;
+ (UIColor *)pln_blackColor;
+ (UIColor *)pln_slateGreyColor;
+ (UIColor *)pln_slateGrey_60A_Color;
+ (UIColor *)pln_warmGreyColor;
+ (UIColor *)pln_cloudyBlueColor;
+ (UIColor *)pln_charcoalGreyColor;
+ (UIColor *)pln_silverColor;
+ (UIColor *)pln_darkColor;
+ (UIColor *)pln_ceruleanColor;
+ (UIColor *)pln_lightblueColor;
+ (UIColor *)pln_mediumBlueColor;
+ (UIColor *)pln_dodgerBlueColor;
+ (UIColor *)pln_coolGreyColor;
+ (UIColor *)pln_deepSkyBlue80Color;
+ (UIColor *)pln_deepSkyBlueColor;
+ (UIColor *)pln_purpleyGreyColor;

// Color
#define SSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define SSColorA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define SSGlobalBg [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]
#define SSGrayColor(v) SSColor(v ,v ,v)
#define SSRandomColor SSColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@end