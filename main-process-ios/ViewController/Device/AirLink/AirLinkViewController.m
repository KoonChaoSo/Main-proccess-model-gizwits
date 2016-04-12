//
//  GIZAir-LinkViewController.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by Cmb on 15/9/15.
//  Copyright (c) 2015 ChaoSo. All rights reserved.
//

#import "GIZAirLinkViewController.h"
#import "GIZPasswordField.h"
#import "IoTWifiUtil.h"
#import "GIZAlertView.h"
#import "GIZCommonUtils.h"
#import "GIZDevicesListViewController.h"
#import "GIZSoftApViewController.h"
#import "GIZProcessModel.h"
#import "GIZPropertyUtils.h"
#import "GIZNewDevicesListViewController.h"

// Air-Link超时秒数
#define XPG_AIRLINK_TIMEOUT 60

@interface GIZAirLinkViewController ()
{
    BOOL isFail;
}
@property (weak, nonatomic) IBOutlet UITextField *txtSsid;
@property (weak, nonatomic) IBOutlet GIZPasswordField *txtPassword;
@property (weak, nonatomic) IBOutlet UISubSlider *loadingProgress;
@property (weak, nonatomic) IBOutlet UILabel *txtStatus;

@property (strong, nonatomic) NSString *ssid;
@property (strong, nonatomic) NSString *wifiPassword;


@end

@implementation GIZAirLinkViewController

@synthesize ssid;
@synthesize wifiPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    if(isFail == YES){
        self.navigationItem.title = @"出错提示";
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        self.navigationItem.title = @"配置新设备";
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    [self didBecomeActive];
    [self.txtPassword becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        if (_loadingProgress){
            [_loadingProgress startLoading];
            _loadingProgress.delegate = self;
        }
    
    [XPGWifiSDK sharedInstance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.txtPassword.text = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [XPGWifiSDK sharedInstance].delegate = nil;
    
    [_loadingProgress stopLoading];
    isFail = NO;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didBecomeActive
{
    self.txtSsid.text = [[IoTWifiUtil SSIDInfo] valueForKey:@"SSID"];
    if(nil == self.txtSsid)
    {
        self.txtPassword.text = @"";
    }
}

- (void)configureSucceed{
    
    if(self.navigationController.viewControllers.lastObject != self)
    {
        NSLog(@"%s: warning: navigation current state is error, skip.", __func__);
        return;
    }
    if (self.navigationController.viewControllers.lastObject == self)
    {
        NSString *message = [NSString stringWithFormat:@"配置成功"];
        GIZAlertView *alertView = [GIZAlertView UIAlertViewWithTitle:@"提示" message:message uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [alertView setButtonToHideView:GIZAlertViewUperButtonToHide];
        [alertView addGestureToUperWithSEL:@selector(popToNewDevicesListViewController) WithTarget:self];
        [self.view addSubview:alertView];
    }
}

- (IBAction)onFirstStepNext:(id)sender {
    if(self.txtSsid.text.length <= 0){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请保持 Wi-Fi 连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    [self performSegueWithIdentifier:@"toSecondStep" sender:self];
}

- (IBAction)onSecondStepNext:(id)sender {
    [self performSegueWithIdentifier:@"toThirdStep" sender:self];
}

- (IBAction)onRetry:(id)sender {
    [self performSegueWithIdentifier:@"returnToMainAddDevice" sender:self];
}

- (IBAction)onSoftAP:(id)sender {
    if(self.navigationController.viewControllers.lastObject == self){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"GIZSoftAp" bundle:nil];
        UIViewController *addDeviceVC = [storyBoard instantiateViewControllerWithIdentifier:@"GIZSoftApAddDevice"];
        [self.navigationController pushViewController:addDeviceVC animated:YES];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (nil != self.txtSsid && nil != self.txtPassword)
    {
        NSString *ssidStr = self.txtSsid.text;
        NSString *passwordStr = self.txtPassword.text;
        UIViewController *send = segue.destinationViewController;
        
        [GIZProcessModel sharedModel].ssid = self.txtSsid.text;
        
        if([send respondsToSelector:@selector(setSsid:)] && [send respondsToSelector:@selector(setWifiPassword:)])
        {
            [send setValue:ssidStr forKey:@"ssid"];
            [send setValue:passwordStr forKey:@"wifiPassword"];
        }
    }
    if ([segue.identifier isEqualToString:@"toThirdStep"]){
        
        UIViewController *send = segue.destinationViewController;
        [send.navigationItem setHidesBackButton:YES];
        int timeout = XPG_AIRLINK_TIMEOUT;
        [[XPGWifiSDK sharedInstance] setDeviceWifi:self.ssid key:self.wifiPassword mode:XPGWifiSDKAirLinkMode softAPSSIDPrefix:nil timeout:timeout wifiGAgentType:nil];
    }
    if ([segue.identifier isEqualToString:@"toFailStep"]){
        UIViewController *send = segue.destinationViewController;
        [send.navigationItem setHidesBackButton:YES];
        [send setValue:@YES forKey:@"isFail"];
    }
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

#pragma mark - Delegate
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didSetDeviceWifi:(XPGWifiDevice *)device result:(int)result{
    [GIZCommonUtils hideLoading];
    [_loadingProgress stopLoading];
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

-(void) changeTextStatus:(NSInteger)percent{
    if(percent == 25){
        self.txtStatus.text = @"...正在使劲力配置中...";
    }
    
    if(percent == 50){
        self.txtStatus.text = @"...正在拼尽全力配置中...";
        
    }
    
    if(percent == 75){
        self.txtStatus.text = @"...正在拼了老命配置中...";
        
    }
}

@end
