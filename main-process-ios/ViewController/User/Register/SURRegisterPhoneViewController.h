//
//  SURRegisterPhoneViewController.h
//  SUROpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/7/30.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XPGWifiSDK/XPGWifiSDK.h>
#import "SURPasswordField.h"

@interface SURRegisterPhoneViewController : UIViewController<XPGWifiSDKDelegate>

@property (weak, nonatomic) IBOutlet SURPasswordField *textPhone;
@property (weak, nonatomic) IBOutlet SURPasswordField *textPassword;
@property (weak, nonatomic) IBOutlet UITextField *textVerifyNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnVerifyCode;
@property (weak, nonatomic) IBOutlet UIImageView *verifyCodeInAlertViewImageView;

- (void)countDownTimer;
@end
