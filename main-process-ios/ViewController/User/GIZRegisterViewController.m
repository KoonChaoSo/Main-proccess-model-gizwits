//
//  SURRegisterViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 23/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "GIZRegisterViewController.h"
#import "GIZCommonUtils.h"
#import "GizSDKCommunicateService.h"
#import "StepFrameView.h"
#import "GIZAppInfo.h"
#import "SURMainViewController.h"
#import "NSTimer+GIZTimer.h"

@interface GIZRegisterViewController (){
    NSTimer *counterTimer;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIButton *refreshVerifyCodeButton;
@property (weak, nonatomic) IBOutlet UIView *verifyCodeView;
@property (weak, nonatomic) IBOutlet UIView *stepFrame;
@property (strong, nonatomic) GIZSDKCommunicateService *service;

@property (strong, nonatomic) NSString *captchaID;

@end

static int counter;

@implementation GIZRegisterViewController

#pragma mark  获取短信验证码
- (IBAction)getMessageButtonAction:(id)sender {
    if ([self.phoneText.text isEqual:@""]) {
        NSString *message = @"手机不能为空，请重新输入";
        [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if ([self.codeText.text isEqual:@""]) {
        NSString *message = @"图形验证码不能为空，请重新输入";
        [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    [self reloadRequestMessage];
}

#pragma mark 验证码重复获取
- (IBAction)refreshVerifyCodeButtonAction:(id)sender {
    [GIZCommonUtils showLoadingWithTile:@"正在请求验证码，请稍候..."];
    [self reloadRequestMessage];
}
- (IBAction)codeImageView:(id)sender {
    [self getCaptchaCodeBlock];
}

#pragma mark  确定
- (IBAction)comfirmButtonAction:(id)sender {
    [GIZCommonUtils showLoadingWithTile:@"注册中..."];
    [self.service registerWithPhone:self.phoneText.text password:self.passwordText.text code:self.messageText.text completion:^(NSError *err){
        if (err.code)
        {
            [GIZCommonUtils hideLoading];
            NSString *message = [err localizedDescription];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            [GIZCommonUtils hideLoading];
            
            if(self.navigationController.viewControllers.lastObject == self){
                    [self pushToMainView];
            }
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 倒数
-(void)startCountDown{
    counter = 59;
    [self releaseTimer];
    if(!counterTimer){
        counterTimer = [NSTimer giz_scheduledTimerWithTimerInterval:1 block:^{
            [self countDownTimer];
        } repeats:YES];
    }
}
- (void)countDownTimer
{
    if(counter > 0)
    {
        [self.refreshVerifyCodeButton setBackgroundColor:[UIColor grayColor]];
        NSString *title = [NSString stringWithFormat:@"%i秒后重试", counter];
        [self.refreshVerifyCodeButton setEnabled:NO];
        [self.refreshVerifyCodeButton setTitle:title forState:UIControlStateDisabled];
    }
    if(counter == 0)
    {
        [self.refreshVerifyCodeButton setBackgroundColor:[UIColor colorWithRed:252/255.0 green:159/255.0 blue:100/255.0 alpha:1]];
        [self releaseTimer];
        [self getCaptchaCodeBlock];
        [self.refreshVerifyCodeButton setEnabled:YES];
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

#pragma mark Custom method
-(void)reloadRequestMessage
{
    [self.service requestSendPhoneSMSCodeWithCaptchaId:self.captchaID captchaCode:self.codeText.text phone:self.phoneText.text completion:^(NSError *err){
        [GIZCommonUtils hideLoading];
        if (!err.code)
        {
            [self startCountDown];
            [self.verifyCodeView setHidden:NO];
        }
        else if (err.code)
        {
            NSString *message = [err localizedDescription];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [textField resignFirstResponder];
    return YES;
}

-(void)pushToMainView
{
    SURMainViewController *mainVC = [[SURMainViewController alloc] init];
    [self.navigationController pushViewController:mainVC animated:YES];
}


#pragma mark - viewcontroller
- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [GIZSDKCommunicateService sharedInstance];
    
    StepFrameView *sf = [[StepFrameView alloc] initFourStep:firstStep];
    [self.stepFrame addSubview:sf];
    [sf.backButton addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self getCaptchaCodeBlock];
    [self.refreshVerifyCodeButton setEnabled:YES];
    [self.refreshVerifyCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
    [self.verifyCodeView setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.passwordText.text = nil;
}

- (void)dealloc{
    [self releaseTimer];
}

-(void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  获取图片验证码信息并显示
- (void)getCaptchaCodeBlock{
    [self.service getCaptchaCodeWithCompletion:^(NSString *token,NSString *captchaId ,NSString *captchaURL ,NSError *err){
        if (!err.code)
        {
            _PROCEES_MODEL.sendMsgToken = token;
            self.captchaID = captchaId;
            
            NSURL *url = [NSURL URLWithString:captchaURL];
            NSData* data = [NSData dataWithContentsOfURL:url];//获取网咯图片数据
            if(data != nil)
            {
                UIImage *image = [[UIImage alloc] initWithData:data];//根据图片数据流构造image
                self.codeImageView.image = image;
            }
        }else{
            NSString *message = @"获取图形验证码失败，请稍等重试";
            [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }];
}
@end
