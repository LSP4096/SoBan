//
//  kCommonMacro.h
//  OfficeManager
//
//  Created by 周国勇 on 8/20/15.
//  Copyright (c) 2015 whalefin. All rights reserved.
//
#import <DDLog.h>
#import <Cocoalumberjack.h>
#import <DDLegacy.h>

//#ifndef OfficeManager_kCommonMacro_h
//#define OfficeManager_kCommonMacro_h

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelAll;
#else
static const DDLogLevel ddLogLevel = LOG_LEVEL_OFF;
#endif

static NSString *const kWXAppId = @"wx9a3c3eb7972394a8";
static NSString *const kWXAppSecret = @"ef0ef559235c509f865cee19e0d66353";
static NSString *const kUMengAppKey = @"556ec03a67e58e53d7004f80";

static NSString *const kBPushApiKey = @"Zp5lUfGhG9W3aW0GeCe0lblB";
static NSString *const kOMPayScheme = @"officemanagerpay";
static NSString *const kOMUniversalScheme = @"souban";

static NSString *const kInstaBugKey = @"48215e3c71bde650f4858b04f009d931";
static NSString *const kFirApiKey = @"93fe440b0c2371550f57b088ce04a6da";
static NSString *const kBGHudKey = @"fa3e458b0363d16fbb5f01227ceda1f7";
static NSString *const kUMengKey = @"56555e8c67e58e596800037e";
#ifdef DEBUG
static NSString *const kMapKey = @"a4c496a604e469726780c4868706635a";

#elif RELEASE
static NSString *const kMapKey = @"f9995a3e280ebc5c6fbfa2135f8b0156";

#elif DISTRIBUTION
static NSString *const kMapKey = @"eef81d36675e3210cc8a4455fa0e2afa";

#endif
