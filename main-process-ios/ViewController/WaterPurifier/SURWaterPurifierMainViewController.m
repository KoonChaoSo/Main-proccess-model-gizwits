//
//  SURWaterPurifierMainViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 30/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURWaterPurifierMainViewController.h"
#import "SURExceptionDetailsViewController.h"
#import "GizSDKCommunicateService.h"
#import "SURProductDataPointModel.h"
#import "SURAlertView.h"
#import "SURCommonUtils.h"
#import "SURErrorView.h"
#import "SURFilterDetailsViewController.h"
#import "FLDemoView.h"
#import "WaterWaveView.h"


@interface SURWaterPurifierMainViewController (){
    // flag
    BOOL isPowerOff;
    BOOL isWash;
    BOOL isHeat;
    BOOL isRefrigeration;
    BOOL isChild_Lock;
    BOOL isRawWater;
    BOOL isWarm;
    //alert && fault
    NSArray *mAlert;
    NSArray *mFault;
    
    //filter number
    NSInteger numberInfilterChangeWarning;
    
    ////////////
    int pureWaterfdsNumber;
    int rawWaterfdsNumber;
    //////////
    int warmWaterTemperature;
    int hotWaterTemperature;
}

@property (strong, nonatomic) GizSDKCommunicateService * service;
@property (strong, nonatomic) FLDemoView *fd;


// 背景动画View
@property (strong, nonatomic) IBOutlet UIView *moveBackgroundView;
// 正常状态View
@property (weak, nonatomic) IBOutlet UIView *regularView;
// 异常状态View
@property (weak, nonatomic) IBOutlet SURErrorView *exceptionView;
// 关机状态View
@property (weak, nonatomic) IBOutlet UIView *powerOffView;

///////////////////////////  正常状态下控件  /////////////////////////
// 状态字(满水等)
@property (weak, nonatomic) IBOutlet UILabel *regularStatusLabel;
// 状态图片(满水等)
@property (weak, nonatomic) IBOutlet UIImageView *regularStatusImageView;

// TDS的值
@property (weak, nonatomic) IBOutlet UILabel *tdsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tdTitle;

// 当前热水的值
@property (weak, nonatomic) IBOutlet UILabel *waterTemperatureLabel;
//水温标题
@property (weak, nonatomic) IBOutlet UILabel *waterTemperatureName;
@property (weak, nonatomic) IBOutlet UILabel *labelDrinkAble;
@property (weak, nonatomic) IBOutlet UIView *waterWaveView;
@property (strong, nonatomic) WaterWaveView *firstWaterView;
@property (strong, nonatomic) WaterWaveView *secondWaterView;

@property (strong, nonatomic) UIImageView *buddleImageView;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;


// 原水水质的值
@property (weak, nonatomic) IBOutlet UILabel *originalWaterQualityLabel;
// 上次净水量
@property (weak, nonatomic) IBOutlet UILabel *lastCleanWaterYieldLbel;

@property (weak, nonatomic) IBOutlet UILabel *filterStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *washButton;
@property (weak, nonatomic) IBOutlet UIButton *heatButton;
@property (weak, nonatomic) IBOutlet UIButton *child_LockButton;
@property (weak, nonatomic) IBOutlet UIButton *refrigerationButton;
@end

static GizSDKCommunicateService *service = nil;

@implementation SURWaterPurifierMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.service = [[SURCommonService alloc] init];
    self.exceptionView.delegate = self;
    
    self.fd = [[FLDemoView alloc] initWithWaterPurifierFlash];
    [self.moveBackgroundView addSubview:self.fd];
    
    self.firstWaterView = [[WaterWaveView alloc]initWithFrame:self.view.bounds withPeak:1.5 withSpeed:0.08 withColor:[UIColor colorWithRed:28/255.f green:146/255.f blue:188/255.f alpha:1] withOffset:20];
    self.secondWaterView = [[WaterWaveView alloc]initWithFrame:self.view.bounds withPeak:2 withSpeed:0.04 withColor:[UIColor colorWithRed:32/255.f green:196/255.f blue:212/255.f alpha:1] withOffset:50];
    
    [self.waterWaveView addSubview:self.firstWaterView];
    [self.waterWaveView addSubview:self.secondWaterView];
    
    self.buddleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width/2-150, kScreen_Height, 300, 389)];
    self.buddleImageView.image = [UIImage imageNamed:@"bubble"];
    [self.bubbleView addSubview:self.buddleImageView];
    
    [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(displayBubble) userInfo:@"nil" repeats:YES];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#warning 滤芯状态(暂时设为空)
    self.filterStatusLabel.text = @"";
    [self changewaterPurifierModel:regular];
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisconnected) name:SUR_NOTIFICATION_DISCONNECT object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SURCommonUtils hideLoading];
    self.selectedDevice.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SUR_NOTIFICATION_DISCONNECT object:nil];
    
    
}

#pragma mark - 净水器状态转换方法
-(void)changewaterPurifierModel:(waterPurifierModel) model{
    switch (model) {
        // 正常状态
        case regular:
            [self.regularView   setHidden:NO];
            [self.exceptionView setHidden:YES];
            break;
            
        // 异常状态
        case irregular:
#warning  标记将regularview 显示出来
            [self.regularView   setHidden:NO];
            [self.exceptionView setHidden:NO];
            break;
            
        default:
            break;
    }
}

#pragma mark -  滤芯状态按钮响应
- (IBAction)filterStatusButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"toFilter" sender:self];
}


#pragma mark - 净水量按钮响应
- (IBAction)cleanWaterYieldButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"toChartView" sender:nil];
}

#pragma mark - 关机按钮响应
- (IBAction)powerOffButtonAction:(id)sender {
    NSError *err;
    NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"1",@"Switch",nil];
    [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
//    [self changewaterPurifierModel:regular];
    [self.powerOffView  setHidden:YES];
}

#pragma mark - navigation上面的关机按钮（不需要操作）
- (IBAction)onPowerOff:(id)sender {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温謦提示" message:@"是否确定关机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alter show];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

///////////////////////// 四种状态触发 ///////////////////////////
#pragma mark - 冲洗按钮响应
- (IBAction)washButtonAction:(id)sender {
    NSError *err;
    if (isWash == NO) {
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"0",@"Wash",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        self.washButton.selected = NO;
        isWash = YES;
    }else{
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"1",@"Wash",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        self.regularStatusLabel.text = @"冲洗";
        self.washButton.selected = YES;
        isWash = NO;
    }
}

#pragma mark - 制热按钮响应
- (IBAction)heatButtonAction:(id)sender {
    NSError *err;
    if(isHeat == NO)
    {
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"0",@"Heat",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        self.heatButton.selected = NO;
        isHeat = YES;
    }else{
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"1",@"Heat",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        self.heatButton.selected = YES;
        isHeat = NO;
    }
}

#pragma mark - 制冷按钮响应
- (IBAction)freezeButtonAction:(id)sender {
    NSError *err;
    if(isRefrigeration == NO)
    {
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"0",@"Refrigeration",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        self.refrigerationButton.selected= NO;
        isRefrigeration = YES;
    }else{
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"1",@"Refrigeration",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        NSLog(@"Send Switch Open");
        self.refrigerationButton.selected = YES;
        isRefrigeration = NO;
    }
}

#pragma mark - 童锁按钮响应
- (IBAction)childLockButtonAction:(id)sender {
    NSError *err;
    if(isChild_Lock == NO)
    {
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"0",@"Child_Lock",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        self.child_LockButton.selected = NO;
        isChild_Lock = YES;
    }
    else
    {
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"1",@"Child_Lock",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        NSLog(@"Send Switch Open");
        self.child_LockButton.selected = YES;
        isChild_Lock = NO;
    }
}

#pragma mark - alterView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [SURCommonUtils showLoadingWithTile:@"正在关机..."];
        NSError *err;
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"0",@"Switch",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        [self.powerOffView  setHidden:NO];
        [SURCommonUtils hideLoading];
    }
}

#pragma mark XPG delegate
- (void)XPGWifiDevice:(XPGWifiDevice *)device didReceiveData:(NSDictionary *)data result:(int)result
{
    [SURCommonUtils hideLoading];
//    [self.service readDataPoint:data productKey:device.productKey completion:^(SURProductDataPointModel *model, NSArray *alerts, NSArray *faults) {
//        
//        pureWaterfdsNumber = [model.Pure_Water_TDS intValue];
//        rawWaterfdsNumber  = [model.Raw_Water_TDS intValue];
//        warmWaterTemperature = model.Warm_Water_Temp.intValue;
//        hotWaterTemperature = model.Hot_Water_Temp.intValue;
//        
//        [self changewaterPurifierModel:regular];
//        // 开关
//        if([model.Switch isEqual:@"0"]){
//            NSLog(@"Switch OFF");
//            [self.powerOffView  setHidden:NO];
//            [SURCommonUtils hideLoading];
//        }else{
//            NSLog(@"Switch ON");
//            [self.powerOffView  setHidden:YES];
//            [self changewaterPurifierModel:regular];
//        }
//        //
//        if ([model.Wash isEqual:@"0"]) {
//            self.washButton.selected = NO;
//            isWash = YES;
//        }else{
//            self.washButton.selected = YES;
//            isWash = NO;
//        }
//        //
//        if ([model.Heat isEqual:@"0"]) {
//            self.heatButton.selected = NO;
//            isHeat = YES;
//        }else{
//            self.heatButton.selected = YES;
//            isHeat = NO;
//        }
//        //
//        if ([model.Child_Lock isEqual:@"0"]) {
//            self.child_LockButton.selected = NO;
//            isChild_Lock = YES;
//        }else{
//            self.child_LockButton.selected = YES;
//            isChild_Lock = NO;
//        }
//        if ([model.Refrigeration isEqual:@"0"]) {
//            self.refrigerationButton.selected = NO;
//            isRefrigeration = YES;
//        }else{
//            self.refrigerationButton.selected = YES;
//            isRefrigeration = NO;
//        }
//        numberInfilterChangeWarning = 0;
//        NSString *cartridge = @"正常";
//        if ([model.Cartridge_Life_1 intValue] < 10)
//        {
//            numberInfilterChangeWarning = 1;
//            //cartridge = @"第一个滤芯需更换";
//        }
//        if ([model.Cartridge_Life_2 intValue] < 10)
//        {
//            numberInfilterChangeWarning = 2;
//            //cartridge = @"第二个滤芯需更换";
//        }
//        if ([model.Cartridge_Life_3 intValue] < 10)
//        {
//            numberInfilterChangeWarning = 3;
//            //cartridge = @"第三个滤芯需更换";
//        }
//        if ([model.Cartridge_Life_4 intValue] < 10)
//        {
//            numberInfilterChangeWarning = 4;
//            //cartridge = @"第四个滤芯需更换";
//        }
//        if ([model.Cartridge_Life_5 intValue] < 10)
//        {
//            numberInfilterChangeWarning = 5;
//            //cartridge = @"第五个滤芯需更换";
//        }
//        if(numberInfilterChangeWarning != 0){
//            cartridge = @"有滤芯到期";
//            self.filterStatusLabel.textColor = [UIColor colorWithRed:252/255.0 green:247/255.0 blue:54/255.0 alpha:1];
//        }else{
//            self.filterStatusLabel.textColor = RGB(121, 234, 58);
//            
//        }
//        self.filterStatusLabel.text = cartridge;
//
//        
//        switch ([model.Mode integerValue]) {
//            case 0:
//            {
//                self.regularStatusImageView.image = [UIImage imageNamed:@"water_stats_none"];
//                self.regularStatusLabel.text = @"缺水";
//                break;
//            }
//            case 1:
//            {
//                self.regularStatusImageView.image = [UIImage imageNamed:@"water_stats_full"];
//                self.regularStatusLabel.text = @"满水";
//                break;
//            }
//            case 2:
//            {
//                self.regularStatusImageView.image = [UIImage imageNamed:@"water_stats_zhishui"];
//                self.regularStatusLabel.text = @"制水";
//                break;
//            }
//            case 3:
//            {
//                self.regularStatusImageView.image = [UIImage imageNamed:@"water_stats_clean"];
//                self.regularStatusLabel.text = @"冲洗";
//            }
//            default:
//                break;
//        }
//        
//        if(!self.selectedDevice.isOnline)
//            return;
//        
//        self.exceptionView.errorArray = faults;
//        self.exceptionView.alertArray = alerts;
//        self.exceptionView.colorForError = [UIColor yellowColor];
//        self.exceptionView.errorImageName = @"home_icon_tip";
//        [self.exceptionView showList];
//        if (self.exceptionView.errorArray.count > 0 || self.exceptionView.alertArray.count > 0)
//        {
//            [self.exceptionView showList];
//            [self changewaterPurifierModel:irregular];
//        }
//        
//        [self configureFDS];
//        [self configureTemperatureForWater];
//    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *viewController = segue.destinationViewController;
    
    if ([viewController isKindOfClass:[SURFilterDetailsViewController class]])
    {
        SURFilterDetailsViewController *filterVC = segue.destinationViewController;
        filterVC.selectedDevice = self.selectedDevice;
        filterVC.selectSerial = numberInfilterChangeWarning;
    }
    else if ([viewController isKindOfClass:[SURExceptionDetailsViewController class]])
    {
        SURExceptionDetailsViewController *detailVc = segue.destinationViewController;
        detailVc.exceptionTitle = (NSString *)sender;
    }
    
}

-(void)clickErrorList:(SURErrorView *)view name:(NSString *)name
{
    [self performSegueWithIdentifier:@"toException" sender:name];
}

-(void)configureFDS
{
    if (!isRawWater)
    {
        self.tdsLabel.text = [NSString stringWithFormat:@"%d",pureWaterfdsNumber];
        self.tdTitle.text = @"纯水\n水质\nTDS";
        self.labelDrinkAble.text = @"可饮用";
    }
    else
    {
        self.tdsLabel.text = [NSString stringWithFormat:@"%d",rawWaterfdsNumber];
        self.tdTitle.text = @"原水\n水质\nTDS";
        self.labelDrinkAble.text = @"可饮用";
    }
}
-(void)configureTemperatureForWater
{
    if (!isWarm)
    {
        self.waterTemperatureLabel.text = [NSString stringWithFormat:@"%d",hotWaterTemperature];
        self.waterTemperatureName.text = @"热水水温";
    }
    else
    {
        self.waterTemperatureLabel.text = [NSString stringWithFormat:@"%d",warmWaterTemperature];
        self.waterTemperatureName.text = @"温水水温";
    }

}

- (IBAction)onChangeRawAndPure:(id)sender {
    isRawWater = !isRawWater;
    [self configureFDS];
}

- (IBAction)onChangeWarmAndHot:(id)sender {
    isWarm = !isWarm;
    [self configureTemperatureForWater];
}


-(void)displayBubble{
    self.buddleImageView.center = CGPointMake(self.buddleImageView.center.x,kScreen_Height-100);
    [UIView animateWithDuration:2.f animations:^{
        self.buddleImageView.center = CGPointMake(self.buddleImageView.center.x,-389);
    }];
}



@end
