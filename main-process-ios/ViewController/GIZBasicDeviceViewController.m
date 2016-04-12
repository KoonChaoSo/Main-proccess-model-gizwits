//
//  GIZSuperTestaaa.m
//  main-process-ios
//
//  Created by ChaoSo on 16/2/24.
//  Copyright © 2016年 gitzwits. All rights reserved.
//

#import "GIZBasicDeviceViewController.h"
#import "XPGWifiDevice+SDKExtension.h"

@implementation GIZBasicDeviceViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor magentaColor];
    self.sdkService = [[GIZSDKCommunicateService alloc] init];
    self.device.delegate = self;
    [self startNotifyDeviceInfo];
}

-(void)dealloc
{
    self.sdkService = nil;
}



- (void)startNotifyDeviceInfo
{
    [self.device giz_getDeviceStatus:self];
}

- (void)gizCommunicateDeviceStatus:(XPGWifiDevice *)device didReceiveModel:(id)model alerts:(NSArray *)alerts faults:(NSArray *)faults error:(NSError *)error
{
    
}





@end
