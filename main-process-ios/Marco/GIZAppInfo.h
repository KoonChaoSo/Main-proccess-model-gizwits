//
//  SURAppInfo.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/23.
//  Copyright (c) 2015年 Sunrain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIZAppInfo : NSObject

/**
 * SURCommonErrorCode枚举，描述了SDK提供的所有错误码定义。
 */
typedef NS_ENUM(NSInteger, SURCommonErrorCode)
{
    /**
     * 无错误
     */
    kSURCommonErrorNone                      = 0,
    
    /**
     * 手机格式错误
     */
    kSURCommonPhoneFormatError               = 101,
    
    /**
     * 验证码格式错误
     */
    kSURCommonCodeFormatError               = 102,
    
    /**
     * 密码格式有误
     */
    kSURCommonPasswordFormatError           = 103,
    
    /**
     * 新旧密码不相同
     */
    kSURCommonOldAndNewPasswordIsNotSame       = 104,
    
    /**
     * 图片验证码格式错误
     */
    kSURCommonCaptchaCodeError               = 105,
    
    /**
     * 图片验证码id 格式错误
     */
    kSURCommonCaptchaIdError                = 106,
    
    //app没有登录
    kSURCommonIsNotLogined                  = 107,
    
    //ssid为空
    kSURCommonSSIDEmpty                   = 108,
    
    //通常异常
    kSURCommonNormalError                   = 199,
    
    
};

typedef NS_ENUM(NSInteger, SUROSVersion){
    
    //iPhone4S
    UIDeviceiPhone4sOS = 0,
    //iPhone5
    UIDeviceiPhone5OS,
    //iPhone6
    UIDeviceiPhone6OS,
    //unknow
    UIDeviceUnknowOS
    
};

typedef NS_ENUM(NSInteger, SURDeviceCommand)
{
    DeviceCommandWrite    = 1,//写
    
    DeviceCommandRead     = 2,//读
    
    DeviceCommandResponse = 3,//读响应
    
    DeviceCommandNotify   = 4,//通知
};

typedef NS_ENUM(NSInteger, SURProductorType)
{
    SURWaterPurifier = 0,
    SURWaterHeater = 1,
    SURNoneType = 3,
};


GIZDEFINE_EXTERN NSString *const GIZSDKDomain;

/*!
 @abstract The error domain for all errors from SURAppInfo.
 @discussion 机智云appid
 */
GIZDEFINE_EXTERN NSString *const GIZAppId;

/*!
 @abstract The error domain for all errors from SURAppInfo.
 @discussion 机智云productkey
 */
GIZDEFINE_EXTERN NSString *const GIZWaterPurifierProductKey;
GIZDEFINE_EXTERN NSString *const GIZWaterHeaterProductKey;

/*!
 @abstract The error domain for all errors from SURAppInfo.
 @discussion 机智云appsecrect
 */
GIZDEFINE_EXTERN NSString *const GIZAppSecrect;




GIZDEFINE_EXTERN NSString *const GIZDeviceCustomIdentifier;

GIZDEFINE_EXTERN NSString *const GIZDeviceAirLinkSettingSuccessfulIdentifier;

GIZDEFINE_EXTERN NSString *const GIZDeviceSoftApSettingSuccessfulIdentifier;







@end
