//
//  GIZModifyPasswordViewController.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/8/4.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//
#import <XPGWifiSDK/XPGWifiSDK.h>

#import "SURPasswordManagerViewController.h"
#import "SURPasswordField.h"
#import "SURUtils.h"
#import "SURAlertView.h"
#import "GizSDKCommunicateService.h"
#import "UIAlertView+SURUIAlertView.h"


static GizSDKCommunicateService *passwordManager_service = nil;
@interface SURPasswordManagerViewController ()<XPGWifiSDKDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet SURPasswordField *textOldPassword;
@property (weak, nonatomic) IBOutlet SURPasswordField *textNewPassword;

@end

@implementation SURPasswordManagerViewController



- (IBAction)onModifyConfirm:(id)sender {
    
    [self.textOldPassword resignFirstResponder];
    [self.textNewPassword resignFirstResponder];
    
    [SURCommonUtils showLoadingWithTile:@"修改密码中，请稍候..."];
    NSError *error;
    [passwordManager_service changePasswordForSDKWithOldPassword:self.textOldPassword.text newPassword:self.textNewPassword.text error:&error];
    if (kSURCommonOldAndNewPasswordIsNotSame == error.code)
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"新旧密码不能相同" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        [SURCommonUtils hideLoading];
        return;
    }
    else if(kSURCommonPasswordFormatError == error.code)
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写8~15位密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        [SURCommonUtils hideLoading];
        return;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"密码管理";
    self.navigationController.navigationBarHidden = NO;
    
    passwordManager_service = [[GizSDKCommunicateService alloc] init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [XPGWifiSDK sharedInstance].delegate = self;
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [XPGWifiSDK sharedInstance].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didChangeUserPassword:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    [SURCommonUtils hideLoading];
    if([error intValue])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"修改密码失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    else
    {
        NSString *message = [NSString stringWithFormat:@"修改密码成功"];
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] showAfterTimeInterval:1.f];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@NO afterDelay:1.5f];
//        
//        SURAlertView *alertView = [SURAlertView UIAlertViewWithTitle:@"提示" message:message uperButtonTitle:@"知道了" bottomButtonTitles:nil];
//        [alertView setButtonToHideView:AlertViewUperButtonToHide];
//        [alertView addGestureToUperWithSEL:@selector(back) WithTarget:self];
//        [self.view addSubview:alertView];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
//        [[XPGWifiSDK sharedInstance] userLogout:[GIZProcessModel sharedModel].uid];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

- (IBAction)passwordSwitchShow:(id)sender {
    UISwitch *switch_button = (UISwitch *)sender;
    self.textNewPassword.secureTextEntry = !switch_button.on;
    self.textOldPassword.secureTextEntry = !switch_button.on;
}



@end
