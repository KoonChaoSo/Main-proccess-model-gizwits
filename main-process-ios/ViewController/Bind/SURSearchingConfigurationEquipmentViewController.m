//
//  SURSearchingConfigurationEquipmentViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 24/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <XPGWifiSDK/XPGWifiSDK.h>
#import "SURSearchingConfigurationEquipmentViewController.h"


@interface SURSearchingConfigurationEquipmentViewController ()<XPGWifiSDKDelegate>

@end

@implementation SURSearchingConfigurationEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)ConfigurationDeviceButtonAction:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    
//}

#pragma delegate


@end
