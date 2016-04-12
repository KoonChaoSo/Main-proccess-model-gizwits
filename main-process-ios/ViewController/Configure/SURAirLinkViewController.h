//
//  SURAirLinkViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 26/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XPGWifiSDK/XPGWifiSDK.h>

@interface SURAirLinkViewController : UIViewController<XPGWifiSDKDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSString *ssid;
@property (strong, nonatomic) NSString *wifiPassword;

@end
