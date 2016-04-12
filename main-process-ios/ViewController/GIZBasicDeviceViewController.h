//
//  GIZSuperTestaaa.h
//  main-process-ios
//
//  Created by ChaoSo on 16/2/24.
//  Copyright © 2016年 gitzwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIZBasicFlowViewController.h"
#import "GIZSDKCommunicateService.h"

@interface GIZBasicDeviceViewController : UIViewController<GIZSDKCommunicateDelegate,XPGWifiDeviceDelegate>
@property (strong, nonatomic) XPGWifiDevice *device;
@property (strong, nonatomic) GIZSDKCommunicateService *sdkService;
@end
