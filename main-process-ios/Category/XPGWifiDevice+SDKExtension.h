//
//  XPGWifiDevice+SDKExtension.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/12/4.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <XPGWifiSDK/XPGWifiSDK.h>
#define DATA_CMD                        @"cmd"                  //命令
#define DATA_ENTITY                     @"entity0"              //实体
#define DATA_ALERTS                     @"alerts"              //警告
#define DATA_FAULTS                     @"faults"              //错误

#define SET_BLOCK(KEY,VALUE) [self.blocks setObject:VALUE forKey:KEY];
#define REMOVE_BLOCK(KEY)    [self.blocks removeObjectForKey:KEY];

typedef void (^BlockLoginDevice)(XPGWifiDevice *device, NSError *err);
@interface XPGWifiDevice (SDKExtension) <XPGWifiDeviceDelegate ,XPGWifiDeviceDelegate>

/**
 *  设备发送数据给M2M
 *
 *  @param data   数据点的dictionary
 *  @param target 需要设置delegate的类
 */
- (void)giz_write:(NSDictionary *)data target:(id)target;

/**
 *  获取设备状态
 *
 *  @param target 需要设置delegate的类
 */
-(void)giz_getDeviceStatus:(id)target;



-(void)giz_loginDeviceWithCompletion:(BlockLoginDevice)completion;

@end
