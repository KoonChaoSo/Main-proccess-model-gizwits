//
//  SURConfiguredDeviceViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 24/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XPGWifiSDK/XPGWifiSDK.h>
#import "AFNetworking.h"

typedef enum{
    searchingDevice,
    unfoundDevice,
    foundDeviceList
}configureViewMode;

@interface GIZBindDeviceListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, XPGWifiDeviceDelegate, XPGWifiSDKDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) NSString* productKey;

@end
