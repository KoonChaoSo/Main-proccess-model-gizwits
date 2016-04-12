//
//  GIZBaseViewController.h
//  main-process-ios
//
//  Created by ChaoSo on 16/1/5.
//  Copyright © 2016年 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIZSDKCommunicateService.h"

@interface GIZBasicFlowViewController : UIViewController
@property (strong, nonatomic) NSString *ssid;
@property (strong, nonatomic) NSString *wifiPassword;
@property (strong, nonatomic) GIZSDKCommunicateService *sdkService;
@property (strong, nonatomic) XPGWifiDevice *selectedDeivce;


- (void)pushToMainVC:(BOOL)isNeedToLogin;
- (void)pushToControl:(XPGWifiDevice *)selectedDevice;
@end
