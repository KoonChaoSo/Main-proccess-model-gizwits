//
//  SURSoftApViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 26/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURSoftApViewController.h"
#import "SURAlertView.h"
#import "SURAppInfo.h"
#import "GizSDKCommunicateService.h"
#import "AFNetworking.h"

@interface SURSoftApViewController ()<XPGWifiSDKDelegate>
{
    NSTimer *counterTimer;
}

@property (weak, nonatomic) IBOutlet UITextField *wifiNameText;
@property (weak, nonatomic) IBOutlet UITextField *wifiPasswordText;
@property (weak, nonatomic) IBOutlet UISwitch *showPasswordSwitch;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *stepFrameView;

@property (strong, nonatomic) NSString *ssid;
@property (strong, nonatomic) NSString *wifiPassword;
@property (assign, nonatomic) NSInteger timeout;
@property (assign, nonatomic) BOOL isLoadingView;

@property (strong, nonatomic) GizSDKCommunicateService *service;
@end

@implementation SURSoftApViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [XPGWifiSDK sharedInstance].delegate = self;
    if(self.isLoadingView == YES){
        self.timeout = XPG_AIRLINK_TIMEOUT;
        [self startLoading];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XPGWifiSDK sharedInstance].delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.service = [[SURCommonService alloc] init];
}

#pragma mark - 下一步按钮响应
- (IBAction)nextStepButtonAction:(id)sender {
    /*注意：下一步将进入配置响应事件*/
    
    // 判断
    //    if(!self.wifiNameText.text){
    //
    //    }
    self.ssid         = self.wifiNameText.text;
    self.wifiPassword = self.wifiPasswordText.text;
    
    [self checkNetwokStatus];
    
    NSError *error;
    [self.service setDeviceWifiForSDK:self.ssid key:self.wifiPassword mode:XPGWifiSDKSoftAPMode softAPSSIDPrefix:XPG_GAGENT timeout:60 wifiGAgentType:nil error:&error];
    
}

#pragma mar - 配置成功跳转按钮响应
- (IBAction)successButtonAction:(id)sender {
    
    
}
- (IBAction)passwordSwitchShow:(id)sender {
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController *send = segue.destinationViewController;
    if([send respondsToSelector:@selector(setSsid:)] && [send respondsToSelector:@selector(setWifiPassword:)] && [send respondsToSelector:@selector(setIsLoadingView:)])
    {
        [send setValue:self.ssid forKey:@"ssid"];
        [send setValue:self.wifiPassword forKey:@"wifiPassword"];
        if([segue.identifier isEqualToString:@"toSoftApThirdStep"]){
            [send setValue:@YES forKey:@"isLoadingView"];
                #warning 发送SoftAp请求
            
        }
    }
}


#pragma mark - 开始计时
- (void)startLoading{
    counterTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeValue) userInfo:nil repeats:YES];
}

#pragma mark - 修改timeout的值，并显示出来
-(void)changeValue{
    self.timeout --;
    if(self.timeout < 0){
        [self releaseTimer];
        [self performSegueWithIdentifier:@"toSoftApFailStep" sender:self];
        return;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%ld",(long)self.timeout];
}

#pragma mark - 释放Timber
-(void)releaseTimer{
    [counterTimer invalidate];
    if(counterTimer){
        counterTimer = nil;
    }
}

#pragma mark - delegate

- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didSetDeviceWifi:(XPGWifiDevice *)device result:(int)result
{
    //    成功配置
    if(result == 0){
        if([device.productKey isEqualToString:SURWaterHeaterProductKey] || [device.productKey isEqualToString:SURWaterPurifierProductKey])
        {
            [self configureSucceed];
        }
    }
    //    配置失败
    else
    {
        [self performSegueWithIdentifier:@"toAirLinkFailStep" sender:self];
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
        SURAlertView *alertView = [SURAlertView UIAlertViewWithTitle:@"提示" message:message uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [alertView setButtonToHideView:AlertViewUperButtonToHide];
        //        [alertView addGestureToUperWithSEL:@selector(popToNewDevicesListViewController) WithTarget:self];
        [self.view addSubview:alertView];
    }
}

#pragma mark - 检查网络
- (void)checkNetwokStatus
{
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            [self performSegueWithIdentifier:@"toSoftApThirdStep" sender:self];
            break;
        }
        case AFNetworkReachabilityStatusNotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络是否正确连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:
            break;
    }
}

@end
