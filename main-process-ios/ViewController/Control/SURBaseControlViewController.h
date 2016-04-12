//
//  SURBaseControlViewController.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/28.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XPGWifiSDK/XPGWifiSDK.h>
#import "GIZSDKCommunicateService.h"

@protocol SURBaseControlDelegate <NSObject>

@end

@interface SURBaseControlViewController : UIViewController

@property (strong, nonatomic) XPGWifiDevice *selectedDevice;
@property (strong, nonatomic) GIZSDKCommunicateService *serviceForSDK;

@property (strong, nonatomic) NSArray *faults;
@property (strong, nonatomic) NSArray *alerts;

@property (strong, nonatomic) SURProductDataPointModel *productDataModel;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (void)onDisconnected;


@end
