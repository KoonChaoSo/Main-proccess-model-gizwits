//
//  SURRegisterPhoneViewController.m
//  SUROpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/7/30.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

//#import "SURRegisterPhoneViewController.h"
#import "SURValidateUtils.h"
#import "SURCommonUtils.h"
#import "SURUserService.h"
//#import "SURUserServiceImp.h"
//#import "SURRegisterMailViewController.h"
#import "SURAlertView.h"
#import "SURCommonService.h"

static int counter = 60;

@interface SURRegisterPhoneViewController (){
    NSTimer *counterTimer;
}

@property (nonatomic,strong) id<SURUserService>service;

@property (nonatomic,strong) NSString * validateToken;
@property (nonatomic,strong) NSString * captchaID;
@end

@implementation SURRegisterPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"注册";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(myCustomBackButton_backBarbuttonItem)];
    
    _service = [SURUserServiceImp sharedService];
    [self.textPhone becomeFirstResponder];
    
}

#pragma mark - Action
- (void)myCustomBackButton_backBarbuttonItem
{
    if(self.navigationController.viewControllers.lastObject == self)
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [XPGWifiSDK sharedInstance].delegate = self;
    [self.btnVerifyCode setEnabled:YES];
    [self reloadCaptcha];
    [self.btnVerifyCode setTitle:@"获取验证码" forState:UIControlStateDisabled];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XPGWifiSDK sharedInstance].delegate = nil;
    [self releaseTimer];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //清除密码
    self.textPassword.text = nil;
}

- (IBAction)onGetVerifyCode:(id)sender
{
//    if(![[SURValidateUtils sharedUtils] validatePhone:self.textPhone.text]){
//        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"请填写正确的手机号码" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
//        [warningView setButtonToHideView:AlertViewUperButtonToHide];
//        [self.view addSubview:warningView];
//        return;
//    }
//    [SURCommonUtils showLoadingWithTile:@"正在请求验证码，请稍候..."];
//    [[XPGWifiSDK sharedInstance] requestSendVerifyCode:self.textPhone.text];
//    [[XPGWifiSDK sharedInstance] requestSendPhoneSMSCode:self.validateToken captchaId:self.captchaID captchaCode:self.textVerifyNumber.text phone:self.textPhone.text];
    
    NSError * error = nil;
    SURCommonService * sev = [[SURCommonService alloc]init];
    [sev registerForSDKWithPhone:self.textPhone.text password:self.textPassword.text code:self.textVerifyNumber.text error:&error];
//    if (error.code == kSURCommonPhoneFormatError) {
//        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"手机格式有误" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
//        [warningView setButtonToHideView:AlertViewUperButtonToHide];
//        [self.view addSubview:warningView];
//        return;
//    }
//    if (error.code == kSURCommonOldAndNewPasswordIsSame) {
//        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"密码必须为8-15位数字大小写字母组合" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
//        [warningView setButtonToHideView:AlertViewUperButtonToHide];
//        [self.view addSubview:warningView];
//        return;
//    }
//    if (error.code == kSURCommonCodeFormatError) {
//        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"验证码有误" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
//        [warningView setButtonToHideView:AlertViewUperButtonToHide];
//        [self.view addSubview:warningView];
//        return;
//    }
}

- (IBAction)onConfirmForPhoneRegister:(id)sender {
    
    if(self.textPhone.text.length == 0)
    {
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"请填写正确的手机号码" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:warningView];
        return;
    }
    
    if(self.textPassword.text.length == 0)
    {
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"密码不能为空，请重新输入" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:warningView];
        return;
    }
    
    if(self.textPassword.text.length < 6 || self.textPassword.text.length > 16)
    {
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"密码长度要求介于 6-16 之间" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:warningView];
        return;
    }
    
    if(self.textVerifyNumber.text.length == 0)
    {
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"请输入验证码" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:warningView];
        return;
    }
    
    if(![[SURValidateUtils sharedUtils] validatePassword:self.textPassword.text])
    {
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"密码只能是数字、大小写或特殊字符" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:warningView];
        return;
    }
    
    [self.textPhone resignFirstResponder];
    [self.textPassword resignFirstResponder];
    [self.textVerifyNumber resignFirstResponder];
    
    if(![[SURValidateUtils sharedUtils] validatePhone:self.textPhone.text])
    {
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"请填写正确的手机号码" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:warningView];
        return;
    }
    [self releaseTimer];
    [SURCommonUtils showLoadingWithTile:@"注册中..."];
    [[XPGWifiSDK sharedInstance] registerUserByPhoneAndCode:self.textPhone.text password:self.textPassword.text code:self.textVerifyNumber.text];
}

#pragma mark Custom mothod
-(void)reloadCaptcha
{
//    [[XPGWifiSDK sharedInstance] getCaptchaCode:@"dc5b945db45f427c97ec9ae881850623"];
}

#pragma mark XPGWifiSDK delegate

-(void)wifiSDK:(XPGWifiSDK *)wifiSDK didGetCaptchaCode:(NSError *)result token:(NSString *)token captchaId:(NSString *)captchaId captchaURL:(NSString *)captchaURL
{
    if (!result.code)
    {
        self.validateToken = token;
        self.captchaID = captchaId;

        
        NSURL *url = [NSURL URLWithString:captchaURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
//        NSURL* url = [NSURL URLWithString:[captchaURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
//        NSError *error;
//        NSData *data = [NSData dataWithContentsOfURL:url options:nil error:&error];
//        NSData* data = [NSData dataWithContentsOfURL:url];//获取网咯图片数据
        
//        NSURLRequest* urlreq = [[NSURLRequest alloc] initWithURL:url];
////        NSData * data    = [[NSURLConnection alloc] initWithRequest:urlreq delegate:self];
//        NSData *data = [NSURLConnection sendSynchronousRequest:urlreq returningResponse:nil error:nil];
        
        
        if(data!=nil)
        {
            UIImage *image = [[UIImage alloc] initWithData:data];//根据图片数据流构造image
            self.verifyCodeInAlertViewImageView.image = image;
        }
    }
}

-(void)wifiSDK:(XPGWifiSDK *)wifiSDK didRequestSendPhoneSMSCode:(NSError *)result
{
    if (!result.code)
    {
//        [self startCountDownForVerifyCodeButton];
//        [self.reloadView setHidden:YES];
        NSLog(@"chenggong");
    }
    else
    {
//        if(self.navigationController.viewControllers.lastObject == self){
//            self.warningInAlertView.text = NSLS(@"warning_incorrect_code");
//            [self reloadCaptcha];
//        }
        NSLog(@"shibai");
    }
}



- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didRequestSendVerifyCode:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    if([error intValue] != 0)
    {
        //8:{"code":9,"msg":"同一手机号5分钟内重复提交相同的内容超过3次","detail":"同一个手机号 xxxxxxxxxxx 5分钟内重复提交相同的内容超过3次"}
        SURAlertView *warningView = [SURAlertView UIAlertViewWithTitle:@"提示" message:@"获取验证码失败，请稍候重试" uperButtonTitle:@"知道了" bottomButtonTitles:nil];
        [warningView setButtonToHideView:AlertViewUperButtonToHide];
        [self.view addSubview:warningView];
    }
    else
    {
        [self startCountDown];
    }
    [SURCommonUtils hideLoading];
}
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didRegisterUser:(NSNumber *)error errorMessage:(NSString *)errorMessage uid:(NSString *)uid token:(NSString *)token
{
    int errorValue = [error intValue];
    if(errorValue)
    {
        NSString *message = errorMessage;
        switch (errorValue) {
            case 9010:
                message = @"验证码不正确";
                break;
            case 9018:
                message = @"用户已注册，请勿重复注册";
                break;
            default:
                break;
        }
        [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        [self releaseTimer];
    }
    [SURCommonUtils hideLoading];
    [GIZProcessModel sharedModel].token = token;
    [GIZProcessModel sharedModel].uid   = uid;
    if(self.navigationController.viewControllers.lastObject == self){
        
    }
    
}

#pragma mark - HACK
-(void)startCountDown{
    counter = 59;
    [self releaseTimer];
    if(!counterTimer){
        counterTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimer) userInfo:nil repeats:YES];
    }
}
- (void)countDownTimer
{
    if(counter > 0)
    {
        [self.btnVerifyCode setBackgroundColor:[UIColor grayColor]];
        NSString *title = [NSString stringWithFormat:@"%i秒后重试", counter];
        [self.btnVerifyCode setEnabled:NO];
        [self.btnVerifyCode setTitle:title forState:UIControlStateDisabled];
    }
    if(counter == 0)
    {
        [self.btnVerifyCode setBackgroundColor:[UIColor colorWithRed:252/255.0 green:159/255.0 blue:100/255.0 alpha:1]];
        [self releaseTimer];
        [self.btnVerifyCode setEnabled:YES];
        return;
    }
    counter--;
}

-(void)releaseTimer{
    [counterTimer invalidate];
    if(counterTimer){
        counterTimer = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.textPhone)
        [self.textPhone resignFirstResponder];
    
    if(textField == self.textPassword)
    {
        [textField resignFirstResponder];
    }
    if(textField == self.textVerifyNumber){
        [textField resignFirstResponder];
    }
    return YES;
}


@end
