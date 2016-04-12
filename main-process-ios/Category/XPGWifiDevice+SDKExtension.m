//
//  XPGWifiDevice+SDKExtension.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/12/4.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "XPGWifiDevice+SDKExtension.h"
#import "GIZAppInfo.h"
#import "GIZServiceGlobal.h"
#import "GIZSDKCommunicateService.h"

@implementation XPGWifiDevice (SDKExtension)
- (void)giz_write:(NSDictionary *)data target:(id)target
{
    if(data == nil){
        NSLog(@"The Data is Nil");
        return;
    }
    self.delegate = target;
    data = @{DATA_CMD: @(DeviceCommandWrite),
             DATA_ENTITY: data};
    NSLog(@"Write data: %@", data);
    [self write:data];
}

-(void)giz_getDeviceStatus:(id)target
{
    self.delegate = self;
    NSDictionary *data = nil;
    data = @{DATA_CMD: @(DeviceCommandRead)};
    [self write:data];
}

-(void)giz_loginDeviceWithCompletion:(BlockLoginDevice)completion
{
    self.delegate = self;
    [[GIZSDKCommunicateService sharedInstance].blocks setObject:completion forKey:kGIZ_KEY_LOGIN_DEVICE];
    [self login:_PROCEES_MODEL.currentUid token:_PROCEES_MODEL.token];
}


- (void)XPGWifiDevice:(XPGWifiDevice *)device didLogin:(int)result{

    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"" forKey:NSLocalizedDescriptionKey];
    NSError *err = [NSError errorWithDomain:GIZSDKDomain code:result userInfo:userInfo];
    BlockLoginDevice setLoginDevice = [[GIZSDKCommunicateService sharedInstance].blocks valueForKey:kGIZ_KEY_LOGIN_DEVICE];
    
    if (setLoginDevice)
    {
        setLoginDevice(device,err);
        [[GIZSDKCommunicateService sharedInstance].blocks removeObjectForKey:kGIZ_KEY_LOGIN_DEVICE];
        setLoginDevice = nil;
    }
    else
    {
        NSLog(@"%s,block is nill",__FUNCTION__);
    }
    
}

- (void)XPGWifiDevice:(XPGWifiDevice *)device didReceiveData:(NSDictionary *)data result:(int)result
{
    [[GIZSDKCommunicateService sharedInstance] readDataPoint:data productKey:self.productKey completion:^(id model, NSArray *alerts, NSArray *faults) {
        
        
    }];
}


@end
