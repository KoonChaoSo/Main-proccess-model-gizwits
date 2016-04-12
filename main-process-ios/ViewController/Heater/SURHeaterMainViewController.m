//
//  SURHeaterMainViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 6/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURHeaterMainViewController.h"
#import "SURHeaterSettingtemperatureViewController.h"
#import "GizSDKCommunicateService.h"
#import "SURAlertView.h"
#import "SURCommonUtils.h"
#import "SURProductDataPointModel.h"
#import "SURWaterHeaterProductDataPointModel.h"
#import "SURErrorView.h"
#import "SURHeaterSettingMainViewController.h"
#import "SURHeaterExceptionDetailsViewController.h"
#import "ImagesCircleView.h"
#import "UIAlertView+SURUIAlertView.h"
#import "FLDemoView.h"
#import "WaterWaveView.h"

@interface SURHeaterMainViewController ()<UIAlertViewDelegate,SURErrorViewDelegate,ImagesCircleViewDelegate>{
    
    //alert && fault
    NSArray *mAlert;
    NSArray *mFault;
    
    /////////
    BOOL isStartAppointment;
    /////////
    BOOL afterOutputWarning;
}

////////////// 关机模式 /////////////
@property (weak, nonatomic) IBOutlet UIView       *powerOffTopMessagesView;
@property (weak, nonatomic) IBOutlet UILabel      *powerOffTopMessagesPeopleNumberLabel;
@property (weak, nonatomic) IBOutlet UIView       *powerOffButtonView;
@property (weak, nonatomic) IBOutlet UIView       *powerOffSettingModelView;
@property (weak, nonatomic) IBOutlet UIView       *powerOffOneSettingView;
@property (weak, nonatomic) IBOutlet UIView       *powerOffStatusView;

////////////// 正常模式 /////////////
@property (weak, nonatomic) IBOutlet UIView       *normalTopMessagesView;
@property (weak, nonatomic) IBOutlet UILabel      *normalTopMessagesPeopleNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel      *normalTopMessagesTempertureLabel;
@property (weak, nonatomic) IBOutlet UIView       *normalStatusView;
@property (weak, nonatomic) IBOutlet UILabel      *normalStatusLabel;
@property (weak, nonatomic) IBOutlet UIView       *normalTopStatusView;
@property (weak, nonatomic) IBOutlet UILabel      *normalTopStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView  *normalStatusImageView;
@property (weak, nonatomic) IBOutlet UIView       *normalFourSettingView;

@property (weak, nonatomic) IBOutlet UIButton     *timingButton;
@property (weak, nonatomic) IBOutlet UIButton     *ConservationButton;
@property (weak, nonatomic) IBOutlet UIButton     *constantTemperatureButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageIR;

@property (weak, nonatomic) IBOutlet UILabel *labelHeatText;

////////////// 异常模式 /////////////
@property (weak, nonatomic) IBOutlet SURErrorView *exceptionStatusView;
@property (weak, nonatomic) IBOutlet UILabel      *exceptionStatusLabel;

///////////// 其他 /////////////////
@property (weak, nonatomic) IBOutlet UIView       *infraredDetectionView;
@property (weak, nonatomic) IBOutlet UILabel      *currentTempertureLabel;
@property (weak, nonatomic) IBOutlet UIButton     *powerOffButton;

@property (weak, nonatomic) IBOutlet UIImageView *ManualHeatingImageView;

@property (weak, nonatomic) IBOutlet UIView *viewIRContent;

@property (strong, nonatomic)ImagesCircleView *outputIRView;
@property (weak, nonatomic) IBOutlet UILabel *labelIRwarning;

@property (strong, nonatomic) GizSDKCommunicateService    *service;

@property (weak, nonatomic) IBOutlet UIView *moveFlashView;
@property (strong, nonatomic) FLDemoView *fd;

@property (weak, nonatomic) IBOutlet UIView *waterWaveView;
@property (weak, nonatomic) IBOutlet UIImageView *bgDayImageView;

@property (strong, nonatomic) WaterWaveView *firstWaterView;
@property (strong, nonatomic) WaterWaveView *secondWaterView;

@property (strong, nonatomic) UIImageView *buddleImageView;

@property (weak, nonatomic) IBOutlet UIView *bubbleView;

@end

@implementation SURHeaterMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.service = [[SURCommonService alloc] init];
    
    self.exceptionStatusView.delegate = self;
    
    self.firstWaterView = [[WaterWaveView alloc]initWithFrame:self.view.bounds withPeak:1.5 withSpeed:0.08 withColor:[UIColor colorWithRed:28/255.f green:146/255.f blue:188/255.f alpha:1] withOffset:20];
    self.secondWaterView = [[WaterWaveView alloc]initWithFrame:self.view.bounds withPeak:2 withSpeed:0.04 withColor:[UIColor colorWithRed:32/255.f green:196/255.f blue:212/255.f alpha:1] withOffset:50];
    
    [self.waterWaveView addSubview:self.firstWaterView];
    [self.waterWaveView addSubview:self.secondWaterView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHot:)];
    [self.normalStatusView addGestureRecognizer:tapGesture];
    
//    self.fd = [[FLDemoView alloc] initWithHeaterFlash];
//    [self.moveFlashView addSubview:self.fd];
    
    self.buddleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width/2-150, kScreen_Height, 300, 389)];
    self.buddleImageView.image = [UIImage imageNamed:@"bubble"];
    [self.bubbleView addSubview:self.buddleImageView];
    
    [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(displayBubble) userInfo:@"nil" repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeMode:SURHeaterPowerOff];
    [self.infraredDetectionView setHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisconnected) name:SUR_NOTIFICATION_DISCONNECT object:nil];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
//    tap.numberOfTouchesRequired = 1;
//    tap.numberOfTapsRequired = 1;
//    self.viewIRContent.userInteractionEnabled = YES;
//    [self.viewIRContent addGestureRecognizer:tap];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    int time = [str intValue];
    if (time>=18||time<=06) {
        // 晚上
        self.bgDayImageView.alpha = 1;
        self.firstWaterView.currentWaterColor = [UIColor colorWithRed:28/255.f green:146/255.f blue:188/255.f alpha:1];
    }
    else{
        // 早上
        self.bgDayImageView.alpha = 0;
        self.firstWaterView.currentWaterColor = [UIColor colorWithRed:19/255.f green:104/255.f blue:129/255.f alpha:1];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    int time = [str intValue];
    if (time>=18||time<=06) {
        // 晚上
        [UIView animateWithDuration:1.5f animations:^{
            self.bgDayImageView.alpha = 0;
            self.firstWaterView.currentWaterColor = [UIColor colorWithRed:19/255.f green:104/255.f blue:129/255.f alpha:1];
        }];
    }
    else{
        // 早上
        [UIView animateWithDuration:1.5f animations:^{
            self.bgDayImageView.alpha = 1;
            self.firstWaterView.currentWaterColor = [UIColor colorWithRed:28/255.f green:146/255.f blue:188/255.f alpha:1];
        }];
    }
}


-(void)displayBubble{
    self.buddleImageView.center = CGPointMake(self.buddleImageView.center.x,kScreen_Height-100);
    [UIView animateWithDuration:2.f animations:^{
        self.buddleImageView.center = CGPointMake(self.buddleImageView.center.x,-389);
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SURCommonUtils hideLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SUR_NOTIFICATION_DISCONNECT object:nil];
}

-(void)changeMode:(SURHeaterModel)mode{
    switch (mode) {
        case SURHeaterRegular:
            // 隐藏关机状态
            [self.powerOffTopMessagesView  setHidden:YES];
            [self.powerOffButtonView       setHidden:YES];
            [self.powerOffSettingModelView setHidden:YES];
            [self.powerOffOneSettingView   setHidden:YES];
            [self.powerOffStatusView       setHidden:YES];
             [self.powerOffButton           setHidden:NO];
            // 隐藏异常状态
            [self.exceptionStatusView      setHidden:YES];
            // 显示正常状态
            [self.normalTopMessagesView    setHidden:NO];
            [self.normalStatusView         setHidden:NO];
            [self.normalStatusImageView    setHidden:NO];
            [self.normalTopStatusView      setHidden:NO];
            [self.normalFourSettingView    setHidden:NO];
            break;
        
        case SURHeaterIrregular:
            // 隐藏关机状态
            [self.powerOffTopMessagesView  setHidden:YES];
            [self.powerOffButtonView       setHidden:YES];
            [self.powerOffSettingModelView setHidden:YES];
            [self.powerOffOneSettingView   setHidden:YES];
            [self.powerOffStatusView       setHidden:YES];
            // 显示异常状态
            [self.exceptionStatusView      setHidden:NO];
            // 隐藏正常状态(除了TOPVIEW,FOURSETTINGVIEW)
            [self.normalTopMessagesView    setHidden:NO];
//            [self.normalStatusView         setHidden:YES];
//            [self.normalStatusImageView    setHidden:YES];
            [self.normalTopStatusView      setHidden:YES];
            [self.normalFourSettingView    setHidden:NO];
            break;
        
        case SURHeaterPowerOff:
            // 显示关机状态
            [self.powerOffTopMessagesView  setHidden:NO];
            [self.powerOffButtonView       setHidden:NO];
            [self.powerOffSettingModelView setHidden:NO];
            [self.powerOffOneSettingView   setHidden:NO];
            [self.powerOffStatusView       setHidden:NO];
            [self.powerOffButton           setHidden:YES];
            // 隐藏异常状态
            [self.exceptionStatusView      setHidden:YES];
            // 隐藏正常状态(除了TOPVIEW)
            [self.normalTopMessagesView    setHidden:YES];
            [self.normalStatusView         setHidden:YES];
            [self.normalStatusImageView    setHidden:YES];
            [self.normalTopStatusView      setHidden:YES];
            [self.normalFourSettingView    setHidden:YES];
            break;
        
        default:
            break;
    }
    [SURCommonUtils hideLoading];
}

-(void)setSURMode:(SURMode)mode{
    switch (mode) {
        case timing:
            self.timingButton.selected = YES;
            self.ConservationButton.selected = NO;
            self.constantTemperatureButton.selected = NO;
            break;
        case conservation:
            self.timingButton.selected = NO;
            self.ConservationButton.selected = YES;
            self.constantTemperatureButton.selected = NO;
            break;
        case constantTemp:
            self.timingButton.selected = NO;
            self.ConservationButton.selected = NO;
            self.constantTemperatureButton.selected = YES;
            break;
            
        default:
            break;
    }
}

/* 定时按钮响应 */
- (IBAction)timingButtonAction:(id)sender {
    
    if (isStartAppointment)
    {
        NSError *err;
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"0",@"mode",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        [self setSURMode:timing];
        if (err.code == kSURCommonErrorNone)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"定时模式中，按定时设置智能开启" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] showAfterTimeInterval:1.0f];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"toSettingMain" sender:self];
    }
    
    
}

/* 节能按钮响应 */
- (IBAction)conservationButtonAction:(id)sender {
    NSError *err;
    NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"1",@"mode",nil];
    [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
    [self setSURMode:conservation];
    if (err.code == kSURCommonErrorNone)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"节能模式中,辅助加热需手动开启" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] showAfterTimeInterval:1.0f];
    }
}

/* 恒温按钮响应 */
- (IBAction)constantTemperatureButtonAction:(id)sender {
    NSError *err;
    NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"2",@"mode",nil];
    [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
    [self setSURMode:constantTemp];
    
    if (err.code == kSURCommonErrorNone)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"恒温模式中，已开启水温自动控制" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] showAfterTimeInterval:1.0f];
    }

}

/* 正常模式下设置按钮响应 */
- (IBAction)normalSettingButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"toSettingMain" sender:self];
}

/* 关机模式下设置按钮响应 */
- (IBAction)powerOffModelSettingButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"toSettingMain" sender:self];
}

/* 设置温度按钮响应 */
- (IBAction)settingTemperatureButtonAction:(id)sender {
    
}

/* 关机按钮响应 */
- (IBAction)powerOffButtonAction:(id)sender {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温謦提示" message:@"是否确定关机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alter show];
}

-(void)pushSettingTemperatureViewController:(BOOL)isHot{
    UIStoryboard *secondStroyBoard = [UIStoryboard storyboardWithName:@"SURHeater" bundle:nil];
    SURHeaterSettingtemperatureViewController *heaterSetTempVC = [secondStroyBoard instantiateViewControllerWithIdentifier:@"toSettingTemperature"];
    heaterSetTempVC.selectedDevice = self.selectedDevice;
    heaterSetTempVC.isHot = isHot;
    [self.navigationController pushViewController:heaterSetTempVC animated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)
    {
        [SURCommonUtils showLoadingWithTile:@"正在关机..."];
        NSError *err;
        NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"0",@"Switch",nil];
        [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
        [self changeMode:SURHeaterPowerOff];
    }
}

/* 开机按钮响应*/
- (IBAction)powerOnButtonAction:(id)sender {
#warning mark - 开机状态判断(异常使用irregualr，正常使用regular)
    NSError *err;
    NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"1",@"Switch",nil];
    [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
    [self changeMode:SURHeaterRegular];

}


/* 返回按钮响应 */
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark XPG delegate
- (void)XPGWifiDevice:(XPGWifiDevice *)device didReceiveData:(NSDictionary *)data result:(int)result
{
    [SURCommonUtils hideLoading];
//    [self.service readDataPoint:data productKey:device.productKey completion:^(SURWaterHeaterProductDataPointModel *model, NSArray *alerts, NSArray *faults) {
//        // 开关
//        if([model.Switch isEqualToString:@"0"]){
//            NSLog(@"Switch OFF");
//            [self changeMode:SURHeaterPowerOff];
//        }else{
//            NSLog(@"Switch ON");
//            [self changeMode:SURHeaterRegular];
//        }
//        if ([model.Heat isEqualToString:@"0"])
//        {
//            self.normalStatusView.tag = 12;
//            self.ManualHeatingImageView.image = [UIImage imageNamed:@"home_button_bg1.png"];
//            self.normalStatusLabel.text = @"即热";
//            self.labelHeatText.text = @"预置温度";
//        }
//        else
//        {
//            self.normalStatusView.tag = 13;
//            self.ManualHeatingImageView.image = [UIImage imageNamed:@"home_button_bg2.png"];
//            self.normalStatusLabel.text = @"加热";
//            self.labelHeatText.text = @"即热温度";
//        }
//        
//        self.powerOffTopMessagesPeopleNumberLabel.text = model.Bath_Num;
//        self.normalTopMessagesPeopleNumberLabel.text = model.Bath_Num;
//        self.currentTempertureLabel.text = model.Temp;
//        self.normalTopMessagesTempertureLabel.text = model.Pre_Temp;
//        
//        if ([model.mode isEqual:@"0"]) {
//            [self setSURMode:timing];
//        }else if ([model.mode isEqual:@"1"]){
//            [self setSURMode:conservation];
//        }else{
//            [self setSURMode:constantTemp];
//        }
//        
//        if ([model.Temp intValue] - [model.Pre_Temp intValue] < 0) {
//            self.normalTopStatusLabel.text = @"加热中";
//        }else if ([model.Temp intValue] - [model.Pre_Temp intValue] > 0){
//            self.normalTopStatusLabel.text = @"保温中";
//        }else{
//            self.normalTopStatusLabel.text = @"恒温中";
//        }
//        
//        self.exceptionStatusView.errorArray = faults;
//        self.exceptionStatusView.errorImageName = @"home_icon_tip2";
//        self.exceptionStatusView.colorForError = [UIColor redColor];
//        
//        if ( [[(NSDictionary *)alerts[0] objectForKey:@"红外入侵"] intValue]== 1 )
//        {
//            [self sendIRWarning:model];
//        }
//        else
//        {
//            [self configureScrollIRView:0];
//        }
//        
//        if (self.exceptionStatusView.errorArray.count > 0 || self.exceptionStatusView.alertArray.count > 0) {
//            if ([model.Switch isEqualToString:@"1"])
//            {
//                [self.exceptionStatusView showList];
//                [self changeMode:SURHeaterIrregular];
//            }
//        }
//        if ([model.Heat_TimeSwitch1 isEqual:@"0"] && [model.Heat_TimeSwitch2 isEqual:@"0"]) {
//            isStartAppointment = NO;
//        }else{
//            isStartAppointment = YES;
//        }
//        
//        for (int i = 0; i < 7; i++) {
//            NSString *str = [NSString stringWithFormat:@"IR_AlarmSet%d",i+1];
//            if ([[model valueForKey:str]  isEqual: @"0"]) {
//                [self.infraredDetectionView setHidden:NO];
//                [self.imageIR.layer addAnimation:[self opacityForever_Animation:1.0f] forKey:nil];
//            };
//        }
//    }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
     UIViewController *viewController = segue.destinationViewController;
    if ([viewController isKindOfClass:[SURHeaterExceptionDetailsViewController class]])
    {
        SURHeaterExceptionDetailsViewController *detailVc = segue.destinationViewController;
        detailVc.exceptionTitle = (NSString *)sender;
    }
    else if ([viewController isKindOfClass:[SURHeaterSettingtemperatureViewController class]])
    {
        [self.navigationController setNavigationBarHidden:YES];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO];
        
    }
}

-(void)clickErrorList:(SURErrorView *)view name:(NSString *)name
{
    [self performSegueWithIdentifier:@"toException" sender:name];
}

-(void)onHot:(UIGestureRecognizer *)recongizer
{
//    NSError *err;
//    NSDictionary *myClassDict = nil;
// 
//    if (recongizer.view.tag == 12 )
//    {
//        myClassDict = @{@"Heat" : @"1"};
//    }
//    else if (recongizer.view.tag == 13)
//    {
//       myClassDict = @{@"Heat" : @"0"};
//    }
//    if (myClassDict)
//    {
//        [self.serviceForSDK sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
//    }
    BOOL isHeating = recongizer.view.tag == 13;
    if (isHeating)
    {
        NSError *err;
        NSDictionary *myClassDict = nil;
        myClassDict = @{@"Heat" : @"0"};
        [self.serviceForSDK sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
    }
    else
    {
        [self pushSettingTemperatureViewController:YES];
    }
}

#pragma dataSource
- (void)scrollImagesFromView:(UIView *)view info:(id)info {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, kScreen_Width - 100, view.frame.size.height)];
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = info;
    [view addSubview:label];
}
#pragma mark - delegate
#pragma mark - did Tap
- (void)scrollImagesDidSelectItemInfo:(id)info {
    [self performSegueWithIdentifier:@"IRWarningView" sender:@"警报！有不明访客入侵！"];    
}

-(void)hideIRScrollView
{
    if (_outputIRView)
    {
        [_outputIRView removeFromSuperview];
        _outputIRView = nil;
        
        _labelIRwarning.hidden = NO;
        _viewIRContent.hidden = YES;
        
    }
}
-(void)configureScrollIRView:(int)IRWarning
{
    if (!_outputIRView && IRWarning == 1  &&!afterOutputWarning)
    {
        afterOutputWarning = YES;
        [self configureScrollIRView];
        _labelIRwarning.hidden = YES;
        _viewIRContent.hidden = NO;
        [self performSelector:@selector(hideIRScrollView) withObject:nil afterDelay:9.0f];
    }
    else if (IRWarning == 0)
    {
        afterOutputWarning = NO;
        [self hideIRScrollView];
    }
}
-(void)configureScrollIRView
{
    if (!_outputIRView)
    {
        self.outputIRView = [[ImagesCircleView alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
        self.outputIRView.pagingEnabled = YES;
        self.outputIRView.showsHorizontalScrollIndicator = NO;
        self.outputIRView.bounces = NO;
        self.outputIRView.scrollsToTop = NO;
        self.outputIRView.imagesCircleDelegate = self;
        self.outputIRView.imageInfos = @[@"警报！有不明访客入侵！",@"警报！有不明访客入侵！"];
        /**
         *  轮询时间间隔 设置为0自动停止
         */
        self.outputIRView.duration = 5;
        [_viewIRContent addSubview:self.outputIRView];

    }
}

-(CABasicAnimation *)opacityForever_Animation:(float)time

{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath : @"opacity" ]; // 必须写 opacity 才行。
    
    animation. fromValue = [ NSNumber numberWithFloat : 1.0f ];
    
    animation. toValue = [ NSNumber numberWithFloat : 0.0f ]; // 这是透明度。
    
    animation. autoreverses = YES ;
    
    animation. duration = time;
    
    animation. repeatCount = MAXFLOAT ;
    
    animation. removedOnCompletion = NO ;
    
    animation. fillMode = kCAFillModeForwards ;
    
    animation. timingFunction =[CAMediaTimingFunction functionWithName : kCAMediaTimingFunctionEaseIn ]; /// 没有的话是均匀的动画。
    
    return animation;
    
}

-(void)sendIRWarning:(SURWaterHeaterProductDataPointModel *)model
{
    
    NSString *iRonOffName = @"IR_AlarmSet";
    NSString *iRAlarmRunTime = @"IR_Alarm_Run_Time_";
    NSString *iRAlarmStopTime = @"IR_Alarm_Stop_Time_";
    for (int i = 1;i <= 7 ;i ++)
    {
        NSString *onOff = [model valueForKey:[NSString stringWithFormat:@"%@%d",iRonOffName,i]];
        
        if ([onOff isEqualToString:@"0"])
        {
            NSInteger startTime = [[model valueForKey:[NSString stringWithFormat:@"%@%d",iRAlarmRunTime,i]] integerValue];
            NSInteger endTime = [[model valueForKey:[NSString stringWithFormat:@"%@%d",iRAlarmStopTime,i]] integerValue];
            
            NSInteger nowTime = [self timeChangeMinNow];
            
            if (nowTime > startTime && nowTime < endTime)
            {
                [self configureScrollIRView:1];
            }
            
        }
    }
}

-(NSInteger)timeChangeMinNow
{
    NSDate *date = [NSDate date];
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"HH"];
    NSString *hourString = [fomatter stringFromDate:date];
    
    [fomatter setDateFormat:@"mm"];
    NSString *minString = [fomatter stringFromDate:date];
    
    NSInteger hour = hourString.integerValue;
    NSInteger min = minString.integerValue;
    
   return  hour * 60 + min;
}

@end

