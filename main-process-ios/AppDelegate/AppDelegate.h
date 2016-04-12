//
//  AppDelegate.h
//  sunrainapp_ios
//
//  Created by Cmb on 22/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XPGWifiSDK/XPGWifiSDK.h>
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navCtrl;

- (MBProgressHUD *)hud;

@end

