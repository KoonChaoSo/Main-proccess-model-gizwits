//
//  SURHeaterEditInfraredDetectionViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 10/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURHeaterEditInfraredDetectionViewController.h"
#import "SURCommonUtils.h"
#import "SURWaterHeaterProductDataPointModel.h"
#import "CommonAlertViewController.h"

@interface SURHeaterEditInfraredDetectionViewController ()<CommonAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *startTimeDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *endTimeDatePicker;

// 数据
@property (strong, nonatomic) NSString *startTimeValue;
@property (strong, nonatomic) NSString *endTimeValue;

//弹出框
@property (strong, nonatomic) CommonAlertViewController *alerViewController;
@end

/* 设置picker的日期
 *
 * [datePicker setDate:[NSDate date]];
 *
 */

@implementation SURHeaterEditInfraredDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"编辑红外安全检测";
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,25)];
    [rightButton setImage:[UIImage imageNamed:@"icon_ok.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisconnected) name:SUR_NOTIFICATION_DISCONNECT object:nil];
    
    self.startTimeValue = @"0";
    self.endTimeValue   = @"0";
    
    [self.startTimeDatePicker setDate:[self stringToDate:[self minToHourAndMin: self.startTimeValue]] animated:NO];
    [self.endTimeDatePicker   setDate:[self stringToDate:[self minToHourAndMin:self.endTimeValue]] animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SUR_NOTIFICATION_DISCONNECT object:nil];
}

// 保存按钮响应
-(void)saveButtonAction{
    if([self.endTimeValue isEqual:self.startTimeValue])
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温謦提示" message:@"开始和结束时间不能相同" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }else{
        NSError *err;
        NSDictionary *sendDic = @{_appointmentRunTime:@([_startTimeValue intValue]) , _appointmentStopTime : @([_endTimeValue intValue])};
        [self.serviceForSDK sendToControlWithEntity0:sendDic target:self device:self.selectedDevice error:&err];
        [self popToHeaterSettingView];
    }
}

// 开始时间响应
- (IBAction)startTimeDatePickerAction:(id)sender {
    NSDate *select  = [self.startTimeDatePicker date];
    
    NSDateFormatter *dateFormatterHour = [[NSDateFormatter alloc] init];
    [dateFormatterHour setDateFormat:@"HH"];
    NSString *hourValue = [dateFormatterHour stringFromDate:select];
    
    NSDateFormatter *dateFormatterMinute = [[NSDateFormatter alloc] init];
    [dateFormatterMinute setDateFormat:@"mm"];
    NSString *minuteValue = [dateFormatterMinute stringFromDate:select];
    
    self.startTimeValue = [NSString stringWithFormat:@"%d",[hourValue intValue] * 60 + [minuteValue intValue]];
}

// 结束时间响应
- (IBAction)endTimeDatePickerAction:(id)sender {
    NSDate *select  = [self.endTimeDatePicker date];
    
    NSDateFormatter *dateFormatterHour = [[NSDateFormatter alloc] init];
    [dateFormatterHour setDateFormat:@"HH"];
    NSString *hourValue = [dateFormatterHour stringFromDate:select];
    
    NSDateFormatter *dateFormatterMinute = [[NSDateFormatter alloc] init];
    [dateFormatterMinute setDateFormat:@"mm"];
    NSString *minuteValue = [dateFormatterMinute stringFromDate:select];
    
    self.endTimeValue = [NSString stringWithFormat:@"%d",[hourValue intValue] * 60 + [minuteValue intValue]];
}

// 删除按钮响应
- (IBAction)deleteButtonAction:(id)sender {
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温謦提示" message:@"是否确定删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//    [alter show];
    
    self.alerViewController = [[CommonAlertViewController alloc] init];
    [self.alerViewController showWithContent:@"是否确定删除" title:@"温謦提示" delegate:self];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)
    {
        [SURCommonUtils showLoadingWithTile:@"正在删除..."];
        NSError *err;
        NSDictionary *sendDic = @{_appointmentRunTime:@(0) , _appointmentStopTime : @(0), _appointmentSet:@"2" };
        [self.serviceForSDK sendToControlWithEntity0:sendDic target:self device:self.selectedDevice error:&err];
        [self popToHeaterSettingView];
    }
}

-(void)XPGWifiDevice:(XPGWifiDevice *)device didReceiveData:(NSDictionary *)data result:(int)result
{
    [SURCommonUtils hideLoading];
//    [self.serviceForSDK readDataPoint:data productKey:device.productKey completion:^(SURWaterHeaterProductDataPointModel *dataPointModel, NSArray *alerts, NSArray *faults) {
//        self.startTimeValue = [dataPointModel valueForKey:self.appointmentRunTime];
//        self.endTimeValue   = [dataPointModel valueForKey:self.appointmentStopTime];
//        
//    }];
    [self.startTimeDatePicker setDate:[self stringToDate:[self minToHourAndMin: self.startTimeValue]] animated:NO];
    [self.endTimeDatePicker   setDate:[self stringToDate:[self minToHourAndMin:self.endTimeValue]] animated:NO];
}

-(NSDate *)stringToDate:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter dateFromString:dateString];
}

-(NSString *)minToHourAndMin:(NSString *)min
{
    int minInt = [min intValue];
    int hourResult = minInt / 60;
    int minResult = minInt % 60;
    
    return [NSString stringWithFormat:@"%d:%d",hourResult,minResult];
}

-(void)popToHeaterSettingView
{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 2)] animated:YES];
}

-(void)commonAlertView:(CommonAlertViewController *)commonAlertView
{
    [self.alerViewController hideAlertView];
    [SURCommonUtils showLoadingWithTile:@"正在删除..."];
    NSError *err;
    NSDictionary *sendDic = @{_appointmentRunTime:@(0) , _appointmentStopTime : @(0), _appointmentSet:@"2" };
    [self.serviceForSDK sendToControlWithEntity0:sendDic target:self device:self.selectedDevice error:&err];
    [self popToHeaterSettingView];
}

@end
