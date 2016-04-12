//
//  SURUserManagerViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/25.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURUserManagerViewController.h"
#import "SURPasswordManagerViewController.h"
#import "GizSDKCommunicateService.h"
#import "CommonAlertViewController.h"
#import "UIAlertView+SURUIAlertView.h"

@interface SURUserManagerViewController ()<XPGWifiSDKDelegate,CommonAlertViewDelegate>
{
    BOOL isFemale;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginUserNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;

@property (strong, nonatomic) GizSDKCommunicateService *service;

@property (strong, nonatomic) CommonAlertViewController *alerViewController;
@end

@implementation SURUserManagerViewController

- (void)saveUserInfo
{
    NSLog(@"保存你的信息");
    [[[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] showAfterTimeInterval:1.f];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.service = [[SURCommonService alloc] init];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"注销登录" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.navigationItem.title = @"账户管理";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)onLogout
{
    self.alerViewController = [[CommonAlertViewController alloc] init];
    [self.alerViewController showWithContent:@"是否注销" title:@"温謦提示" delegate:self];
}
- (IBAction)onSave:(id)sender {
    
//    self.alerViewController = [[CommonAlertViewController alloc] init];
//    [self.alerViewController showWithContent:@"温謦提示" title:@"是否注销" delegate:self];
    [self saveUserInfo];
}

// 按下键盘确认按钮后的动作
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUserLogout:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    if (![error integerValue])
    {
        SUR_PROCEES_MODEL.token = nil;
        SUR_PROCEES_MODEL.uid = nil;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)commonAlertView:(CommonAlertViewController *)commonAlertView
{
    [self.alerViewController hideAlertView];
    [self.service logoutForSDK];
}

-(void)onTap:(UITapGestureRecognizer *)tap
{
    [self.nameTextField resignFirstResponder];
    [self.loginUserNameTextField resignFirstResponder];
    [self.birthdayTextField resignFirstResponder];
    
}
- (IBAction)switchGender:(id)sender {
    UISegmentedControl *segment = ((UISegmentedControl *)sender);
    if (segment.selectedSegmentIndex == 0)
    {
        isFemale = YES;
    }
    else
    {
        isFemale = NO;
    }
}

@end
