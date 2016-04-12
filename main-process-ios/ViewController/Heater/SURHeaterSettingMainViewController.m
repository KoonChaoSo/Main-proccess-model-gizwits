//
//  SURHeaterSettingMainViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 8/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURHeaterSettingMainViewController.h"
#import "SURHeaterSettingMainTableViewCell.h"
#import "SURCommonUtils.h"
#import "SURWaterHeaterProductDataPointModel.h"
#import "SURHeaterAddTimingViewController.h"
#import "SURHeaterAddInfraredDetectionViewController.h"
#import "SURHeaterEditInfraredDetectionViewController.h"
#import "SURDefaultTempTableViewCell.h"
#import "SURHeaterSettingtemperatureViewController.h"

@interface SURHeaterSettingMainViewController ()

@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *timingSource;
@property (strong, nonatomic) NSArray *infraredDetectionSource;
@property (strong, nonatomic) NSArray *arraySource;
@property (strong, nonatomic) NSArray *arraySource2;

@property (assign, nonatomic) BOOL infraredDetectionAddImageFlag;
@property (strong, nonatomic) NSString *infraredDetectionSendStartTimeName;
@property (strong, nonatomic) NSString *infraredDetectionSendEndTimeName;
@property (strong, nonatomic) NSString *infraredDetectionSendSetName;

@property (strong, nonatomic) NSString *preTemp;
@property (strong, nonatomic) NSString *textForCellName;
@end


@implementation SURHeaterSettingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  = NO;
    self.navigationItem.title = @"设置";
    
    self.arraySource = @[];

    //self.infraredDetectionSource = @[@[@"14:00-17:00", @"identificationName",@"identificationName",@"1"],@[@"12:00-14:00", @"identificationName",@"identificationName",@"0"],@[@"16:00-19:00", @"identificationName",@"identificationName",@"1"]];
//    self.timingSource = @[@[@"45℃", @"08:100", @"identificationName1",@"identificationName2",@"YES"],@[@"80℃", @"10:20", @"identificationName1",@"identificationName2",@"NO"]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisconnected) name:SUR_NOTIFICATION_DISCONNECT object:nil];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SUR_NOTIFICATION_DISCONNECT object:nil];
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    return 3;
}

//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.timingSource.count+1;
    }else if (section==1) {
        return self.infraredDetectionSource.count+1;
    }else{
        return 1;
    }
}
//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

/* 每个项的高度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 && indexPath.row == 0){
        return 95;
    }
    return 60;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"selectedSettingTimingType";
    SURHeaterSettingMainTableViewCell *cell = (SURHeaterSettingMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"SURHeaterSettingMainTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifer];
        cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell changeCellMode:SURHeaterSettingMainCellSettingTimingTitle];
        cell.SURSettingTimingTitleViewTitle.text = @"定时设置";
    }else if(indexPath.section == 0){
        [cell changeCellMode:SURHeaterSettingMainCellSettingTimingContent];
        cell.SURSettingTimingContentViewTemperature.text = [[self.timingSource objectAtIndex:indexPath.row-1] objectAtIndex:0];
        cell.SURSettingTimingContentViewTime.text = [[self.timingSource objectAtIndex:indexPath.row-1] objectAtIndex:1];
        cell.SURSettingTimingContentViewSwitch.on = [[[self.timingSource objectAtIndex:indexPath.row - 1] objectAtIndex:4] boolValue];
        if (indexPath.row == 1)
        {
            cell.identificationName = @"Heat_TimeSwitch1";
        }
        else if (indexPath.row == 2)
        {
            cell.identificationName = @"Heat_TimeSwitch2";
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        [cell changeCellMode:SURHeaterSettingMainCellInfraredDetectionTitle];
        if(self.infraredDetectionAddImageFlag == YES){
            [cell.SURInfraredDetectionTitleViewAddImageView setHidden:NO];
        }else{
            [cell.SURInfraredDetectionTitleViewAddImageView setHidden:YES];
        }
    }
    else if( indexPath.section == 1 )
    {
        [cell changeCellMode:SURHeaterSettingMainCellInfraredDetectionContent];
        cell.SURInfraredDetectionContentViewTemperature.text = [[self.infraredDetectionSource objectAtIndex:indexPath.row-1] objectAtIndex:0];
        cell.identificationName = [[self.infraredDetectionSource objectAtIndex:indexPath.row-1] objectAtIndex:1];
        cell.SURInfraredDetectionContentViewSwitch.on = [[[self.infraredDetectionSource objectAtIndex:indexPath.row-1] objectAtIndex:2] boolValue];
    }
    else if (indexPath.section == 2)
    {
        static NSString *identifer = @"defaultTempCell";
        SURDefaultTempTableViewCell *cell = (SURDefaultTempTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifer];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:@"SURDefaultTempTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifer];
            cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.labelPreTemp.text = [NSString stringWithFormat:@"%@℃",_preTemp];
        cell.labelForText.text = _textForCellName;
        return cell;
    }
    cell.delegate = self;
    return cell;
}

-(void)selectedButtonReturnInfraredDetection:(UISwitch *)onOff identificationName:(NSString*)identificationName{
    NSLog(@"identificationName:%@ -> ",identificationName);
    NSDictionary *dic = @{identificationName:[NSString stringWithFormat:@"%d",!onOff.on]};
    NSError *err;
    [self.serviceForSDK sendToControlWithEntity0:dic target:self device:self.selectedDevice error:&err];
}

-(void)selectedButtonReturn:(UISwitch *)onOff identificationName:(NSString *)identificationName
{
    NSLog(@"identificationName:%@ -> ",identificationName);
    NSDictionary *dic = @{identificationName:[NSString stringWithFormat:@"%d",onOff.on]};
    NSError *err;
    [self.serviceForSDK sendToControlWithEntity0:dic target:self device:self.selectedDevice error:&err];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section == 0 && indexPath.row == 0){
//        [self performSegueWithIdentifier:@"toAddTiming" sender:nil];
//    }else
    if( indexPath.section == 0 && indexPath.row != 0){
        [self performSegueWithIdentifier:@"toAddTiming" sender:indexPath];
    }
    else if(indexPath.section == 1 && indexPath.row == 0){
        if(self.infraredDetectionAddImageFlag == YES){
            [self performSegueWithIdentifier:@"toAddInfraredDetection" sender:nil];
        }
    }else if( indexPath.section == 1 ){
        [self performSegueWithIdentifier:@"toEditInfraredDetection" sender:indexPath];
    }else if (indexPath.section == 2){
        [self pushSettingTemperatureViewController:NO];
    }
    // 取消选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    UIViewController *viewController = segue.destinationViewController;
    if ([viewController isKindOfClass:[SURHeaterAddTimingViewController class]])
    {
        ((SURHeaterAddTimingViewController *) viewController).tempValue = [[self.timingSource objectAtIndex:indexPath.row-1] objectAtIndex:0];
        ((SURHeaterAddTimingViewController *) viewController).dateValue = [[self.timingSource objectAtIndex:indexPath.row-1] objectAtIndex:1];
        
        ((SURHeaterAddTimingViewController *) viewController).appointmentTime = [[self.timingSource objectAtIndex:indexPath.row-1] objectAtIndex:2];
        ((SURHeaterAddTimingViewController *) viewController).appointmentTemp = [[self.timingSource objectAtIndex:indexPath.row-1] objectAtIndex:3];
    }
    else if ([viewController isKindOfClass:[SURHeaterAddInfraredDetectionViewController class]])
    {
        ((SURHeaterAddInfraredDetectionViewController *) viewController).infraredDetectionStartTimePoint = self.infraredDetectionSendStartTimeName;
        ((SURHeaterAddInfraredDetectionViewController *) viewController).infraredDetectionEndTimePoint = self.infraredDetectionSendEndTimeName;
        ((SURHeaterAddInfraredDetectionViewController *) viewController).infraredDetectionSetPoint = self.infraredDetectionSendSetName;
    }
    else if([viewController isKindOfClass:[SURHeaterEditInfraredDetectionViewController class]]){
        ((SURHeaterEditInfraredDetectionViewController *) viewController).appointmentSet      = [[self.infraredDetectionSource objectAtIndex:indexPath.row-1] objectAtIndex:1];
        ((SURHeaterEditInfraredDetectionViewController *) viewController).appointmentRunTime  = [[self.infraredDetectionSource objectAtIndex:indexPath.row-1] objectAtIndex:3];
        ((SURHeaterEditInfraredDetectionViewController *) viewController).appointmentStopTime = [[self.infraredDetectionSource objectAtIndex:indexPath.row-1] objectAtIndex:4];
    }
    else
    {
        self.navigationController.navigationBarHidden = YES;
    }
}

-(void)XPGWifiDevice:(XPGWifiDevice *)device didReceiveData:(NSDictionary *)data result:(int)result
{
    [SURCommonUtils hideLoading];
    [self.serviceForSDK readDataPoint:data completion:^(SURWaterHeaterProductDataPointModel *dataPointModel, NSArray *alerts, NSArray *faults) {
        
        NSMutableArray *timingMutableSource = [[NSMutableArray alloc] init];
        NSMutableArray *infraredMutableDetectionSource = [[NSMutableArray alloc] init];
        
        NSString *temp1 = [NSString stringWithFormat:@"%@℃",dataPointModel.Heat_Temp_1];
        NSString *temp2 = [NSString stringWithFormat:@"%@℃",dataPointModel.Heat_Temp2];
        
        NSString *infraredOnOff1 = dataPointModel.Heat_TimeSwitch1;
        NSString *infraredOnOff2 = dataPointModel.Heat_TimeSwitch2;
        _preTemp = dataPointModel.Pre_Temp;
        
        if ([dataPointModel.Heat isEqualToString:@"0"])
        {
            _textForCellName = @"预置温度";
        }
        else
        {
           
            _textForCellName = @"预热温度";
        }

        
        [timingMutableSource addObject:@[temp1,[self minToHourAndMin:dataPointModel.Heat_Time_1],@"Heat_Time_1",@"Heat_Temp_1",infraredOnOff1]];
        [timingMutableSource addObject:@[temp2,[self minToHourAndMin:dataPointModel.Heat_Time2],@"Heat_Time2",@"Heat_Temp2",infraredOnOff2]];
        self.timingSource = [timingMutableSource copy];
        
        self.infraredDetectionAddImageFlag = NO;
        for (int i = 0; i< 7; i++) {
            NSString *dataPointNameForStartTime  = [NSString stringWithFormat:@"IR_Alarm_Run_Time_%d",i+1];
            NSString *dataPointNameForEndTime    = [NSString stringWithFormat:@"IR_Alarm_Stop_Time_%d",i+1];
            NSString *dataPointNameForSet        = [NSString stringWithFormat:@"IR_AlarmSet%d",i+1];
            
            
            NSString *dataPointValueForStartTime = [dataPointModel valueForKey:dataPointNameForStartTime];
            NSString *dataPointValueForEndTime   = [dataPointModel valueForKey:dataPointNameForEndTime];
            NSString *dataPointValueForSet       = [dataPointModel valueForKey:dataPointNameForSet];
            
            NSString *dataPointValueForSwitch;
            
            if([dataPointValueForSet intValue] == 0){
                dataPointValueForSwitch = @"1";
            }else if([dataPointValueForSet intValue] == 1){
                dataPointValueForSwitch = @"0";
            }else{
                if(self.infraredDetectionAddImageFlag != YES)
                {
                    self.infraredDetectionSendStartTimeName = dataPointNameForStartTime;
                    self.infraredDetectionSendEndTimeName   = dataPointNameForEndTime;
                    self.infraredDetectionSendSetName       = dataPointNameForSet;
                    self.infraredDetectionAddImageFlag      = YES;
                }
                continue;
            }
            
            NSString *infraredDetectionStartTime = [self minToHourAndMin:dataPointValueForStartTime];
            NSString *infraredDetectionEndTime   = [self minToHourAndMin:dataPointValueForEndTime];
            
            NSString *timeForShow = [NSString stringWithFormat:@"%@-%@",infraredDetectionStartTime,infraredDetectionEndTime];
            
            [infraredMutableDetectionSource addObject:@[timeForShow,dataPointNameForSet,dataPointValueForSwitch,dataPointNameForStartTime,dataPointNameForEndTime]];
        }
        
        self.infraredDetectionSource = [infraredMutableDetectionSource copy];
        
        [self.tableView reloadData];
        
    }];
}

-(NSString *)minToHourAndMin:(NSString *)min
{
    int minInt = [min intValue];
    int hourResult = minInt / 60;
    int minResult = minInt % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",hourResult,minResult];
}

-(void)pushSettingTemperatureViewController:(BOOL)isHot{
    UIStoryboard *secondStroyBoard = [UIStoryboard storyboardWithName:@"SURHeater" bundle:nil];
    SURHeaterSettingtemperatureViewController *heaterSetTempVC = [secondStroyBoard instantiateViewControllerWithIdentifier:@"toSettingTemperature"];
    heaterSetTempVC.selectedDevice = self.selectedDevice;
    heaterSetTempVC.isHot = isHot;
    [self.navigationController pushViewController:heaterSetTempVC animated:YES];
}
@end
