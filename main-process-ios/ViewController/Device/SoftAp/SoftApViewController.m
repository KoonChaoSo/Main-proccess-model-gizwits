//
//  GIZSoft-ApViewController.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by Cmb on 16/9/15.
//  Copyright (c) 2015 ChaoSo. All rights reserved.
//

#import "GIZSoftApViewController.h"
#import "GIZPasswordField.h"
#import "IoTWifiUtil.h"
#import "GIZAlertView.h"
#import "GIZCommonUtils.h"
#import "GIZDevicesListViewController.h"
#import "GIZProcessModel.h"
#import "GIZPropertyUtils.h"
#import "GIZNewDevicesListViewController.h"

// Soft-Ap超时秒数
#define XPG_SOFTAP_TIMEOUT 60
#define XPG_GAGENT  @"XPG-GAgent"

@interface GIZSoftApViewController ()
{
    BOOL isFail;
}
@property (weak, nonatomic) IBOutlet UITextField *textSsid;
@property (weak, nonatomic) IBOutlet GIZPasswordField *textPassword;
@property (weak, nonatomic) IBOutlet UISubSlider *loadingProgress;
@property (weak, nonatomic) IBOutlet UILabel *textStatus;

@property (strong, nonatomic) NSString *ssid;
@property (strong, nonatomic) NSString *wifiPassword;


@end

@implementation GIZSoftApViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.textSsid.text = [GIZProcessModel sharedModel].ssid;
    if(isFail == YES){
        self.navigationItem.title = @"出错提示";
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        self.navigationItem.title = @"手动配置";
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    if (_loadingProgress){
        [_loadingProgress startLoading];
        _loadingProgress.delegate = self;
    }
    
    [XPGWifiSDK sharedInstance].delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.textPassword.text = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [XPGWifiSDK sharedInstance].delegate = nil;
    
    [_loadingProgress stopLoading];
    isFail = NO;
}

- (void)didBecomeActive
{
    if(nil == self.textSsid)
    {
        self.textPassword.text = @"";
    }
}

- (IBAction)onSecondStep:(id)sender {
    
    if(![IoTWifiUtil isSoftAPMode:XPG_GAGENT]){
        NSString *message = [NSString stringWithFormat:@"在设置里找到 Wi-Fi 名前缀为“XPG-GAgent”，并连接此WiFi网络"];
        
        GIZAlertView *alertView = [GIZAlertView UIAlertViewWithTitle:@"提示" message:message uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [alertView setButtonToHideView:GIZAlertViewUperButtonToHide];
        [self.view addSubview:alertView];
        return;
    }else{
        [self performSegueWithIdentifier:@"toSecondStep" sender:self];
    }
}

- (IBAction)onThirdSetp:(id)sender {
    [self performSegueWithIdentifier:@"toThirdStep" sender:self];
}

- (IBAction)onReturnToMain:(id)sender {
    if (self.navigationController.viewControllers.lastObject == self)
    {
        for(UIViewController *controller in self.navigationController.viewControllers)
        {
            if([controller isKindOfClass:[GIZDevicesListViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (nil != self.textSsid && nil != self.textPassword)
    {
        NSString *ssidStr = self.textSsid.text;
        NSString *passwordStr = self.textPassword.text;
        UIViewController *send = segue.destinationViewController;
        
        if([send respondsToSelector:@selector(setSsid:)] && [send respondsToSelector:@selector(setWifiPassword:)])
        {
            [send setValue:ssidStr forKey:@"ssid"];
            [send setValue:passwordStr forKey:@"wifiPassword"];
        }
    }
    if ([segue.identifier isEqualToString:@"toThirdStep"]){
        UIViewController *send = segue.destinationViewController;
        [send.navigationItem setHidesBackButton:YES];
        int timeout = XPG_SOFTAP_TIMEOUT;
        [[XPGWifiSDK sharedInstance] setDeviceWifi:self.textSsid.text key:self.textPassword.text mode:XPGWifiSDKSoftAPMode softAPSSIDPrefix:@"XPG-GAgent" timeout:timeout wifiGAgentType:nil];
    }
    if ([segue.identifier isEqualToString:@"toFailStep"]){
        UIViewController *send = segue.destinationViewController;
        [send.navigationItem setHidesBackButton:YES];
        [send setValue:@YES forKey:@"isFail"];
    }
}

#pragma mark - Delegate
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didSetDeviceWifi:(XPGWifiDevice *)device result:(int)result
{
    [GIZCommonUtils hideLoading];
    
    //    成功配置
    if(result == 0){
        if([device.productKey isEqual:([[[GIZProcessModel sharedModel] appInfo] productKey])])
        {
            [self configureSucceed];
        }
    }
    //    配置失败
    else
    {
        [self performSegueWithIdentifier:@"toFailStep" sender:self];
    }
}

- (void)configureSucceed{
    
    if(self.navigationController.viewControllers.lastObject != self)
    {
        NSLog(@"%s: warning: navigation current state is error, skip.", __func__);
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"配置成功"];
    GIZAlertView *alertView = [GIZAlertView UIAlertViewWithTitle:@"提示" message:message uperButtonTitle:@"知道了" bottomButtonTitles:nil];
    [alertView setButtonToHideView:GIZAlertViewUperButtonToHide];
    [alertView addGestureToUperWithSEL:@selector(popToNewDevicesListViewController) WithTarget:self];
    [self.view addSubview:alertView];
}

-(void)popToNewDevicesListViewController{
    if (self.navigationController.viewControllers.lastObject == self)
    {
        for(UIViewController *controller in self.navigationController.viewControllers)
        {
            if([controller isKindOfClass:[GIZNewDevicesListViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[XPGWifiSDK sharedInstance] userLogout:[GIZProcessModel sharedModel].uid];
    }
}

- (IBAction)onRetry:(id)sender {
    [self performSegueWithIdentifier:@"returnToMainAddDevice" sender:self];
}

-(void) changeTextStatus:(NSInteger)percent{
    if(percent == 25){
        self.textStatus.text = @"...正在使劲力配置中...";
    }
    
    if(percent == 50){
        self.textStatus.text = @"...正在拼尽全力配置中...";
        
    }
    
    if(percent == 75){
        self.textStatus.text = @"...正在拼了老命配置中...";
        
    }
}

@end
