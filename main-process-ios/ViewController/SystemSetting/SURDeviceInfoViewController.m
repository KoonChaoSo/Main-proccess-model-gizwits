//
//  SURDeviceInfoViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/26.
//  Copyright © 2015年 Sunrain. All rights reserved.
//
#import <XPGWifiSDK/XPGWifiSDK.h>

#import "SURDeviceInfoViewController.h"
#import "GizSDKCommunicateService.h"
#import "SURAppInfo.h"
#import "QRCodeGenerator.h"
#import "CommonAlertViewController.h"
#define WATER_HEATER_IMAGE @""

@interface SURDeviceInfoViewController ()<XPGWifiSDKDelegate,CommonAlertViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *deviceInfoImageView;
@property (strong, nonatomic) GizSDKCommunicateService *service;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIView *changeDeviceNameView;
@property (weak, nonatomic) IBOutlet UITextField *changDeviceNameLabel;

@property (strong, nonatomic) CommonAlertViewController *alerViewController;
@end

@implementation SURDeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.service = [[SURCommonService alloc] init];
    
    self.navigationItem.title = @"设备管理";
    [self showWaterPurifier];
    [self configureDeviceName];
    //[self configureRightItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [XPGWifiSDK sharedInstance].delegate = self;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XPGWifiSDK sharedInstance].delegate = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
}

// 修改设备名按钮响应
- (IBAction)changeDeivceNameButtonAction:(id)sender {
    [self.changeDeviceNameView setHidden:NO];
}

// 取消修改设备名称按钮响应
- (IBAction)changeDeviceNameCancelButtonAction:(id)sender {
    [self.changeDeviceNameView setHidden:YES];
}

// 确认修改设备名称按钮响应
- (IBAction)changDeviceNameConfirmButtonAction:(id)sender {
    [self onSaveRemark];
    [self.changeDeviceNameView setHidden:YES];
}

// 按下键盘确认按钮后的动作
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onDeleteDevice:(id)sender {
        

    
    self.alerViewController = [[CommonAlertViewController alloc] init];
    [self.alerViewController showWithContent:@"是否删除该设备" title:@"温謦提示" delegate:self];
}
//
//- (void)showDeviceQrCode
//{
//    NSString *qrcodeContent = [NSString stringWithFormat:@"www.baidu.com?did=%@&passcode=%@&product_key=%@",self.selectedDevice.did,self.selectedDevice.passcode,self.selectedDevice.productKey];
//    self.deviceInfoImageView.image = [QRCodeGenerator qrImageForString:qrcodeContent imageSize:self.deviceInfoImageView.bounds.size.height];
//}

- (void)showWaterPurifier
{
    NSString *imageName = @"";
    
    if ([self.selectedDevice.productKey isEqualToString:SURWaterHeaterProductKey])
    {
        imageName = @"device_img2";
    }
    else if ([self.selectedDevice.productKey isEqualToString:SURWaterPurifierProductKey])
    {
        imageName = @"device_img";
    }
        
    self.deviceInfoImageView.image = [UIImage imageNamed:imageName];
}

-(void)configureDeviceName
{
    NSString *remark = self.selectedDevice.remark;
    NSString *productName = self.selectedDevice.productName;
    
    if ([remark isEqualToString:@""])
    {
        self.deviceNameLabel.text = productName;
        self.changDeviceNameLabel.text = productName;
    }
    else
    {
        self.deviceNameLabel.text = remark;
        self.changDeviceNameLabel.text = remark;
    }
}

-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUnbindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    if (![error intValue])
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除设备成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alerView.tag = 102;
        [alerView show];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除设备失败，请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 102)
    {
        [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 3)] animated:YES];
    }
}

-(void)configureRightItem
{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,25)];
    [rightButton setImage:[UIImage imageNamed:@"icon_ok.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(onSaveRemark) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)onSaveRemark
{
    if ([self.changDeviceNameLabel.text isEqualToString:@""])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"重命名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return ;
    }
    NSError *err;
    [self.service bindDeviceForSDKWithDid:self.selectedDevice.did passcode:self.selectedDevice.passcode remark:self.changDeviceNameLabel.text error:&err];
    
}


-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didBindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    if (!error.intValue)
    {
        NSString *message = @"保存成功";
        [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        
        [self.navigationController popViewControllerAnimated:YES];
//        [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 3)] animated:YES];
    }
    else
    {
        NSString *message = @"保存失败,请稍后再试！";
        [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    
}

-(void)commonAlertView:(CommonAlertViewController *)commonAlertView
{
    [commonAlertView hideAlertView];
    NSError *error ;
    [self.service unbindDeviceForSDKWithDid:self.selectedDevice.did passcode:self.selectedDevice.passcode error:&error];
    if (error.code == kSURCommonNormalError)
    {
        NSLog(@"isn't delegate");
    }
    if (error.code == kSURCommonIsNotLogined)
    {
        NSLog(@"isn't logined");
    }
}
@end
