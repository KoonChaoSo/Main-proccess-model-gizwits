//
//  SURBaseControlViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/28.
//  Copyright © 2015年 Sunrain. All rights reserved.
//


#import "SURBaseControlViewController.h"
#import "GIZAppInfo.h"
#import "SURUtils.h"
//#import "SURMainViewController.h"

@interface SURBaseControlViewController ()<XPGWifiSDKDelegate , XPGWifiDeviceDelegate>


@end



@implementation SURBaseControlViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //设备已解除绑定，或者断开连接，退出
    if(![self.selectedDevice isBind:_PROCEES_MODEL.currentUid] || !self.selectedDevice.isConnected)
    {
//        [self onDisconnected];
        return;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [XPGWifiSDK sharedInstance].delegate = self;
    self.serviceForSDK = [[GIZSDKCommunicateService alloc] init];
    //在页面加载后，自动更新数据
    if(self.selectedDevice.isOnline)
    {
        [SURCommonUtils showLoadingWithTile:@"正在更新数据..."];
        NSError *error;
//        [self.serviceForSDK getDeviceStatus:self.selectedDevice target:self error:&error];
    }
    else
    {
        [self onDisconnected];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeivceLogin) name:@"deviceLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveToDeviceList) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisconnected) name:UIAccessibilityAnnouncementDidFinishNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [XPGWifiSDK sharedInstance].delegate = nil;
//    self.serviceForSDK = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIAccessibilityAnnouncementDidFinishNotification object:nil];
}


-(void)XPGWifiDeviceDidDisconnected:(XPGWifiDevice *)device result:(int)result
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SUR_NOTIFICATION_DISCONNECT object:device.did];
}

- (void)onDisconnected {
    //断线且页面在控制页面时才弹框
    UIViewController *currentController = self.navigationController.viewControllers.lastObject;
    //TODO 退出到devicelIST
    if(!self.selectedDevice.isConnected &&
       [currentController isKindOfClass:[SURBaseControlViewController class]])
    {
        for (UIViewController *viewController in self.navigationController.viewControllers)
        {
//            if ([viewController isKindOfClass:[SURMainViewController class]])
//            {
//                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"设备已断线" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//                [self.navigationController popToViewController:viewController animated:YES];
//            }
            
        }
    }
}


- (void)onDeivceLogin{
    [self.selectedDevice login:_PROCEES_MODEL.currentUid
                         token:_PROCEES_MODEL.currentToken];
}


#pragma mark - Properties
- (void)setSelectedDevice:(XPGWifiDevice *)selectedDevice
{
    _selectedDevice.delegate = nil;
    _selectedDevice = selectedDevice;
    _selectedDevice.delegate = self;
}

-(void)didBecomeActiveToDeviceList
{
    [SURCommonUtils showLoading];
    
    //如果进入主页按home键，则自动退出
    BOOL isMainCtrl = NO;
//    SURMainViewController *deviceListCtrl = nil;
//    for(UIViewController *controller in self.navigationController.viewControllers)
//    {
//        if([controller isKindOfClass:[SURMainViewController class]])
//            deviceListCtrl = (SURMainViewController *)controller;
//        
//        if([controller isKindOfClass:[SURBaseControlViewController class]])
//        {
//            isMainCtrl = YES;
//            break;
//        }
//    }
//    if(isMainCtrl)
//    {
////        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"设备已断线" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//        if (deviceListCtrl)
//            [self.navigationController popToViewController:deviceListCtrl animated:YES];
//        else
//            [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *viewController = segue.destinationViewController;
    if ([viewController isKindOfClass:[SURBaseControlViewController class]])
    {
        ((SURBaseControlViewController *) viewController).selectedDevice = self.selectedDevice;
    }
}

-(void)XPGWifiDevice:(XPGWifiDevice *)device didReceiveData:(NSDictionary *)data result:(int)result
{
//    [[GizSDKCommunicateService sharedService] readDataPoint:data completion:^(id model, NSArray *alerts, NSArray *faults) {
//        self.productDataModel = model;
//    }];
}


@end
