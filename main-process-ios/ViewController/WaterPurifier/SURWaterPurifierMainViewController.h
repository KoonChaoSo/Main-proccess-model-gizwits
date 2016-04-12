//
//  SURWaterPurifierMainViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 30/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURBaseControlViewController.h"
#import <XPGWifiSDK/XPGWifiSDK.h>
#import "SURBaseControlViewController.h"
#import "SURErrorView.h"

typedef enum {
    regular,
    irregular,
}waterPurifierModel;


@interface SURWaterPurifierMainViewController : SURBaseControlViewController<XPGWifiSDKDelegate, XPGWifiDeviceDelegate, UIAlertViewDelegate,SURErrorViewDelegate>


@end
