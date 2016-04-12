//
//  SURHeaterAddInfraredDetectionViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 10/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURHeaterAddInfraredDetectionViewController.h"

@interface SURHeaterAddInfraredDetectionViewController ()

@property (strong, nonatomic) IBOutlet UIDatePicker *startTimeDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *endTimeDatePicker;

// 数据
@property (strong, nonatomic) NSString *startTimeValue;
@property (strong, nonatomic) NSString *endTimeValue;
@end

@implementation SURHeaterAddInfraredDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SURCommonUtils hideLoading];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"添加红外安全检测";
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,25)];
    [rightButton setImage:[UIImage imageNamed:@"icon_ok.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisconnected) name:SUR_NOTIFICATION_DISCONNECT object:nil];
    
    [self.startTimeDatePicker setDate:[self stringToDate:@"00:00"] animated:NO];
    [self.endTimeDatePicker   setDate:[self stringToDate:@"00:00"] animated:NO];
    
    self.startTimeValue = @"0";
    self.endTimeValue   = @"0";
}

-(NSDate *)stringToDate:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter dateFromString:dateString];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SUR_NOTIFICATION_DISCONNECT object:nil];
}

// 保存按钮响应
-(void)saveButtonAction{
    if([self.endTimeValue isEqual:self.startTimeValue])
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温謦提示" message:@"开始和结束时间不能相同" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return ;
    }else{
        NSError *err;
        NSDictionary *sendDic = @{_infraredDetectionEndTimePoint:_endTimeValue , _infraredDetectionStartTimePoint : _startTimeValue};
        NSDictionary *sendDicSet = @{_infraredDetectionSetPoint:@"1"};
        [self.serviceForSDK sendToControlWithEntity0:sendDic target:self device:self.selectedDevice error:&err];
        [self.serviceForSDK sendToControlWithEntity0:sendDicSet target:self device:self.selectedDevice error:&err];
        [self popToHeaterSettingView];
    }
}

// 开始时间响应
- (IBAction)startTimeDatePickerAction:(id)sender {
    NSDate *select  = [self.startTimeDatePicker date];
    self.startTimeValue = [self configareTimeValue:select];
}

// 结束时间响应
- (IBAction)endTimeDatePickerAction:(id)sender {
    NSDate *select  = [self.endTimeDatePicker date];
    
    self.endTimeValue = [self configareTimeValue:select];
}

-(NSString *)configareTimeValue:(NSDate *)date
{
    NSDateFormatter *dateFormatterHour = [[NSDateFormatter alloc] init];
    [dateFormatterHour setDateFormat:@"HH"];
    NSString *hourValue = [dateFormatterHour stringFromDate:date];
    
    NSDateFormatter *dateFormatterMinute = [[NSDateFormatter alloc] init];
    [dateFormatterMinute setDateFormat:@"mm"];
    NSString *minuteValue = [dateFormatterMinute stringFromDate:date];
    
    return [NSString stringWithFormat:@"%d",[hourValue intValue] * 60 + [minuteValue intValue]];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

-(void)popToHeaterSettingView
{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 2)] animated:YES];
}
@end
