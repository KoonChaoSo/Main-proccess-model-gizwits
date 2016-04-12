//
//  SURSoftApEnterPasswordViewController.m
//  micoeapp_ios
//
//  Created by ChaoSo on 15/10/26.
//  Copyright © 2015年 gizwits. All rights reserved.
//

#import "GIZSoftApInputPasswordViewController.h"
#import "StepFrameView.h"
#import "GIZWifiUtil.h"
#import "GIZSoftApCountDownViewController.h"

@interface GIZSoftApInputPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIView *stepFramView;
@property (weak, nonatomic) IBOutlet UITextField *textAccount;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;

@end

@implementation GIZSoftApInputPasswordViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StepFrameView *sf = [[StepFrameView alloc] initTwoStep:secondStep];
    sf.frame = CGRectMake(0, 0, 320, 82);
    [sf.backButton addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sf];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self didBecomeActive];
}


- (IBAction)onNextStep:(id)sender {
    if ([self.textAccount.text isEqualToString:@""])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"wifi名称不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    [self performSegueWithIdentifier:@"toSoftApThirdStep" sender:nil];
}

- (IBAction)passwordSwitchShow:(id)sender {
    UISwitch *switch_button = (UISwitch *)sender;
    self.textPassword.secureTextEntry = !switch_button.on;
}

- (void)didBecomeActive
{
//    self.textAccount.text = [[SURWifiUtil SSIDInfo] valueForKey:@"SSID"];
    self.textAccount.text = _PROCEES_MODEL.ssid;
    if(nil == self.textAccount)
    {
        self.textPassword.text = @"";
    }
}
-(void)backToFront
{
   [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 3)] animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GIZSoftApCountDownViewController *softApVC = segue.destinationViewController;
    
    softApVC.ssid = self.textAccount.text;
    softApVC.wifiPassword = self.textPassword.text;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.textPassword isExclusiveTouch]) {
        [self.textPassword resignFirstResponder];
    }
}

@end
