//
//  SURStartAirlinkViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/28.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURStartAirlinkViewController.h"
#import "GIZWifiUtil.h"
#import "SURAirLinkViewController.h"
#import "StepFrameView.h"

@interface SURStartAirlinkViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wifiNameText;
@property (weak, nonatomic) IBOutlet UITextField *wifiPasswordText;
@property (weak, nonatomic) IBOutlet UISwitch *showPasswordSwitch;

@property (strong, nonatomic) NSString *ssid;
@property (strong, nonatomic) NSString *wifiPassword;
@property (weak, nonatomic) IBOutlet UIView *stepFrameView;

@end

@implementation SURStartAirlinkViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StepFrameView *sf = [[StepFrameView alloc] initFourStep:thirdStep];
    sf.frame = CGRectMake(0, 0, 320, 82);
    [sf.backButton addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sf];
    self.navigationController.navigationBarHidden = YES;
    
    [self didBecomeActive];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [XPGWifiSDK sharedInstance].delegate = nil;
    
    [self.wifiPasswordText resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 下一步按钮响应
- (IBAction)nextStepButtonAction:(id)sender {
    // 判断
    if(!self.wifiNameText.text){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"wifi还没连接哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return ;
    }
    self.ssid = self.wifiNameText.text;
    self.wifiPassword = self.wifiPasswordText.text;
    [self checkNetwokStatus];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    SURAirLinkViewController *send = segue.destinationViewController;
    if([send respondsToSelector:@selector(setSsid:)] && [send respondsToSelector:@selector(setWifiPassword:)])
    {
        [send setValue:self.ssid forKey:@"ssid"];
        [send setValue:self.wifiPassword forKey:@"wifiPassword"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didBecomeActive
{
    self.wifiNameText.text = [[GIZWifiUtil SSIDInfo] valueForKey:@"SSID"];
    if(nil == self.wifiNameText)
    {
        self.wifiPasswordText.text = @"";
    }
}

-(void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)passwordSwitchShow:(id)sender {
    UISwitch *switch_button = (UISwitch *)sender;
    self.wifiPasswordText.secureTextEntry = !switch_button.on;
}

#pragma mark - 检查网络
- (void)checkNetwokStatus
{
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            [self performSegueWithIdentifier:@"toAirLinkSecondStep" sender:self];
            break;
        }
        case AFNetworkReachabilityStatusNotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络是否正确连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:
            break;
    }
}

@end
