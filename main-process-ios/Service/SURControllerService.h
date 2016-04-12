//
//  IGIZControllerService.h
//  Gizwits-HeatingApparatu
//
//  Created by ChaoSo on 15/7/23.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XPGWifiSDK/XPGWifiSDK.h>
#import "SURProductDataPointModel.h"

typedef void(^readDataPointBlock)(SURProductDataPointModel *model,NSArray *alerts,NSArray *faults);
@protocol SURControllerService <NSObject>

@optional
//TODO send
-(void)sendToControlWithEntity0:(NSDictionary *)entity ToDevice:(XPGWifiDevice *)device;

-(void)getDeviceStatus:(XPGWifiDevice *)device;

//TODO read(block)
-(void)readDataPoint:(NSDictionary *)data completion:(readDataPointBlock)block;

//TODO 定时预约

//TODO 超时处理

//TODO 自定义模式


@end
