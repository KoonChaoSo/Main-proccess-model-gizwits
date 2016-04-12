//
//  SURBaseService.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/23.
//  Copyright (c) 2015年 Sunrain. All rights reserved.
//

#import <XPGWifiSDK/XPGWifiSDK.h>
#import "GIZSDKCommunicateService.h"
#import "GIZUtils.h"
#import "JSONModel.h"
#import "GIZAppInfo.h"
#import "NSString+SURNSString.h"
#import "SURProductDataPointModel.h"
#import "SURWaterHeaterProductDataPointModel.h"

#import "GIZServiceGlobal.h"


#define PHONE_FORMATTER_ERROR @"手机号码格式不正确"
#define PASSWORD_FORMATTER_ERROR @"密码格式不正确"
#define CAPTCHA_FORMATTER_ERROR @"图形验证码不正确"
#define CODE_FORMATTER_ERROR @"验证码不正确"
#define SSID_EMPTY_ERROR @"SSID不能为空"
#define USER_IS_NOT_LOGINED @"用户没有登录"
#define NEW_OLD_PASSWORD_NOT_SAME_LOGINED @"新旧密码不一致"


@interface GIZSDKCommunicateService()<XPGWifiSDKDelegate>
@property (nonatomic,strong) NSArray *propertiesNSArray;
@end

#pragma mark - 用户模块接口
@implementation GIZSDKCommunicateService (UserModule)
/**
 * 登录
 *
 *
 **/
-(BOOL)loginForSDKWithPhone:(NSString *)phone
                   password:(NSString *)password
                 completion:(BlockUser)completion
{
    if (!completion)
    {
        NSLog(@"completion's block is nil");
        return NO;
    }
    
    GIZValidateUtils *utilities	= [GIZValidateUtils sharedUtils];
    
    BOOL isCorrectPhone = [utilities validatePhone:phone];
    BOOL isCorrectPassword = [utilities validateLenghtString:password min:1 max:15];
    
    if (!isCorrectPhone)
    {
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:PHONE_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        
        completion(err);
        return NO;
    }
    
    if (!isCorrectPassword)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:PASSWORD_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];

        completion(err);
        return NO;
    }
    
    [[XPGWifiSDK sharedInstance] userLoginWithUserName:phone password:password];
    SET_BLOCK(kGIZ_KEY_USER_LOGIN, completion);
    return YES;
}

-(void)logoutForSDK
{
    [[XPGWifiSDK sharedInstance] userLogout:_PROCEES_MODEL.uid];
}

-(void)getCaptchaCodeWithCompletion:(BlockGetCapture)completion
{
    SET_BLOCK(kGIZ_KEY_GET_CAPTURE, completion);
    [[XPGWifiSDK sharedInstance] getCaptchaCode:GIZAppSecrect];
    
}

-(BOOL)requestSendPhoneSMSCodeWithCaptchaId:(NSString*)captchaId
                                captchaCode:(NSString*)captchaCode
                                      phone:(NSString*)phone
                                 completion:(BlockNormal)completion
{
    
    BOOL isCorrectPhone = [[GIZValidateUtils sharedUtils] validatePhone:phone];
    BOOL isCorrectCaptchaId = captchaCode.length > 0;
    BOOL isCorrectCaptchaCode = captchaId.length > 0;
    
    if (!isCorrectPhone)
    {
//        NSError *error = [NSError errorWithDomain:@"手机号码格式不正确"
//                                             code:kSURCommonPhoneFormatError
//                                         userInfo:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:PHONE_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    
    if (!isCorrectCaptchaId)
    {
//        NSError *error = [NSError errorWithDomain:@"图形验证码不正确"
//                                             code:kSURCommonCaptchaIdError
//                                         userInfo:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:CAPTCHA_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    
    if (!isCorrectCaptchaCode)
    {
//        NSError *error = [NSError errorWithDomain:GIZSDKDomain
//                                             code:kSURCommonCaptchaCodeError
//                                         userInfo:nil];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:CAPTCHA_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    
    SET_BLOCK(kGIZ_KEY_REQUEST_PHONE_CODE, completion);
    [[XPGWifiSDK sharedInstance] requestSendPhoneSMSCode:_PROCEES_MODEL.sendMsgToken
                                               captchaId:captchaId
                                             captchaCode:captchaCode
                                                   phone:phone];
    return YES;
}

/**
 * 注册
 *
 *
 **/
-(BOOL)registerWithPhone:(NSString *)phone
                password:(NSString *)password
                    code:(NSString *)code
              completion:(BlockUser)completion
{
    
    GIZValidateUtils *utilities	= [GIZValidateUtils sharedUtils];
    BOOL isCorrectPhone = [utilities validatePhone:phone];
    BOOL isCorrectPassword = [utilities validateLenghtString:password min:8 max:15];
    BOOL isCorrectCode     = code.length > 0;
    
    if (!isCorrectPhone)
    {
//        NSError *err = [NSError errorWithDomain:@"手机号码格式不正确" code:kSURCommonPhoneFormatError userInfo:nil];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:PHONE_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    
    if (!isCorrectPassword)
    {
        
//        NSError *err = [NSError errorWithDomain:@"手机号码格式不正确" code:kSURCommonPhoneFormatError userInfo:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:PASSWORD_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    
    if (!isCorrectCode)
    {
//        NSError *err = [NSError errorWithDomain:@"验证码不正确" code:kSURCommonPhoneFormatError userInfo:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:CODE_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    
    SET_BLOCK(kGIZ_KEY_USER_REGISTER, completion);
    [[XPGWifiSDK sharedInstance] registerUserByPhoneAndCode:phone password:password code:code];
    return YES;
}

/**
 * 忘记密码
 *
 *
 **/
-(BOOL)forgetPasswordWithNewPassword:(NSString *)newPassword
                               phone:(NSString *)phone
                                code:(NSString *)code
                          completion:(BlockNormal)completion
{
    
    GIZValidateUtils *utilities	= [GIZValidateUtils sharedUtils];
    BOOL isCorrectPhone = [utilities validatePhone:phone];
    BOOL isCorrectPassword = ([utilities validateLenghtString:newPassword min:8 max:15]);
    
    BOOL isCorrectCode     = code.length > 0;
    if (!isCorrectPhone)
    {
//        NSError *err = [NSError errorWithDomain:@"手机格式不正确" code:kSURCommonPhoneFormatError userInfo:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:PHONE_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    
    if (!isCorrectPassword)
    {
//        NSError *err = [NSError errorWithDomain:@"密码格式不正确" code:kSURCommonPhoneFormatError userInfo:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:PASSWORD_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    
    if (!isCorrectCode)
    {
//        NSError *err = [NSError errorWithDomain:@"验证码不正确" code:kSURCommonCodeFormatError userInfo:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:CODE_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    
    SET_BLOCK(kGIZ_KEY_FORGET_PASSWORD, completion);
    [[XPGWifiSDK sharedInstance] changeUserPasswordByCode:phone
                                                     code:code
                                              newPassword:newPassword];
    return YES;
}

/**
 * 修改密码
 *
 *
 **/
-(BOOL)changePasswordWithOldPassword:(NSString *)oldPassword
                         newPassword:(NSString *)newPassword
                          completion:(BlockNormal)completion
{
    
    GIZValidateUtils *utilities	= [GIZValidateUtils sharedUtils];
    BOOL isCorrectPassword = ([utilities validateLenghtString:newPassword min:8 max:15])
                                ||([utilities validateLenghtString:oldPassword min:8 max:15]);
    
    BOOL isNotSameOldAndNewPassword = ![newPassword isEqualToString:oldPassword];
    
    if (!isCorrectPassword)
    {
//        NSError *error = [NSError errorWithDomain:@""
//                                     code:kSURCommonPasswordFormatError
//                                 userInfo:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:PASSWORD_FORMATTER_ERROR forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    if (isNotSameOldAndNewPassword)
    {
//        NSError *error = [NSError errorWithDomain:GIZSDKDomain
//                                     code:kSURCommonOldAndNewPasswordIsNotSame
//                                 userInfo:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NEW_OLD_PASSWORD_NOT_SAME_LOGINED forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(err);
        return NO;
    }
    
    SET_BLOCK(kGIZ_KEY_CHANGE_PASSWORD, completion);
    [[XPGWifiSDK sharedInstance] changeUserPassword:_PROCEES_MODEL.token
                                        oldPassword:oldPassword
                                        newPassword:newPassword];
    return YES;
    
}
@end


@implementation GIZSDKCommunicateService (Device)


//Airlink配置
-(void)configureAirLink:(NSString *)ssid
                    key:(NSString *)key
                timeout:(int)timeout
             completion:(BlockSetDevice)completion
{
    if (0 == ssid.length)
    {
//        NSError *error = [NSError errorWithDomain:@"SSID不能为空"
//                                             code:kSURCommonSSIDEmpty
//                                         userInfo:nil];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:SSID_EMPTY_ERROR forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        
        completion (nil,err,nil);
        return;
    }
    
    SET_BLOCK(kGIZ_KEY_SET_AIRLINK, completion);
    [[XPGWifiSDK sharedInstance] setDeviceWifi:ssid
                                           key:key
                                          mode:XPGWifiSDKAirLinkMode
                              softAPSSIDPrefix:nil
                                       timeout:60
                                wifiGAgentType:@[@(XPGWifiGAgentTypeMXCHIP),@(XPGWifiGAgentTypeHF)]];
}

//配置SoftAp
-(void)configureSoftAp:(NSString *)ssid
                   key:(NSString *)key
               timeout:(int)timeout
             completion:(BlockSetDevice)completion
{
    if (0 == ssid.length)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:SSID_EMPTY_ERROR forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion (nil,err,nil);
        return;
    }
    
    SET_BLOCK(kGIZ_KEY_SET_SOFTAP, completion);
    [[XPGWifiSDK sharedInstance] setDeviceWifi:ssid
                                           key:key
                                          mode:XPGWifiSDKSoftAPMode
                              softAPSSIDPrefix:@"XPG-GAgent"
                                       timeout:60
                                wifiGAgentType:nil];

}


///**
// *  配对
// *
// *
// **/
//- (BOOL)setDeviceWifiForSDK:(NSString *)ssid
//                        key:(NSString *)key
//                       mode:(XPGConfigureMode)mode
//           softAPSSIDPrefix:(NSString *)prefix
//                    timeout:(int)timeout
//             wifiGAgentType:(NSArray *)type
//                      error:(NSError **)error
//{
//    
//    if(!error)
//    {
//        NSError *err;
//        *error = err;
//    }
//    *error = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonErrorNone userInfo:nil];
//    
//    if (0 == ssid.length)
//    {
//        *error = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonSSIDEmpty userInfo:nil];
//        return NO;
//    }
//    
//    [[XPGWifiSDK sharedInstance] setDeviceWifi:ssid key:key mode:mode softAPSSIDPrefix:prefix timeout:timeout wifiGAgentType:type];
//    return YES;
//}

- (void)stopDiscovery
{
    BlockDiscovery disBlock = [self.blocks valueForKey:kGIZ_KEY_DISCOVERY_DEVICE];
    if (disBlock)
    {
        REMOVE_BLOCK(kGIZ_KEY_DISCOVERY_DEVICE);
        disBlock = nil;
    }
}

/**
 * 获取绑定列表
 *
 *
 **/
- (BOOL)getBoundDeviceListWithProductKey:(NSString *)specialProductKey
                              completion:(BlockDiscovery)completion
{
    //判断mode空或者没有设置delegate
    if(nil == _PROCEES_MODEL || nil == [XPGWifiSDK sharedInstance].delegate){
        NSLog(@"%s,model 为空指针或者没有设置delegate",__FUNCTION__);
        NSError *error = [NSError errorWithDomain:@"model为空指针或者没有设置delegate"
                                             code:kSURCommonNormalError
                                         userInfo:nil];
        completion(@[],error,nil);
        return NO;
    }
    //判断用户没有登录的时候
    if(!_PROCEES_MODEL.isLogined)
    {
        NSLog(@"%s,没有登录",__FUNCTION__);
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:USER_IS_NOT_LOGINED forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(@[],err,nil);
        return NO;
    }
    
    //请求SDK
    SET_BLOCK(kGIZ_KEY_DISCOVERY_DEVICE,completion);
    [[XPGWifiSDK sharedInstance] getBoundDevicesWithUid:_PROCEES_MODEL.currentUid token:_PROCEES_MODEL.currentToken specialProductKeys:specialProductKey,nil];
    return YES;
}

/**
 * 获取绑定列表2
 *
 *
 **/
- (BOOL)getBoundDeviceListWithProductKey:(NSString *)specialProductKey1
                              productKey:(NSString *)specialProductKey2
                              completion:(BlockDiscovery)completion
{
    
    //判断mode空或者没有设置delegate
    if(nil == _PROCEES_MODEL || nil == [XPGWifiSDK sharedInstance].delegate){
        NSLog(@"%s,model 为空指针或者没有设置delegate",__FUNCTION__);
        NSError *error = [NSError errorWithDomain:@"model为空指针或者没有设置delegate"
                                             code:kSURCommonNormalError
                                         userInfo:nil];
        completion(@[],error,nil);
        return NO;
    }

    //判断用户没有登录的时候
    if(!_PROCEES_MODEL.isLogined)
    {
        NSLog(@"%s,没有登录",__FUNCTION__);
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:USER_IS_NOT_LOGINED forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(@[],err,nil);
        return NO;
    }
    
    //请求SDK
    SET_BLOCK(kGIZ_KEY_DISCOVERY_DEVICE,completion);
    [[XPGWifiSDK sharedInstance] getBoundDevicesWithUid:_PROCEES_MODEL.currentUid token:_PROCEES_MODEL.currentToken specialProductKeys:specialProductKey1,specialProductKey2,nil];
    return YES;
}

- (void)getBoundDeviceListWithProductkeyList:(NSArray *)productkeys
                                  completion:(BlockDiscovery)completion
{
    //判断mode空或者没有设置delegate
    if(nil == _PROCEES_MODEL || nil == [XPGWifiSDK sharedInstance].delegate){
        NSLog(@"%s,model 为空指针或者没有设置delegate",__FUNCTION__);
        NSError *error = [NSError errorWithDomain:@"model为空指针或者没有设置delegate"
                                             code:kSURCommonNormalError
                                         userInfo:nil];
        completion(@[],error,nil);
        return;
    }
    
    //判断用户没有登录的时候
    if(!_PROCEES_MODEL.isLogined)
    {
        NSLog(@"%s,没有登录",__FUNCTION__);
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:USER_IS_NOT_LOGINED forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(@[],err,nil);
        return;
    }
    
    //请求SDK
    SET_BLOCK(kGIZ_KEY_DISCOVERY_DEVICE,completion);
    [[XPGWifiSDK sharedInstance] getBoundDevices:_PROCEES_MODEL.uid token:_PROCEES_MODEL.token specialProductKeys:productkeys];
}

/**
 * 绑定设备
 *
 *
 **/
- (BOOL)bindDeviceForSDKWithDid:(NSString *)did
                       passcode:(NSString *)passcode
                         remark:(NSString *)remark
                     completion:(BlockBindDevice)completion
{
    //判断mode空或者没有设置delegate
    if(nil == _PROCEES_MODEL || nil == [XPGWifiSDK sharedInstance].delegate){
        NSLog(@"%s,model 为空指针或者没有设置delegate",__FUNCTION__);
        NSError *error = [NSError errorWithDomain:@"model为空指针或者没有设置delegate"
                                             code:kSURCommonNormalError
                                         userInfo:nil];
        completion(@"",error);
        return NO;
    }
    //判断用户没有登录的时候
    if(!_PROCEES_MODEL.isLogined)
    {
        NSLog(@"%s,没有登录",__FUNCTION__);
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:USER_IS_NOT_LOGINED forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(@"",err);
        return NO;
    }

    SET_BLOCK(kGIZ_KEY_BIND_DEVICE, completion);
    [[XPGWifiSDK sharedInstance] bindDeviceWithUid:_PROCEES_MODEL.uid token:_PROCEES_MODEL.token did:did passCode:passcode remark:remark];
    return YES;
}

/**
 * 解除绑定设备
 *
 *
 **/
- (BOOL)unbindDeviceForSDKWithDid:(NSString *)did
                         passcode:(NSString *)passcode
                       completion:(BlockBindDevice)completion
{
    //判断mode空或者没有设置delegate
    if(nil == _PROCEES_MODEL || nil == [XPGWifiSDK sharedInstance].delegate){
        NSLog(@"%s,model 为空指针或者没有设置delegate",__FUNCTION__);
        NSError *error = [NSError errorWithDomain:@"model为空指针或者没有设置delegate"
                                             code:kSURCommonNormalError
                                         userInfo:nil];
        completion(@"",error);
        return NO;
    }
    //判断用户没有登录的时候
    if(!_PROCEES_MODEL.isLogined)
    {
        NSLog(@"%s,没有登录",__FUNCTION__);
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:USER_IS_NOT_LOGINED forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:GIZSDKDomain code:kSURCommonPhoneFormatError userInfo:userInfo];
        completion(@"",err);
        return NO;
    }

    SET_BLOCK(kGIZ_KEY_UNBIND_DEVICE, completion);
    [[XPGWifiSDK sharedInstance] unbindDeviceWithUid:_PROCEES_MODEL.uid token:_PROCEES_MODEL.token did:did passCode:passcode];
    return YES;
}
@end

@implementation GIZSDKCommunicateService (Control)

-(BOOL)sendToControlWithEntity0:(NSDictionary *)entity
                         target:(id)target
                         device:(XPGWifiDevice *)device
{
    device.delegate = target;
    NSDictionary *data = nil;
    
    data = @{DATA_CMD: @(DeviceCommandWrite),
             DATA_ENTITY: entity};
    
    if(data == nil){
        NSLog(@"the data is nil");
        return NO;
    }
    NSLog(@"Write data: %@", data);
    [device write:data];
    return YES;
}

-(BOOL)getDeviceStatus:(XPGWifiDevice *)device
                target:(id)target
{
    device.delegate = target;
    NSDictionary *data = nil;
    
    data = @{DATA_CMD: @(DeviceCommandRead)};
    [self sendToControlWithEntity0:data target:target device:device];
    return YES;
}

#pragma mark - Private methods
-(BOOL)readDataPoint:(NSDictionary *)allData
          productKey:(NSString *)productKey
          completion:(readDataPointBlock)block{
    
    if(![allData isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read data, error data format.");
        return NO;
    }
    
    if(![[allData objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read data, error data format.");
        return NO;
    }
    
    NSDictionary *data = [allData objectForKey:@"data"];
    
    if(![data isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read data, error data format.");
        return NO;
    }
    
    NSNumber *nCommand = [allData valueForKey:DATA_CMD];
    if(![nCommand isKindOfClass:[NSNumber class]])
    {
        NSLog(@"Error: could not read cmd, error cmd format.");
        return NO;
    }
    
    int nCmd = [nCommand intValue];
    if(nCmd != DeviceCommandResponse && nCmd != DeviceCommandNotify)
    {
        NSLog(@"Error: command is invalid, skip.");
        return NO;
    }
    
    NSDictionary *attributes = [allData valueForKey:DATA_ENTITY];
    if(![attributes isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read attributes, error attributes format.");
        return NO;
    }
    
    NSArray *alerts = [allData valueForKey:DATA_ALERTS];
    if(![alerts isKindOfClass:[NSArray class]])
    {
        NSLog(@"Error: could not read alerts, error alerts format.");
        return NO;
    }
    
    NSArray *faults = [allData valueForKey:DATA_FAULTS];
    if(![faults isKindOfClass:[NSArray class]])
    {
        NSLog(@"Error: could not read faults, error faults format.");
        return NO;
    }
    
    __block id dataModel = nil;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefault objectForKey:MODEL_NAME];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([productKey isEqualToString:obj])
        {
            dataModel = [[NSClassFromString((NSString *)key) alloc] initWithDictionary:attributes error:nil];
        }
    }];
    
    if (dataModel) {
        block(dataModel,alerts,faults);
    }
    return YES;
}
@end

@implementation GIZSDKCommunicateService
@synthesize blocks = _blocks;


+(instancetype)sharedInstance
{
    static GIZSDKCommunicateService* service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[GIZSDKCommunicateService alloc] init];
        service.blocks = [@{} mutableCopy];
        [XPGWifiSDK sharedInstance].delegate = service;
    });
    return service;
}


-(void)dealloc
{
    [XPGWifiSDK sharedInstance].delegate = nil;
}

#pragma mark XPGWifiDelegate
//机智云登录
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUserLogin:(NSNumber *)error errorMessage:(NSString *)errorMessage uid:(NSString *)uid token:(NSString *)token
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
    NSError *err = [NSError errorWithDomain:GIZSDKDomain code:[error integerValue] userInfo:userInfo];
    BlockUser loginBlock = [self.blocks valueForKey:kGIZ_KEY_USER_LOGIN];
    if (loginBlock)
    {
        if (error.integerValue == 0)
        {
            _PROCEES_MODEL.uid = uid;
            _PROCEES_MODEL.token = token;
        }
        loginBlock(err);
        REMOVE_BLOCK(kGIZ_KEY_USER_LOGIN);
        loginBlock = nil;
    }
    else
    {
        NSLog(@"%s,Block is nill",__FUNCTION__);
    }
}

//机智云注册
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didRegisterUser:(NSNumber *)error errorMessage:(NSString *)errorMessage uid:(NSString *)uid token:(NSString *)token
{
    NSError *err = [NSError errorWithDomain:errorMessage code:[error integerValue] userInfo:nil];
    BlockUser registerBlock = [self.blocks valueForKey:kGIZ_KEY_USER_REGISTER];
    if (registerBlock)
    {
        if (error.integerValue == 0)
        {
            _PROCEES_MODEL.uid = uid;
            _PROCEES_MODEL.token = token;
        }
        registerBlock(err);
        REMOVE_BLOCK(kGIZ_KEY_USER_REGISTER);
        registerBlock = nil;
    }
    else
    {
        NSLog(@"%s,block is nill",__FUNCTION__);
    }
}

//机智云忘记密码
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didChangeUserPhone:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    NSError *err = [NSError errorWithDomain:errorMessage code:[error integerValue] userInfo:nil];
    BlockNormal changeBlock = [self.blocks valueForKey:kGIZ_KEY_USER_FORGET];
    if (changeBlock)
    {
        changeBlock(err);
        REMOVE_BLOCK(kGIZ_KEY_FORGET_PASSWORD);
        changeBlock = nil;
    }
    else
    {
        NSLog(@"%s,block is nill",__FUNCTION__);
    }
}

//机智云获取图形验证码
-(void)wifiSDK:(XPGWifiSDK *)wifiSDK didGetCaptchaCode:(NSError *)result token:(NSString *)token captchaId:(NSString *)captchaId captchaURL:(NSString *)captchaURL
{
    BlockGetCapture getCapture = [self.blocks valueForKey:kGIZ_KEY_GET_CAPTURE];
    
    if (getCapture)
    {
        getCapture(token,captchaId,captchaURL,result);
        REMOVE_BLOCK(kGIZ_KEY_GET_CAPTURE);
        getCapture = nil;
    }
    else
    {
        NSLog(@"%s,block is nill",__FUNCTION__);
    }
}

//机智云获取手机验证码
-(void)wifiSDK:(XPGWifiSDK *)wifiSDK didRequestSendPhoneSMSCode:(NSError *)result
{
    BlockNormal getCapture = [self.blocks valueForKey:kGIZ_KEY_REQUEST_PHONE_CODE];
    
    if (getCapture)
    {
        getCapture(result);
        REMOVE_BLOCK(kGIZ_KEY_REQUEST_PHONE_CODE);
        getCapture = nil;
    }
    else
    {
        NSLog(@"%s,block is nill",__FUNCTION__);
        return;
    }
}

//机智云修改密码
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didChangeUserPassword:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    NSError *err = [NSError errorWithDomain:errorMessage code:[error integerValue] userInfo:nil];
    BlockNormal changeBlock = [self.blocks valueForKey:kGIZ_KEY_FORGET_PASSWORD];
    if (changeBlock)
    {
        changeBlock(err);
        REMOVE_BLOCK(kGIZ_KEY_FORGET_PASSWORD);
        changeBlock = nil;
    }
    else
    {
        NSLog(@"%s,block is nill",__FUNCTION__);
    }
}

//机智云配置设备回调
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didSetDeviceWifi:(XPGWifiDevice *)device result:(int)result
{
    BlockSetDevice setAirLinkBlock = [self.blocks valueForKey:kGIZ_KEY_SET_AIRLINK];
    BlockSetDevice setSoftApBlock = [self.blocks valueForKey:kGIZ_KEY_SET_SOFTAP];
    
    if (!setAirLinkBlock && !setSoftApBlock)
        NSLog(@"%s,block is nill",__FUNCTION__);
    
    BOOL *stop = nil;
    if (setAirLinkBlock)
    {
        
        NSError *err = [NSError errorWithDomain:@"" code:result userInfo:nil];
        setAirLinkBlock(device,err,&stop);
        if (result != 0)
        {
            REMOVE_BLOCK(kGIZ_KEY_SET_AIRLINK);
        }
        setAirLinkBlock = nil;
    }
    if (setSoftApBlock)
    {
        NSError *err = [NSError errorWithDomain:@"" code:result userInfo:nil];
        setSoftApBlock(device,err,&stop);
        if (result != 0)
        {
            REMOVE_BLOCK(kGIZ_KEY_SET_SOFTAP);
        }
        setSoftApBlock = nil;
    }
    
    if (stop != NULL && stop)
    {
        REMOVE_BLOCK(kGIZ_KEY_SET_AIRLINK);
        REMOVE_BLOCK(kGIZ_KEY_SET_SOFTAP);
    }
    

    
    
}

//机智云发现设备回调
-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didDiscovered:(NSArray *)deviceList result:(int)result
{
    NSError *err = [NSError errorWithDomain:@"" code:result userInfo:nil];
    BlockDiscovery disBlock = [self.blocks valueForKey:kGIZ_KEY_DISCOVERY_DEVICE];
    BOOL *stop = nil;
    if (disBlock)
    {
        disBlock(deviceList,err,&stop);
        disBlock = nil;
    }
    else
    {
        NSLog(@"%s,block is nill",__FUNCTION__);
    }
    
    if (stop != NULL && stop)
    {
        REMOVE_BLOCK(kGIZ_KEY_DISCOVERY_DEVICE);
    }
}

-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didBindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    NSError *err = [NSError errorWithDomain:errorMessage code:[error intValue] userInfo:nil];
    BlockBindDevice bindBlock = [self.blocks valueForKey:kGIZ_KEY_BIND_DEVICE];
    
    if (bindBlock)
    {
        bindBlock (did,err);
        REMOVE_BLOCK(kGIZ_KEY_BIND_DEVICE);
        bindBlock = nil;
    }
    else
    {
        NSLog(@"%s,block is nill",__FUNCTION__);
    }
}

-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUnbindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    NSError *err = [NSError errorWithDomain:errorMessage code:[error intValue] userInfo:nil];
    BlockBindDevice bindBlock = [self.blocks valueForKey:kGIZ_KEY_UNBIND_DEVICE];
    
    if (bindBlock)
    {
        bindBlock (did,err);
        REMOVE_BLOCK(kGIZ_KEY_UNBIND_DEVICE);
        bindBlock = nil;
    }
    else
    {
        NSLog(@"%s,block is nill",__FUNCTION__);
    }
}

- (void)XPGWifiDevice:(XPGWifiDevice *)device didReceiveData:(NSDictionary *)data result:(int)result
{
    if (![self.delegate respondsToSelector:@selector(gizCommunicateDeviceStatus:didReceiveModel:alerts:faults:error:)])
    {
        NSLog(@"%s,delegate is nill",__FUNCTION__);
        return ;
    }
    
    [self readDataPoint:data productKey:device.productKey completion:^(id model, NSArray *alerts, NSArray *faults) {
        NSError *error = [NSError errorWithDomain:@"" code:result userInfo:nil];
        [self.delegate gizCommunicateDeviceStatus:device didReceiveModel:model alerts:alerts faults:faults error:error];
    }];
}
@end