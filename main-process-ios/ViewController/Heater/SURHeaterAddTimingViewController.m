//
//  SURHeaterAddTimingViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 9/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURHeaterAddTimingViewController.h"
#import "SURUtils.h"

@interface SURHeaterAddTimingViewController ()
{
    BOOL isSelectedTargetTemperature;
    BOOL isSelectedStartTime;
}

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSMutableArray *pickerViewArray;

@property (strong, nonatomic) NSString *temperatureValue;
@property (strong, nonatomic) NSString *startTimeValue;

@property (assign, nonatomic) NSInteger myHour;
@property (assign, nonatomic) NSInteger myMinutes;
// 数据


@end

@implementation SURHeaterAddTimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.temperatureValue = self.tempValue;
    self.startTimeValue = self.dateValue;
    
    [self configureTimeLabel:[self stringToDate:self.dateValue]];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@",self.temperatureValue];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SURCommonUtils hideLoading];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [SURCommonUtils hideLoading];
    self.navigationController.navigationBarHidden = YES;
       [[NSNotificationCenter defaultCenter] removeObserver:self name:SUR_NOTIFICATION_DISCONNECT object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pickerViewArray = [[NSMutableArray alloc]init];
    for(int i=30; i<=75; i++){
        [self.pickerViewArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.navigationItem.title = @"添加定时";
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,25)];
    [rightButton setImage:[UIImage imageNamed:@"icon_ok.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self changeMode:SURHeaterAddTimingNone];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisconnected) name:SUR_NOTIFICATION_DISCONNECT object:nil];
    
    self.navigationController.navigationBarHidden = NO;

    
}


// 保存按钮响应
-(void)saveButtonAction{
    NSError *err;
    NSDictionary *sendDic = @{_appointmentTemp:@([_temperatureValue intValue]) , _appointmentTime : @([_startTimeValue intValue])};
    [self.serviceForSDK sendToControlWithEntity0:sendDic target:self device:self.selectedDevice error:&err];
    [self popToHeaterSettingView];
}

// 模式转换
-(void)changeMode:(SURHeaterAddTimingMode)mode{
    switch (mode) {
        case SURHeaterAddTimingDatePicker:
            [self.pickerView setHidden:YES];
            [self.datePicker setHidden:NO];
            [self.lineView   setHidden:NO];
            break;
        case SURHeaterAddTimingPickerView:
            [self.pickerView setHidden:NO];
            [self.datePicker setHidden:YES];
            [self.lineView   setHidden:NO];
            break;
        case SURHeaterAddTimingNone:
            [self.pickerView setHidden:YES];
            [self.datePicker setHidden:YES];
            [self.lineView   setHidden:YES];
        default:
            break;
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.pickerViewArray objectAtIndex:row];
    } else {
        return [self.pickerViewArray objectAtIndex:row];
        
    }
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.pickerViewArray count];
    }
    
    return [self.pickerViewArray count];
}

// 目标温度按钮响应
- (IBAction)targetTemperatureButtonAction:(id)sender {
    if(!isSelectedTargetTemperature)
    {
        [self changeMode:SURHeaterAddTimingPickerView];
    }else{
        [self changeMode:SURHeaterAddTimingNone];
    }
    isSelectedTargetTemperature = !isSelectedTargetTemperature;
    isSelectedStartTime = NO;

    [self.pickerView selectRow:[self.temperatureValue intValue] - 30 inComponent:0 animated:NO];
}

// 开始时间按钮响应
- (IBAction)startTimeButtonAction:(id)sender {
    if(!isSelectedStartTime)
    {
        [self changeMode:SURHeaterAddTimingDatePicker];
    }else{
        [self changeMode:SURHeaterAddTimingNone];
    }
    isSelectedStartTime = !isSelectedStartTime;
    isSelectedTargetTemperature = NO;
    
    [self.datePicker setDate:[self stringToDate:self.dateValue] animated:NO];
    
}

// pickerView选择响应
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.temperatureValue = [self.pickerViewArray objectAtIndex:row];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@℃",self.temperatureValue];
}

// datePicker选择响应
- (IBAction)datePick:(id)sender {
    NSDate *select  = [self.datePicker date];
    [self configureTimeLabel:select];
}

-(void)configureTimeLabel:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    
    NSDateFormatter *dateFormatterHour = [[NSDateFormatter alloc] init];
    [dateFormatterHour setDateFormat:@"HH"];
    NSString *hourValue = [dateFormatterHour stringFromDate:date];
    
    NSDateFormatter *dateFormatterMinute = [[NSDateFormatter alloc] init];
    [dateFormatterMinute setDateFormat:@"mm"];
    NSString *minuteValue = [dateFormatterMinute stringFromDate:date];

    self.timeLabel.text = [formatter stringFromDate:date];
    
    self.myHour = [hourValue intValue];
    self.myMinutes = [minuteValue intValue];
    self.startTimeValue = [NSString stringWithFormat:@"%d",[hourValue intValue] * 60 + [minuteValue intValue]];
}

-(NSDate *)stringToDate:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    return [formatter dateFromString:dateString];
}


-(void)popToHeaterSettingView
{
     [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 2)] animated:YES];
}


@end
