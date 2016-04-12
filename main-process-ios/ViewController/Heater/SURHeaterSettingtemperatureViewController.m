//
//  SURHeaterSettingtemperatureViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 8/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURHeaterSettingtemperatureViewController.h"
#import "SURWaterHeaterProductDataPointModel.h"
#import "GizSDKCommunicateService.h"
#import "SURCommonUtils.h"
#import "UICircularSlider.h"

@interface SURHeaterSettingtemperatureViewController ()

@property (weak, nonatomic) IBOutlet UICircularSlider *circularSlider;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (strong, nonatomic) GizSDKCommunicateService * service;

@end

@implementation SURHeaterSettingtemperatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.service = [[SURCommonService alloc] init];
    self.circularSlider.transform = CGAffineTransformMakeRotation(M_PI);
    [self.circularSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventValueChanged];
    self.circularSlider.minimumTrackTintColor = [UIColor colorWithRed:255/255.0 green:200/255.0 blue:63/255.0 alpha:1];
    self.circularSlider.maximumTrackTintColor = [UIColor colorWithRed:135/255.0 green:197/255.0 blue:207/255.0 alpha:1];
    self.circularSlider.thumbTintColor        = [UIColor colorWithRed:255/255.0 green:200/255.0 blue:63/255.0 alpha:1];
    self.circularSlider.minimumValue = 30;
    self.circularSlider.maximumValue = 75;
    self.circularSlider.sliderStyle = UICircularSliderStyleCircle;
    self.circularSlider.continuous = NO;
    self.temperatureLabel.text = [NSString stringWithFormat:@"30"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisconnected) name:SUR_NOTIFICATION_DISCONNECT object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SUR_NOTIFICATION_DISCONNECT object:nil];
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

/* 保存按钮响应 */
- (IBAction)saveButtonAction:(id)sender {
    NSError *err;
    NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:self.temperatureLabel.text,@"Pre_Temp", nil];
    NSDictionary *myClassDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"Heat", nil];
    
    [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
    if (_isHot)
    {
        [self.service sendToControlWithEntity0:myClassDic target:self device:self.selectedDevice error:&err];

    }
    [self.navigationController popViewControllerAnimated:YES];
}

/* 返回按钮响应 */
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateProgress:(UISlider *)sender {
    int value = sender.value;
    
    self.temperatureLabel.text = [NSString stringWithFormat:@"%d",value];
}

#pragma mark XPG delegate
- (void)XPGWifiDevice:(XPGWifiDevice *)device didReceiveData:(NSDictionary *)data result:(int)result
{
    [SURCommonUtils hideLoading];
//    [self.service readDataPoint:data productKey:device.productKey completion:^(SURWaterHeaterProductDataPointModel *model, NSArray *alerts, NSArray *faults) {
//        self.temperatureLabel.text = model.Pre_Temp;
//        [self.circularSlider setValue:[model.Pre_Temp intValue]];
//    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
