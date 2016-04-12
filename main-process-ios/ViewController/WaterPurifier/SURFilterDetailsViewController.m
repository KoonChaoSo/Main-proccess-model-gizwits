//
//  SURFilterDetailsViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 5/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURFilterDetailsViewController.h"
#import "CircleProgressView.h"

#define DEFAULT_VOID_COLOR [UIColor clearColor] // 默认颜色
#define ALERT_COLOR [UIColor colorWithRed:252/255.0 green:179/255.0 blue:35/255.0 alpha:1]; // 警告颜色
#define NORMAL_COLOR [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]; // 常规颜色

@interface SURFilterDetailsViewController ()
{
    __weak IBOutlet UIView *detil;
    CircleProgressView *progress;
    
    // 第一个滤网
    __weak IBOutlet UIImageView *firstFilterImageView;
    IBOutlet NSLayoutConstraint *firstFilterImageViewHeight;
    IBOutlet NSLayoutConstraint *firstFilterImageViewWidth;
    __weak IBOutlet UILabel *firstFilterLabel;
    __weak IBOutlet UIView *firstArrowView;
    
    // 第二个滤网
    __weak IBOutlet UIImageView *secondFilterImageView;
    IBOutlet NSLayoutConstraint *secondFilterImageViewHeight;
    IBOutlet NSLayoutConstraint *secondFilterImageViewWidth;
    __weak IBOutlet UILabel *secondFilterLabel;
    __weak IBOutlet UIView *secondArrowView;
    
    
    // 第三个滤网
    __weak IBOutlet UIImageView *thirdFilterImageView;
    IBOutlet NSLayoutConstraint *thirdFilterImageViewHeight;
    IBOutlet NSLayoutConstraint *thirdFilterImageViewWidth;
    __weak IBOutlet UILabel *thirdFilterLabel;
    __weak IBOutlet UIView *thirdArrowView;
    
    // 第四个滤网
    __weak IBOutlet UIImageView *fourthFilterImageView;
    IBOutlet NSLayoutConstraint *fourthFilterImageViewHeight;
    IBOutlet NSLayoutConstraint *fourthFilterImageViewWidth;
    __weak IBOutlet UILabel *fourthFilterLabel;
    __weak IBOutlet UIView *fourthArrowView;
    
    // 第五个滤网
    __weak IBOutlet UIImageView *fifthFilterImageView;
    IBOutlet NSLayoutConstraint *fifthFilterImageViewHeight;
    IBOutlet NSLayoutConstraint *fifthFilterImageViewWidth;
    __weak IBOutlet UILabel *fifthFilterLabel;
    __weak IBOutlet UIView *fifthArrowView;
    
    // 剩余比例
    __weak IBOutlet UILabel *restRateLabel;
    
    // 剩余天数
    __weak IBOutlet UILabel *restDayLabel;
    
    // 更换滤芯提示
    __weak IBOutlet UILabel *hintChangeFilterLabel;
    
    // 滤芯序号
    __weak IBOutlet UILabel *filterNoLabel;
    
    // 存数据数组
    NSMutableArray *dataArray;
    NSArray *totalDaysArray;
    
    NSArray *filtersInfo;
    NSArray *noInfo;
}
@property (weak, nonatomic) IBOutlet UILabel *labelForFilterInfo;
@property (strong, nonatomic) GizSDKCommunicateService * service;

@end

@implementation SURFilterDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.service = [[SURCommonService alloc] init];
    filtersInfo = @[@"聚丙烯5微米熔喷滤芯：有效过滤水中泥沙及大颗粒杂质，降低原水浊度。",
                    @"颗粒活性炭滤芯：有效吸附水中余氯、异味，改善原水浑浊度。",
                    @"聚丙烯1微米熔喷滤芯：进一步过滤水中泥沙及大颗粒杂质，降低原水浊度。",
                    @"反渗透滤芯：有效过滤大肠杆菌，降低砷、铬（六价）、镉、汞、铅重金属含量等。",
                    @"后置活性炭滤芯：进一步吸附异味，改善口感。"];
    noInfo = @[@"一",@"二",@"三",@"四",@"五"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 创建进度圈对象（初始化为250x250）
    progress = [[CircleProgressView alloc]initWithFrame:CGRectMake(0, 0, 250, 250)];
    // 导航栏设置
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title                     = @"滤芯状况";
    // 初始化数据
    dataArray = [@[@(100), @(100),  @(100), @(100), @(100)] mutableCopy];
    totalDaysArray = @[@(180),@(360),@(360),@(720),@(360)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisconnected) name:SUR_NOTIFICATION_DISCONNECT object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SUR_NOTIFICATION_DISCONNECT object:nil];
}

/* 更新单个滤网的界面信息*/
- (void)changeSingleFilterViewVaule:(NSInteger)value withNo:(NSInteger)no{
    switch (no) {
        case 1:
            // 警告判断
            if(value <= 10){
                firstFilterLabel.text      = @"需更换";
                firstFilterLabel.textColor = ALERT_COLOR;
                [firstFilterImageView setImage:[UIImage imageNamed:@"nvxin_icon_xin1.png"]];
            }else{
                firstFilterLabel.text      = @"正常";
                [firstFilterImageView setImage:[UIImage imageNamed:@"nvxin_icon_xin2.png"]];
                firstFilterLabel.textColor = NORMAL_COLOR;
            }
            break;
            
        case 2:
            // 警告判断
            if(value <= 10){ 
                secondFilterLabel.text      = @"需更换";
                secondFilterLabel.textColor = ALERT_COLOR;
                [secondFilterImageView setImage:[UIImage imageNamed:@"nvxin_icon_xin1.png"]];
            }else{
                secondFilterLabel.text      = @"正常";
                secondFilterLabel.textColor = NORMAL_COLOR;
                [secondFilterImageView setImage:[UIImage imageNamed:@"nvxin_icon_xin2.png"]];
            }
            break;
            
        case 3:
            // 警告判断
            if(value <= 10){
                thirdFilterLabel.text      = @"需更换";
                thirdFilterLabel.textColor = ALERT_COLOR;
                [thirdFilterImageView setImage:[UIImage imageNamed:@"nvxin_icon_xin1.png"]];
            }else{
                thirdFilterLabel.text      = @"正常";
                thirdFilterLabel.textColor = NORMAL_COLOR;
                [thirdFilterImageView setImage:[UIImage imageNamed:@"nvxin_icon_xin2.png"]];
            }
            break;
            
        case 4:
            // 警告判断
            if(value <= 10){
                fourthFilterLabel.text      = @"需更换";
                fourthFilterLabel.textColor = ALERT_COLOR;
                [fourthFilterImageView setImage:[UIImage imageNamed:@"nvxin_icon_xin1.png"]];
            }else{
                fourthFilterLabel.text      = @"正常";
                fourthFilterLabel.textColor = NORMAL_COLOR;
                [fourthFilterImageView setImage:[UIImage imageNamed:@"nvxin_icon_xin2.png"]];
            }
            break;
            
        case 5:
            // 警告判断
            if(value <= 10){
                fifthFilterLabel.text      = @"需更换";
                fifthFilterLabel.textColor = ALERT_COLOR;
                [fifthFilterImageView setImage:[UIImage imageNamed:@"nvxin_icon_xin1.png"]];
            }else{
                fifthFilterLabel.text      = @"正常";
                fifthFilterLabel.textColor = NORMAL_COLOR;
                [fifthFilterImageView setImage:[UIImage imageNamed:@"nvxin_icon_xin2.png"]];
            }
            break;
            
        default:
            break;
    }
}

-(void)refreshAllFilterImage:(NSInteger)mode{
    firstFilterImageViewHeight.constant  = 40.0f;
    firstFilterImageView.alpha           = 0.5f;
    secondFilterImageViewHeight.constant = 40.0f;
    secondFilterImageView.alpha           = 0.5f;
    thirdFilterImageViewHeight.constant  = 40.0f;
    thirdFilterImageView.alpha           = 0.5f;
    fourthFilterImageViewHeight.constant = 40.0f;
    fourthFilterImageView.alpha           = 0.5f;
    fifthFilterImageViewHeight.constant  = 40.0f;
    fifthFilterImageView.alpha           = 0.5f;
    switch (mode) {
        case 1:
            firstFilterImageViewHeight.constant  = 48.0f;
            firstFilterImageView.alpha           = 1.0f;
            break;
        case 2:
            secondFilterImageViewHeight.constant = 48.0f;
            secondFilterImageView.alpha          = 1.0f;
            break;
        case 3:
            thirdFilterImageViewHeight.constant  = 48.0f;
            thirdFilterImageView.alpha           = 1.0f;
            break;
        case 4:
            fourthFilterImageViewHeight.constant = 48.0f;
            fourthFilterImageView.alpha          = 1.0f;
            break;
        case 5:
            fifthFilterImageViewHeight.constant  = 48.0f;
            fifthFilterImageView.alpha           = 1.0f;
            break;
        default:
            break;
    }
}

/* 更新详细视图的界面信息 */
- (void)changeDetailsViewValue:(NSInteger)value withNo:(NSInteger)no{
    // 警告判断
    if(value <= 10){
        restRateLabel.textColor = ALERT_COLOR;
        restDayLabel.textColor  = ALERT_COLOR;
        // 显示警告提示
        [hintChangeFilterLabel setHidden:NO];
    }else{
        restRateLabel.textColor = NORMAL_COLOR;
        restDayLabel.textColor  = NORMAL_COLOR;
        // 关闭警告提示
        [hintChangeFilterLabel setHidden:YES];
    }
    
    // 更改剪头
    switch (no) {
        case 1:
            [self changeArrowViewModel:firstArrow];
            break;
        case 2:
            [self changeArrowViewModel:secondArrow];
            break;
        case 3:
            [self changeArrowViewModel:thirdArrow];
            break;
        case 4:
            [self changeArrowViewModel:fourthArrow];
            break;
        case 5:
            [self changeArrowViewModel:fifthArrow];
            break;
            
        default:
            break;
    }
    int totalDay = [totalDaysArray[no - 1] intValue];
    // 更改序号显示
    filterNoLabel.text = [NSString stringWithFormat:@"第%@级滤芯",noInfo[no - 1]];
    
    // 更新剩余时间百分比
    restRateLabel.text = [NSString stringWithFormat:@"%ld",(long)value];
    
    // 更新剩余时间
    restDayLabel.text  = [NSString stringWithFormat:@"%0.f",totalDay * (value / 100.0)];
    
    self.labelForFilterInfo.text = filtersInfo[no - 1];
    // 更换进度圈
    progress.arcFinishColor =
//    [UIColor colorWithRed:53/255.0 green:133/255.0 blue:187/255.0 alpha:1.0];
    [self colorWithHexString:@"#EAEAEA"];
    progress.arcUnfinishColor =
//    [UIColor colorWithRed:53/255.0 green:133/255.0 blue:187/255.0 alpha:1.0];
    [self colorWithHexString:@"#EAEAEA"];
//    progress.arcBackColor = [self colorWithHexString:@"#EAEAEA"];
    progress.arcBackColor = RGB(53, 133, 187);
    progress.percent =  1 - (value / 100.0);
    progress.width = 15;
    [detil addSubview:progress];
}

/* 更新剪头模式*/
-(void)changeArrowViewModel:(SURArrowModel)model{
    switch (model) {
        case firstArrow:
            [firstArrowView setHidden:NO];
            [secondArrowView setHidden:YES];
            [thirdArrowView setHidden:YES];
            [fourthArrowView setHidden:YES];
            [fifthArrowView setHidden:YES];
            break;
        case secondArrow:
            [firstArrowView setHidden:YES];
            [secondArrowView setHidden:NO];
            [thirdArrowView setHidden:YES];
            [fourthArrowView setHidden:YES];
            [fifthArrowView setHidden:YES];
            break;
        case thirdArrow:
            [firstArrowView setHidden:YES];
            [secondArrowView setHidden:YES];
            [thirdArrowView setHidden:NO];
            [fourthArrowView setHidden:YES];
            [fifthArrowView setHidden:YES];
            break;
        case fourthArrow:
            [firstArrowView setHidden:YES];
            [secondArrowView setHidden:YES];
            [thirdArrowView setHidden:YES];
            [fourthArrowView setHidden:NO];
            [fifthArrowView setHidden:YES];
            break;
        case fifthArrow:
            [firstArrowView setHidden:YES];
            [secondArrowView setHidden:YES];
            [thirdArrowView setHidden:YES];
            [fourthArrowView setHidden:YES];
            [fifthArrowView setHidden:NO];
            break;
            
        default:
            break;
    }
}

//字符串转颜色
- (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

// 第一个滤网按钮响应
- (IBAction)firstFilterButtonAction:(id)sender {
    self.selectSerial = 1;
    [self changeDetailsViewValue:[dataArray[0] integerValue] withNo:1];
    [self refreshAllFilterImage:self.selectSerial];
}

// 第二个滤网按钮响应
- (IBAction)secondFilterButtonAction:(id)sender {
    self.selectSerial = 2;
    [self changeDetailsViewValue:[dataArray[1] integerValue] withNo:2];
    [self refreshAllFilterImage:self.selectSerial];

}

// 第三个滤网按钮响应
- (IBAction)thirdFilterButtonAction:(id)sender {
    self.selectSerial = 3;
    [self changeDetailsViewValue:[dataArray[2] integerValue] withNo:3];
    [self refreshAllFilterImage:self.selectSerial];

}

// 第四个滤网按钮响应
- (IBAction)fourthFilterButtonAction:(id)sender {
    self.selectSerial = 4;
    [self changeDetailsViewValue:[dataArray[3] integerValue] withNo:4];
    [self refreshAllFilterImage:self.selectSerial];

}

// 第五个滤网按钮响应
- (IBAction)fifthFilterButtonAction:(id)sender {
    self.selectSerial = 5;
    [self changeDetailsViewValue:[dataArray[4] integerValue] withNo:5];
    [self refreshAllFilterImage:self.selectSerial];
}

// 滤芯恢复
- (IBAction)restoreFilterButtonAction:(id)sender {
    NSError *err;
    
    NSString *name = [NSString stringWithFormat:@"Cartridge_Life_%d",(int)self.selectSerial];
    NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @(1),name,nil];
    [self.service sendToControlWithEntity0:myClassDict target:self device:self.selectedDevice error:&err];
}

#pragma mark XPG delegate
- (void)XPGWifiDevice:(XPGWifiDevice *)device didReceiveData:(NSDictionary *)data result:(int)result
{
    [SURCommonUtils hideLoading];
//    [self.service readDataPoint:data productKey:device.productKey completion:^(SURProductDataPointModel *model, NSArray *alerts, NSArray *faults) {
//
//        dataArray[0] = @([model.Cartridge_Life_1 intValue]);
//        dataArray[1] = @([model.Cartridge_Life_2 intValue]);
//        dataArray[2] = @([model.Cartridge_Life_3 intValue]);
//        dataArray[3] = @([model.Cartridge_Life_4 intValue]);
//        dataArray[4] = @([model.Cartridge_Life_5 intValue]);
//        
//        [self changeSingleFilterViewVaule:[dataArray[0] intValue] withNo:1];
//        [self changeSingleFilterViewVaule:[dataArray[1] intValue] withNo:2];
//        [self changeSingleFilterViewVaule:[dataArray[2] intValue] withNo:3];
//        [self changeSingleFilterViewVaule:[dataArray[3] intValue] withNo:4];
//        [self changeSingleFilterViewVaule:[dataArray[4] intValue] withNo:5];
//        
//        if(self.selectSerial == 0) self.selectSerial = 1;
//        
//        [self refreshAllFilterImage:self.selectSerial];
//        
//        [self changeDetailsViewValue:[dataArray[self.selectSerial-1] intValue] withNo:self.selectSerial];
//    }];
}


@end
