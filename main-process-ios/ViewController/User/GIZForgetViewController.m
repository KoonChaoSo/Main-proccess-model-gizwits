//
//  SURForgotViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 23/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "GIZForgetViewController.h"
#import "GIZCommonUtils.h"
#import "GizSDKCommunicateService.h"
#import "GIZAppInfo.h"
#import "StepFrameView.h"
#import "UIAlertView+SURUIAlertView.h"
#import "NSTimer+GIZTimer.h"

@interface GIZForgetViewController (){
    NSTimer *counterTimer;
    GIZSDKCommunicateService *service;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIButton *refreshVerifyCodeButton;
@property (weak, nonatomic) IBOutlet UIView *verifyCodeView;
@property (weak, nonatomic) IBOutlet UIView *stepFrameView;
@property (weak, nonatomic) IBOutlet UIButton *refreshCodeImageButton;

@property (strong, nonatomic) NSString *captchaID;

@end

static int counter = 60;
static GIZSDKCommunicateService *service = nil;

@implementation GIZForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    service = [GIZSDKCommunicateService sharedInstance];
    [self.refreshVerifyCodeButton setEnabled:YES];
    [self.refreshVerifyCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
    [self.verifyCodeView setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCaptchaCodeBlock];
    self.navigationController.navigationBarHidden = NO;
     //[self.navigationController setNavigationBarHidden:YES animated:animated];
//    StepFrameView *sf = [[StepFrameView alloc] initFourStep:firstStep];
//    [sf backButtonAction:self withSelector:@selector(back)];
//    [self.stepFrameView addSubview:sf];
    
}

-(void)dealloc
{
    [self releaseTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.passwordText.text = nil;
}

#pragma mark - 获取短信验证码
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

#pragma mark - 验证码重复获取
- (IBAction)refreshVerifyCodeButtonAction:(id)sender {
    [GIZCommonUtils showLoadingWithTile:@"正在请求验证码，请稍候..."];
    [self reloadRequestMessage];
}

#pragma mark - 图片验证码
- (IBAction)codeImageView:(id)sender {
    [self getCaptchaCodeBlock];
}

#pragma mark - 确定
- (IBAction)comfirmButtonAction:(id)sender {
    [GIZCommonUtils showLoadingWithTile:@"修改中..."];
    [service forgetPasswordWithNewPassword:self.passwordText.text phone:self.phoneText.text code:self.messageText.text completion:^(NSError *err){        
        if (err.code)
        {
            [GIZCommonUtils hideLoading];
            NSString *message = [err localizedDescription];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            [GIZCommonUtils hideLoading];
            NSString *message = @"已设置新密码，请重新登录";
            
            [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] showAfterTimeInterval:1.f];
            
            _PROCEES_MODEL.password = nil;
            
            [self performSelector:@selector(popLoginViewController) withObject:self afterDelay:1.5f];
            return;
        }

    }];
}

#pragma mark - HACK
-(void)startCountDown{
    counter = 59;
    [self releaseTimer];
    __weak GIZForgetViewController *weakSelf = self;
    if (!counterTimer) {
        counterTimer = [NSTimer giz_scheduledTimerWithTimerInterval:1 block:^{
            GIZForgetViewController *strongSelf = weakSelf;
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
        [self.refreshVerifyCodeButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
        [self releaseTimer];
        [self.refreshVerifyCodeButton setEnabled:YES];
        NSString *title = [NSString stringWithFormat:@"重新获取"];
        [self.refreshVerifyCodeButton setTitle:title forState:UIControlStateDisabled];
        [self getCaptchaCodeBlock];
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
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Custom mothod
-(void)reloadRequestMessage
{
    [service requestSendPhoneSMSCodeWithCaptchaId:self.captchaID captchaCode:self.codeText.text phone:self.phoneText.text completion:^(NSError *err){
        [GIZCommonUtils hideLoading];
        if (!err.code)
        {
            [self startCountDown];
            [self.verifyCodeView setHidden:NO];
        }
        else if (err.code)
        {
            [GIZCommonUtils hideLoading];
            NSString *message = [err localizedDescription];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (void)popLoginViewController{
    [GIZCommonUtils hideLoading];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark  获取图片验证码信息并显示
- (void)getCaptchaCodeBlock{
    [service getCaptchaCodeWithCompletion:^(NSString *token,NSString *captchaId ,NSString *captchaURL ,NSError *err)
    {
        if (!err.code)
        {
            _PROCEES_MODEL.sendMsgToken = token;
            self.captchaID = captchaId;
            
            NSURL* url = [NSURL URLWithString:[captchaURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
            NSData* data = [NSData dataWithContentsOfURL:url];//获取网咯图片数据
            
            if(data!=nil)
            {
                UIImage *image = [[UIImage alloc] initWithData:data];//根据图片数据流构造image
                self.codeImageView.image = image;
            }
        }else
        {
            
            NSString *message = @"获取图形验证码失败";
            [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
    }];
}

@end
