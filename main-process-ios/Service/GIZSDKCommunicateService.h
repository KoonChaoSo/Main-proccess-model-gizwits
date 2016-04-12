//
//  SURBaseService.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/23.
//  Copyright (c) 2015年 Sunrain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SURProductDataPointModel.h"

#define DATA_CMD                        @"cmd"                  //命令
#define DATA_ENTITY                     @"entity0"              //实体
#define DATA_ALERTS                     @"alerts"              //警告
#define DATA_FAULTS                     @"faults"              //错误

#define SET_BLOCK(KEY,VALUE) [self.blocks setObject:VALUE forKey:KEY];
#define REMOVE_BLOCK(KEY)    [self.blocks removeObjectForKey:KEY];

typedef void (^BlockNormal)(NSError *err);
typedef void (^BlockUser)(NSError *err);
typedef void (^BlockGetCapture)(NSString *token,NSString *captchaId ,NSString *captchaURL ,NSError *err);
typedef void (^BlockSetDevice)(XPGWifiDevice *device,NSError *err,BOOL **stop);
typedef void (^BlockDiscovery)(NSArray *deviceList,NSError *err,BOOL **stop);
typedef void (^BlockBindDevice)(NSString *did,NSError *err);
typedef void (^BlockDeviceStatus)(id model,NSError *err);
typedef void (^readDataPointBlock)(id model,NSArray *alerts,NSArray *faults);


@protocol GIZSDKCommunicateDelegate <NSObject>
-(void)gizCommunicateDeviceStatus:(XPGWifiDevice *)device didReceiveModel:(id)model alerts:(NSArray *)alerts faults:(NSArray *)faults error:(NSError *)error;


@end

@interface GIZSDKCommunicateService : NSObject
@property (assign , nonatomic) id<GIZSDKCommunicateDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *blocks;



+(instancetype)sharedInstance;
@end

/**
 *  用户模块的sdk 逻辑
 */
@interface GIZSDKCommunicateService (UserModule)

-(BOOL)loginForSDKWithPhone:(NSString *)phone
                   password:(NSString *)password
                 completion:(BlockUser)completion;

-(void)logoutForSDK;

-(BOOL)registerWithPhone:(NSString *)phone
                password:(NSString *)password
                    code:(NSString *)code
              completion:(BlockUser)completion;

-(BOOL)forgetPasswordWithNewPassword:(NSString *)newPassword
                               phone:(NSString *)phone
                                code:(NSString *)code
                          completion:(BlockNormal)completion;

-(BOOL)requestSendPhoneSMSCodeWithCaptchaId:(NSString*)captchaId
                                captchaCode:(NSString*)captchaCode
                                      phone:(NSString*)phone
                                 completion:(BlockNormal)completion;

-(BOOL)changePasswordWithOldPassword:(NSString *)oldPassword
                         newPassword:(NSString *)newPassword
                          completion:(BlockNormal)completion;

-(void)getCaptchaCodeWithCompletion:(BlockGetCapture)completion;

@end

/**
 *  设备模块的sdk逻辑
 */
@interface GIZSDKCommunicateService (Device)

-(void)configureAirLink:(NSString *)ssid
                    key:(NSString *)key
                timeout:(int)timeout
             completion:(BlockSetDevice)completion;

-(void)configureSoftAp:(NSString *)ssid
                   key:(NSString *)key
               timeout:(int)timeout
            completion:(BlockSetDevice)completion;


- (BOOL)getBoundDeviceListWithProductKey:(NSString *)specialProductKey
                              completion:(BlockDiscovery)completion DEPRECATED_ATTRIBUTE;

- (BOOL)getBoundDeviceListWithProductKey:(NSString *)specialProductKey1
                              productKey:(NSString *)specialProductKey2
                              completion:(BlockDiscovery)completion DEPRECATED_ATTRIBUTE;

- (void)getBoundDeviceListWithProductkeyList:(NSArray *)productkeys
                                  completion:(BlockDiscovery)completion;

- (void)stopDiscovery;

- (BOOL)bindDeviceForSDKWithDid:(NSString *)did
                       passcode:(NSString *)passcode
                         remark:(NSString *)remark
                     completion:(BlockBindDevice)completion;

- (BOOL)unbindDeviceForSDKWithDid:(NSString *)did
                         passcode:(NSString *)passcode
                       completion:(BlockBindDevice)completion;

@end

/**
 *  控制模块的sdk逻辑
 */
@interface GIZSDKCommunicateService (Control)

/**
 *  发送命令接口（已废弃）
 *
 *  @param entity entity description
 *  @param target target description
 *  @param device device description
 *
 *  @return return value description
 */
-(BOOL)sendToControlWithEntity0:(NSDictionary *)entity
                         target:(id)target
                         device:(XPGWifiDevice *)device DEPRECATED_ATTRIBUTE;

/**
 *  查询设备接口（已废弃）
 *
 *  @param device device description
 *  @param target target description
 *
 *  @return return value description
 */
-(BOOL)getDeviceStatus:(XPGWifiDevice *)device
                target:(id)target;


-(BOOL)readDataPoint:(NSDictionary *)allData
          productKey:(NSString *)productKey
          completion:(readDataPointBlock)block;


@end

