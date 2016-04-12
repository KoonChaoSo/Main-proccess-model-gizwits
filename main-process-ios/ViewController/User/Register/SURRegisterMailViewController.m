//
//  SURRegisterMailViewController.m
//  SUROpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/8/4.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "SURRegisterMailViewController.h"
#import "SURValidateUtils.h"
#import "UIView+SURUIViewExtension.h"
#import "SURAlertView.h"
#import "SURRegisterPhoneViewController.h"
#import "SURProcessModel.h"
#import "SURCommonUtils.h"

@interface SURRegisterMailViewController ()<XPGWifiSDKDelegate>{
    NSArray *tempDeviceList;
}

@end

@implementation SURRegisterMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"注册";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBackButton_backBarbuttonItem)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [XPGWifiSDK sharedInstance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XPGWifiSDK sharedInstance].delegate = nil;
}

#pragma mark - Action
- (void)myCustomBackButton_backBarbuttonItem
{
    if(self.navigationController.viewControllers.lastObject == self)
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPhoneRegister:(id)sender {
    if(self.navigationController.viewControllers.lastObject == self){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onConfirm:(id)sender {
    if(![[SURValidateUtils sharedUtils] validateEmail:self.labelEmail.text]){
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"请填写正确的Email" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:warningView];
        return;
    }
    if(self.labelPassword.text.length == 0){
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"请填写密码" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [self.view addSubview:warningView];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        return;
    }
    if (self.labelPassword.text.length < 6 || self.labelPassword.text.length > 16) {
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"密码长度要求介于 6-16 之间" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [self.view addSubview:warningView];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        return;
    }
    if(![[SURValidateUtils sharedUtils] validatePassword:self.labelPassword.text])
    {
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"密码只能是数字、大小写或特殊字符" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [self.view addSubview:warningView];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        return;
    }
    
    [self.labelEmail resignFirstResponder];
    [self.labelPassword resignFirstResponder];
    
    [SURCommonUtils showLoadingWithTile:@"正在注册..."];
    
    [[XPGWifiSDK sharedInstance] registerUserByEmail:self.labelEmail.text password:self.labelPassword.text];
}

-(void)closeView:(UIGestureRecognizer *)recognizer{
    [recognizer.view.superview removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.labelEmail)
        [textField resignFirstResponder];
    
    if(textField == self.labelPassword)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - XPGWifiSDK delegate
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didRegisterUser:(NSNumber *)error errorMessage:(NSString *)errorMessage uid:(NSString *)uid token:(NSString *)token
{
    int errorValue = [error intValue];
    if(errorValue)
    {
        NSString *message = errorMessage;
        switch (errorValue) {
            case 9022:
                message = @"用户已注册，请勿重复注册";
                break;
            default:
                break;
        }
        [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else{
        [SURProcessModel sharedModel].uid = uid;
        [SURProcessModel sharedModel].token = token;
        [SURProcessModel sharedModel].username = self.labelEmail.text;
        [SURProcessModel sharedModel].password = self.labelPassword.text;
        [SURProcessModel sharedModel].accountType = AccountTypeDefault;
        
        //注册成功后，搜索设备，5秒后进 设备列表
        [SURCommonUtils showLoadingWithTile:@"搜索设备中..."];
        
//        [[XPGWifiSDK sharedInstance] getBoundDevicesWithUid:[SURProcessModel sharedModel].uid token:[SURProcessModel sharedModel].token specialProductKeys:[SURProcessModel sharedModel].appInfo.productKey, nil];
        
        [self performSelector:@selector(onAddDevice) withObject:nil afterDelay:5];
        
        return;
    }
    [SURCommonUtils hideLoading];
}

- (void)onAddDevice
{
    //添加未绑定的设备到列表
    NSMutableArray *devices = [NSMutableArray array];
    for(XPGWifiDevice *device in tempDeviceList)
    {
        if(device.isLAN && ![device isBind:[SURProcessModel sharedModel].uid])
            [devices addObject:device];
    }
    [SURCommonUtils hideLoading];
    
    //    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"SURAddDeviceFlowStoryboard" bundle:nil];
    //    SURAddDeviceViewController *addDeviceViewCtrl = [secondStroyBoard instantiateViewControllerWithIdentifier:@"SURAddDevice"];
    //    [self.navigationController pushViewController:addDeviceViewCtrl animated:YES];
    
//    SURDevicesListViewController *deviceListViewCtrl = [[SURDevicesListViewController alloc]initWithNibName:@"SURDevicesListViewController" bundle:nil];
//    [self.navigationController pushViewController:deviceListViewCtrl animated:YES];
}

@end
