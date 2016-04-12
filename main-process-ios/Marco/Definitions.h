//
//  IoTDefinitions.h
//  WiFiDemo
//
//  Created by xpg on 14-6-5.
//  Copyright (c) 2014年 Xtreme Programming Group, Inc. All rights reserved.
//

#ifndef SUR_Definitions_h
#define SUR_Definitions_h

#import "AppDelegate.h"
#import "GIZProcessModel.h"
/**
 * @brief debug mode
 */
//#if DEBUG
//#define _TEST_MODE          1
//#else
//#define _TEST_MODE          0
//#endif

//#define LAN_MODE        1
#ifdef __cplusplus
#define GIZDEFINE_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define GIZDEFINE_EXTERN extern __attribute__((visibility ("default")))
#endif
#define GIZDEFINE_STATIC_INLINE static inline

#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define NSLS(x) NSLocalizedString(x, nil)
#define _PROCEES_MODEL ((GIZProcessModel *)[GIZProcessModel sharedModel])

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define isPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define sysVer [[[UIDevice currentDevice] systemVersion] floatValue]

#define RACDispose(x) [x dispose];x = nil;

#define StepFrameModel [SURStepFrameModel sharedModel]

#define XPG_AIRLINK_TIMEOUT 60;
#define XPG_SOFTAP_TIMEOUT  60;
#define XPG_BIND_TIMEOUT    5;

#define SUNRAIN_BLUE RGB(18,112,175)
#define SUNRAIN_OCEAN_BLUE RGB(20,213,253)
#define SUNRAIN_GRAY RGB(178,178,178)
#define SUNRAIN_ORANGE RGB(253,91,8)

#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define XPG_GAGENT  @"XPG-GAgent"

#define SUR_NOTIFICATION_DISCONNECT @"disconnectDevice"
static inline BOOL isEqualNibName(NSString *name)
{
    BOOL isDictionary = NO;
    NSString *appPath = [[NSBundle mainBundle] pathForResource:name ofType:@"nib"];
    if(!appPath)
        return NO;
    return ([[NSFileManager defaultManager] fileExistsAtPath:appPath isDirectory:&isDictionary] && isDictionary);
}

static inline NSString *nibName(NSString *name)
{
    if(isPhone5)
    {
        NSString *name568h = [name stringByAppendingString:@"-568h"];
        if(isEqualNibName(name568h))
            return name568h;
    }
#if 0
    if(isPad)
    {
        NSString *namePad = [name stringByAppendingString:@"-Pad"];
        if(isEqualNibName(namePad))
            return namePad;
    }
#endif
    return name;
}

#endif
