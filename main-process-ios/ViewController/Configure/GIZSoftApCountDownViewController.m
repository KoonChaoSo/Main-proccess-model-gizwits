//
//  SURSendSoftApViewController.m
//  micoeapp_ios
//
//  Created by ChaoSo on 15/10/26.
//  Copyright © 2015年 gizwits. All rights reserved.
//

#import "GIZSoftApCountDownViewController.h"
#import "StepFrameView.h"
#import "GIZSDKCommunicateService.h"
#import "GIZUtils.h"
//#import "SURQRViewController.h"
#import "GIZSoftApSuccessViewController.h"
#import "SURDeviceService.h"
#import <XPGWifiSDK/XPGWifiSDK.h>

@interface GIZSoftApCountDownViewController ()
{
    NSTimer *counterTimer;
    BOOL flag;
}
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (assign, nonatomic) NSInteger timeout;
@property (weak, nonatomic) IBOutlet UIView *stepFrameView;
@property (strong, nonatomic) GIZSDKCommunicateService *service;
@end

@implementation GIZSoftApCountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [GIZSDKCommunicateService sharedInstance];
    StepFrameView *sf = [[StepFrameView alloc] initTwoStep:secondStep];
    sf.frame = CGRectMake(0, 0, 320, 82);
    [sf.backButton addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sf];
    
    self.navigationController.navigationBarHidden = YES;
    [sf hideBackButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
    self.timeout = XPG_SOFTAP_TIMEOUT;
    [self startLoading];

  
    flag = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self releaseTimer];
    
    [GIZCommonUtils hideLoading];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startSoftAp];
}


-(void)pushToSuccessViewController:(XPGWifiDevice *)device
{
    [self performSegueWithIdentifier:@"toSoftApSuccessStep" sender:device];
}


-(void)configurationFailed
{
    if (self.navigationController.viewControllers.lastObject == self)
    {
        self.navigationItem.hidesBackButton = YES;
        [self performSegueWithIdentifier:@"toSoftApFailStep" sender:self];
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
        [self configurationFailed];
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

-(void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startSoftAp
{
    int timeout = XPG_SOFTAP_TIMEOUT;
    
    [_service configureSoftAp:self.ssid key:self.wifiPassword timeout:timeout completion:^(XPGWifiDevice *device,NSError *err,BOOL **stop){

        if(err.code == 0 || err.code == 39){
            if([device.productKey isEqualToString:GIZWaterHeaterProductKey] || [device.productKey isEqualToString:GIZWaterPurifierProductKey])
            {
                if (![device.did isEqualToString:@""])
                {
                    *stop = YES;
                    [self releaseTimer];
                    [self performSelector:@selector(pushToSuccessViewController:) withObject:device afterDelay:2.0f];
                }
            }
        }
        else
        {
            [self configurationFailed];
        }

    }];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[GIZSoftApSuccessViewController class]])
    {
        GIZSoftApSuccessViewController *successVC = segue.destinationViewController;
        successVC.selectedDeivce = (XPGWifiDevice *)sender;
    }
}


@end
