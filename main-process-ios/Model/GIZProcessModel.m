//
//  GIZProcessViewModel.m
//  Gizwits-HeatingApparatu
//
//  Created by ChaoSo on 15/7/22.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//  
//
#import <XPGWifiSDK/XPGWifiSDK.h>
#import "GIZProcessModel.h"
//#import "SURPropertyUtils.h"
#import "SURUserInfoModel.h"

#define DefaultSetValue(key, value) \
[[NSUserDefaults standardUserDefaults] setValue:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];

#define DefaultGetValue(key) \
[[NSUserDefaults standardUserDefaults] valueForKey:key];

#define IoTConfigKey(x) \
[NSString stringWithFormat:@"SURConfig%@", x]

#define IOT_CONFIG_USERNAME         IoTConfigKey(@"UserName")
#define IOT_CONFIG_PASSWORD         IoTConfigKey(@"Password")
#define IOT_CONFIG_UID              IoTConfigKey(@"Uid")
#define IOT_CONFIG_TOKEN            IoTConfigKey(@"Token")
#define IOT_CONFIG_ACCOUNTYPE       IoTConfigKey(@"AccountType")
#define IOT_CONFIG_SSID             IoTConfigKey(@"Ssid")
#define IOT_CONFIG_ISNEW            IoTConfigKey(@"isNew")



@implementation GIZProcessModel

+ (GIZProcessModel *)sharedModel
{
    static dispatch_once_t onceToken;
    static GIZProcessModel *sharedModel = nil;
    dispatch_once(&onceToken, ^{
        if(nil == sharedModel)
        {
            sharedModel = [[GIZProcessModel alloc] init];
        }
    });
    return sharedModel;
}

- (void)setUsername:(NSString *)username
{
    DefaultSetValue(IOT_CONFIG_USERNAME, username);
}

- (void)setPassword:(NSString *)password
{
    DefaultSetValue(IOT_CONFIG_PASSWORD, password);
}

- (NSString *)username
{
    return DefaultGetValue(IOT_CONFIG_USERNAME)
}

- (NSString *)password
{
    return DefaultGetValue(IOT_CONFIG_PASSWORD)
}

- (void)setUid:(NSString *)uid
{
    DefaultSetValue(IOT_CONFIG_UID, uid)
}

- (void)setAccountType:(SURAccountType)accountType
{
    DefaultSetValue(IOT_CONFIG_ACCOUNTYPE, @(accountType))
}

- (void)setToken:(NSString *)token
{
    DefaultSetValue(IOT_CONFIG_TOKEN, token)
}
- (void)setSsid:(NSString *)token
{
    DefaultSetValue(IOT_CONFIG_SSID, token)
}

- (NSString *)uid
{
    return DefaultGetValue(IOT_CONFIG_UID)
}

- (NSString *)token
{
    return DefaultGetValue(IOT_CONFIG_TOKEN)
}
- (NSString *)ssid
{
    return DefaultGetValue(IOT_CONFIG_SSID)
}

- (NSString *)currentUser
{
    return self.username;
}

- (NSString *)currentUid
{
    return self.uid;
}

- (NSString *)currentToken
{
    return self.token;
}

-(void)setCustomTemp:(NSInteger)temp
{
    DefaultSetValue(@"custom_temp",@(temp));
}

-(NSInteger)customTemp
{
    NSNumber *cTemp = DefaultGetValue(@"custom_temp");
    return [cTemp integerValue];
}

-(void)setIsNew:(BOOL)isNew
{
    DefaultSetValue(@"isNew",@(isNew));
}

-(BOOL)isNew
{
    id isNew = DefaultGetValue(@"isNew");
    return [isNew boolValue];
}

-(NSString *)description
{
    //在这里写model里面的属性
    return [NSString stringWithFormat:@"<%@: %p>username:%@ password:%@ uid:%@",[self class],[self class],self.username,self.password,self.uid];
}

//判断是否
- (BOOL)isLogined
{
    return (self.uid.length > 0 && self.token.length > 0);
}
-(void)setIsLogined:(BOOL)isLogined
{
    if (!isLogined)
    {
        self.uid = nil;
        self.token = nil;
    }
}
@end
