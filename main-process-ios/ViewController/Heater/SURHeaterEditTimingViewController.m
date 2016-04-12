//
//  SURHeaterEditTimingViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 9/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURHeaterEditTimingViewController.h"

@interface SURHeaterEditTimingViewController ()
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

// 数据
@property (strong, nonatomic) NSString *temperatureValue;
@property (strong, nonatomic) NSString *startTimeValue;

// 获取的数据标识点
@property (strong, nonatomic) NSString *identificationTime;
@property (strong, nonatomic) NSString *identificationTemperature;

@end

@implementation SURHeaterEditTimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pickerViewArray = [[NSMutableArray alloc]init];
    for(int i=0; i<=99; i++){
        [self.pickerViewArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.navigationItem.title = @"编辑定时";
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,25)];
    [rightButton setImage:[UIImage imageNamed:@"icon_ok.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self changeMode:SURHeaterEditTimingNone];
    [self.pickerView selectRow:45 inComponent:0 animated:NO];
    self.temperatureValue = @"45";
    self.startTimeValue   = @"0";
}

// 保存按钮响应
-(void)saveButtonAction{
    
}

// 模式转换
-(void)changeMode:(SURHeaterAddTimingMode)mode{
    switch (mode) {
        case SURHeaterEditTimingDatePicker:
            [self.pickerView setHidden:YES];
            [self.datePicker setHidden:NO];
            [self.lineView   setHidden:NO];
            break;
        case SURHeaterEditTimingPickerView:
            [self.pickerView setHidden:NO];
            [self.datePicker setHidden:YES];
            [self.lineView   setHidden:NO];
            break;
        case SURHeaterEditTimingNone:
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
        [self changeMode:SURHeaterEditTimingPickerView];
    }else{
        [self changeMode:SURHeaterEditTimingNone];
    }
    isSelectedTargetTemperature = !isSelectedTargetTemperature;
    isSelectedStartTime = NO;
}

// 开始时间按钮响应
- (IBAction)startTimeButtonAction:(id)sender {
    if(!isSelectedStartTime)
    {
        [self changeMode:SURHeaterEditTimingDatePicker];
    }else{
        [self changeMode:SURHeaterEditTimingNone];
    }
    isSelectedStartTime = !isSelectedStartTime;
    isSelectedTargetTemperature = NO;
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    self.timeLabel.text = [dateFormatter stringFromDate:select];
    
    NSDateFormatter *dateFormatterHour = [[NSDateFormatter alloc] init];
    [dateFormatterHour setDateFormat:@"HH"];
    NSString *hourValue = [dateFormatterHour stringFromDate:select];
    
    NSDateFormatter *dateFormatterMinute = [[NSDateFormatter alloc] init];
    [dateFormatterMinute setDateFormat:@"mm"];
    NSString *minuteValue = [dateFormatterMinute stringFromDate:select];
    if([hourValue intValue] * 24 == 0){
        
    }
    self.startTimeValue = [NSString stringWithFormat:@"%d",[hourValue intValue] * 24 + [minuteValue intValue] * 24];
    
}

// 删除按钮响应
- (IBAction)deleteButtonAction:(id)sender {
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
