//
//  SURLoginViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 23/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "GIZLoginViewController.h"
#import "GizSDKCommunicateService.h"
#import "UIView+SURUIViewExtension.h"
#import "GIZAppInfo.h"
#import "GIZUtils.h"
#import "TNImageCheckBoxData.h"
#import "TNCheckBoxGroup.h"
#import "SURMainViewController.h"
#import "SURErrorView.h"

@interface GIZLoginViewController ()<XPGWifiSDKDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIView *accountContentView;
@property (weak, nonatomic) IBOutlet UIView *passwordContentView;
@property (weak, nonatomic) IBOutlet UIView *checkboxView;
@property (nonatomic, strong) TNCheckBoxGroup *loveGroup;
@property (strong, nonatomic) GIZSDKCommunicateService *service;

@end

@implementation GIZLoginViewController



#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [GIZSDKCommunicateService sharedInstance];
    [self configureView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    self.accountText.text = _PROCEES_MODEL.username;
    if (_PROCEES_MODEL.isRemember)
    {
        self.passwordText.text = _PROCEES_MODEL.password;
    }
    _PROCEES_MODEL.isRemember = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self.accountText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    //清除密码
    self.passwordText.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 登录

- (IBAction)loginButtonAction:(id)sender {
    
    [GIZCommonUtils showLoadingWithTile:@"登录中..."];
//    登录
    [self loginUser:self.accountText.text password:self.passwordText.text];
}

-(void)updateLoginViewAndPasswordViewRoundConner
{
    [self.accountContentView setRoundCornerWithRadius:5.0F];
    [self.passwordContentView setRoundCornerWithRadius:5.0F];
}

#pragma mark - Action
- (void)didBecomeActive {
    [self.accountText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.accountText)
        [self.passwordText becomeFirstResponder];
    
    
    if(textField == self.passwordText)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)passwordSwitchShow:(id)sender {
    UISwitch *switch_button = (UISwitch *)sender;
    self.passwordText.secureTextEntry = !switch_button.on;
    
}

#pragma mark - 登录
-(void)loginUser:(NSString *)username password:(NSString *)password
{
    [self.service loginForSDKWithPhone:username password:password completion:^(NSError *err)
    {
        [GIZCommonUtils hideLoading];
        if (err.code == 0)
        {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            [self saveUserInfo];
            [self pushToMainVC:NO];
        }
        else
        {
            NSString *message = [err localizedDescription];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
    }];
}

-(void)configureView
{
    [self updateLoginViewAndPasswordViewRoundConner];
}

-(void)onTap:(UITapGestureRecognizer *)tap
{
    [self.accountText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

-(void)goAheadMainVC
{
    //TODO 跳转
    SURMainViewController *main = [[SURMainViewController alloc] init];
    [self.navigationController pushViewController:main animated:NO];
}

-(void)saveUserInfo
{
    if(self.accountText.text.length > 0 && self.passwordText.text.length > 0)
    {
        if (_PROCEES_MODEL.isRemember)
        {
            _PROCEES_MODEL.password = self.passwordText.text;
        }
        _PROCEES_MODEL.username = self.accountText.text;
    }
}

@end
