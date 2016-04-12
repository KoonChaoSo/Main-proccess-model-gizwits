/**
 * IoTSetWifi.m
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

#import "GIZSoftApStatementViewController.h"
#import "GIZWifiUtil.h"
#import "StepFrameView.h"
#import "GIZUtils.h"
//#import "SURConfiguredDeviceViewController.h"
#import "GIZDeviceListViewController.h"

@interface GIZSoftApStatementViewController ()
{
    NSTimer *wifiTimer;
}

//@property (weak, nonatomic) IBOutlet UITextField *textPass;
@property (strong, nonatomic) NSString *oldSSID;

@end

@implementation GIZSoftApStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _PROCEES_MODEL.ssid = [[GIZWifiUtil SSIDInfo] valueForKey:@"SSID"];
    
    StepFrameView *sf = [[StepFrameView alloc] initTwoStep:secondStep];
    sf.frame = CGRectMake(0, 0, 320, 82);
    [sf.backButton addTarget:self action:@selector(popToRetryView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sf];
    
    self.navigationController.navigationBarHidden = YES;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    wifiTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onWifiTimer) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(wifiTimer)
    {
        [wifiTimer invalidate];
        wifiTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onWifiTimer
{
    if([GIZWifiUtil isSoftAPMode:XPG_GAGENT])
    {
        [wifiTimer invalidate];
        [self performSegueWithIdentifier:@"toSoftApSecondStep" sender:self];
    }
}

-(void)popToRetryView
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
