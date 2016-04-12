/**
 * IoTLogin.m
 *
 * Copyright (c) 2014~2015 Xtreme Programming Group, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "SURLoginViewController.h"
#import "SURValidateUtils.h"
#import "AppDelegate.h"
#import "SURProcessModel.h"
#import "SURValidateUtils.h"
#import "SURUserService.h"
#import "SURUserServiceImp.h"
#import "SURCommonUtils.h"
#import "UIView+SURUIViewExtension.h"
#import "SURRegisterPhoneViewController.h"
#import "SURAlertView.h"
#import "SURProductDataPointModel.h"
#import "SURForgetPasswordViewController.h"
#import "SURControllerService.h"
#import "SURControlServiceImp.h"
#import "UISubSlider.h"
#import "SURCommonService.h"

#define ALERT_TAG_USERNAME          1
#define ALERT_TAG_PASSWORD          2
#define isPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

@interface SURLoginViewController ()<SURAlertViewDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UITextField *textPass;
@property (weak, nonatomic) IBOutlet UIView *textUserView;
@property (weak, nonatomic) IBOutlet UIView *textPassView;
@property (nonatomic,readonly) id<SURUserService> service;
@property (nonatomic,readonly) id<SURControllerService> service2;
@end

@implementation SURLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _service = [SURUserServiceImp sharedService];
    [self.navigationController setNavigationBarHidden:YES];
    //圆角
    [self.textUserView setRoundCornerWithRadius:15.0];
    [self.textPassView setRoundCornerWithRadius:15.0];
    
#pragma mark TODO:自动登录用户
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(nil == self.navigationController)
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"这个视图必须是使用 UINavigationController 加载。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        abort();
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [XPGWifiSDK sharedInstance].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XPGWifiSDK sharedInstance].delegate = nil;
    
    [self.textUser resignFirstResponder];
    [self.textPass resignFirstResponder];
    //清除密码
    self.textPass.text = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //只需要执行一次
    if(SUR_PROCEES_MODEL.isLogined)
    {
        [SURCommonUtils showLoadingWithTile:@"自动登录中..."];
//        NSLog(@"username:     %@   , password:    %@",[SURProcessModel sharedModel].username,[SURProcessModel sharedModel].password);
//        [[XPGWifiSDK sharedInstance] userLoginWithUserName:[SURProcessModel sharedModel].username password:[SURProcessModel sharedModel].password];
    }
    
}

#pragma mark - Action
- (void)didBecomeActive {
    [self.textUser resignFirstResponder];
    [self.textPass resignFirstResponder];
}

- (IBAction)onTap:(id)sender {
    // 关闭键盘
    if([sender isMemberOfClass:[UITapGestureRecognizer class]])
    {
        [self.textUser resignFirstResponder];
        [self.textPass resignFirstResponder];
    }
    
    if(self.textUser.isFirstResponder || self.textPass.isFirstResponder)
        return;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationsEnabled:YES];
    CGRect rc = self.view.frame;
    rc.origin.y = 0;
    self.view.frame = rc;
    [UIView commitAnimations];
}

- (IBAction)onLogin:(id)sender {
//    if(self.textUser.text.length == 0)
//    {
//        SURAlertView *alertView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"手机或邮箱不能为空" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
//        [alertView setButtonToHideView:AlertViewUperButtonToHide];
//        [self.view addSubview:alertView];
//        alertView.tag = ALERT_TAG_USERNAME;
//        alertView.delegate = self;
//        return;
//    }
//    if(self.textPass.text.length == 0)
//    {
//        SURAlertView *alertView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"密码不能为空" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
//        [alertView setButtonToHideView:AlertViewUperButtonToHide];
//        [self.view addSubview:alertView];
//        alertView.tag = ALERT_TAG_PASSWORD;
//        return;
//    }
//    
//    if(![[SURValidateUtils sharedUtils] validateEmail:self.textUser.text] &&
//       ![[SURValidateUtils sharedUtils] validatePhone:self.textUser.text])
//    {
//        SURAlertView *alertView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"用户名格式不正确，请重新输入" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
//        [alertView setButtonToHideView:AlertViewUperButtonToHide];
//        [self.view addSubview:alertView];
//        alertView.tag = ALERT_TAG_USERNAME;
//        return;
//    }
//    [SURCommonUtils showLoadingWithTile:@"登录中..."];
    
//    [[XPGWifiSDK sharedInstance] userLoginWithUserName:self.textUser.text password:self.textPass.text];
    
    NSError *err = nil;
    SURCommonService *sev = [[SURCommonService alloc] init];
    [sev loginForSDKWithPhone:self.textUser.text password:self.textPass.text error:&err];
    if (err.code == kSURCommonPhoneFormatError)
    {
        SURAlertView *alertView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"手机格式错误" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [alertView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:alertView];
        alertView.tag = ALERT_TAG_USERNAME;
        alertView.delegate = self;
        return;
    }
    if (err.code == kSURCommonPasswordFormatError) {
        SURAlertView *alertView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"密码必须为8-15位数字大小写字母组合" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [alertView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:alertView];
        alertView.tag = ALERT_TAG_PASSWORD;
        return;
    }
    
}

- (IBAction)onForgetPassword:(id)sender {
    SURForgetPasswordViewController *forgetPassword = [[SURForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetPassword animated:YES];
}

- (IBAction)onRegister:(id)sender {
    SURRegisterPhoneViewController *registerView = [[SURRegisterPhoneViewController alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
}
#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat y = 0;
    if(textField == self.textUser || textField == self.textPass)
        y = isPhone4s ? -55 : -50;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationsEnabled:YES];
    CGRect rc = self.view.frame;
    rc.origin.y = y;
    self.view.frame = rc;
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self performSelector:@selector(onTap:) withObject:nil afterDelay:0.2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.textUser)
        [self.textPass becomeFirstResponder];
    
    if(textField == self.textPass)
    {
        [textField resignFirstResponder];
        [self onLogin:textField];
    }
    return YES;
}

#pragma mark XPGWifiSDK delegate
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUserLogin:(NSNumber *)error errorMessage:(NSString *)errorMessage uid:(NSString *)uid token:(NSString *)token
{
    if([error intValue])
    {
        [SURCommonUtils hideLoading];
        NSString *message = [NSString stringWithFormat:@"登录失败：%@", errorMessage];
        SURAlertView *alertView = [SURAlertView UIAlertViewWithTitle:@"提示" message:message uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [alertView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:alertView];
    }
    else
    {
        [self.service saveToken:token
                        WithUid:uid
                 WithAccoutType:AccountTypeDefault];
        
        if(self.textUser.text.length > 0 && self.textPass.text.length > 0)
        {
            [self.service saveAccount:self.textUser.text
                         WithPassword:self.textPass.text];
        }
        [SURCommonUtils hideLoading];
//        DevicesListViewController *push = [[DevicesListViewController alloc] init];
//        [self.navigationController pushViewController:push animated:NO];
    }
}

-(void)alertViewForSUR:(SURAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView.tag == ALERT_TAG_USERNAME){
        [self.textUser becomeFirstResponder];
    }
    else if(alertView.tag == ALERT_TAG_PASSWORD){
        [self.textPass becomeFirstResponder];
    }
}

@end
