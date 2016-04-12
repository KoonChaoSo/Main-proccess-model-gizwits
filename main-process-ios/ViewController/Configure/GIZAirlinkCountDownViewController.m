//
//  SURAirLinkViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 26/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "GIZAirlinkCountDownViewController.h"
#import "GIZDeviceListViewController.h"
#import "GizSDKCommunicateService.h"
#import "GIZWifiUtil.h"
#import "SURAlertView.h"
#import "GIZUtils.h"
#import "AFNetworking.h"

#import "StepFrameView.h"

//#import "SURQRViewController.h"

@interface GIZAirlinkCountDownViewController ()
{
    NSTimer *counterTimer;
    NSTimer *bindTimer;
    BOOL flag;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (assign, nonatomic) NSInteger timeout;
@property (assign, nonatomic) NSInteger bindTimeout;
@property (assign, nonatomic) BOOL isLoadingView;

@property (weak, nonatomic) IBOutlet UIView *stepFrameView;

@end

static GIZSDKCommunicateService *service = nil;

@implementation GIZAirlinkCountDownViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    StepFrameView *sf = [[StepFrameView alloc] initFourStep:fourthStep];
    sf.frame = CGRectMake(0, 0, 320, 82);
    [sf.backButton addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sf];
    
    self.navigationController.navigationBarHidden = YES;

    if(self.isLoadingView == YES){
        self.navigationItem.hidesBackButton = YES;
        self.timeout = XPG_AIRLINK_TIMEOUT;
        self.bindTimeout = XPG_BIND_TIMEOUT;
        [self startLoading];
        [sf hideBackButton];
    }
    else{
        self.navigationItem.hidesBackButton = NO;
    }
    flag = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    service = [GIZSDKCommunicateService sharedInstance];
    
//    service = [[SURCommonService alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self releaseTimer];
    [self releaseBindTimer];
    [GIZCommonUtils hideLoading];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


#pragma mark - 开始配置按钮响应
- (IBAction)beginConfigure:(id)sender {
    
    [self performSegueWithIdentifier:@"toAirLinkThirdStep" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UIViewController *send = segue.destinationViewController;
    if([send respondsToSelector:@selector(setSsid:)] && [send respondsToSelector:@selector(setWifiPassword:)] && [send respondsToSelector:@selector(setIsLoadingView:)])
    {
        [send setValue:self.ssid forKey:@"ssid"];
        [send setValue:self.wifiPassword forKey:@"wifiPassword"];
        if([segue.identifier isEqualToString:@"toAirLinkThirdStep"]){
            
            [send setValue:@YES forKey:@"isLoadingView"];
#pragma mark 发送Airlink请求
            int timeout = XPG_AIRLINK_TIMEOUT;
            [service configureAirLink:self.ssid key:self.wifiPassword timeout:timeout completion:^(XPGWifiDevice *device,NSError *err,BOOL **stop){
                if(err.code == 0 || err.code == 39){
                    if([device.productKey isEqualToString:GIZWaterHeaterProductKey] || [device.productKey isEqualToString:GIZWaterPurifierProductKey])
                    {
                        if (![device.did isEqualToString:@""])
                        {
                            *stop = YES;
                            [self releaseTimer];
                            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"配置成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                            [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -4)] animated:YES];
                        }
                    }
                }
                else
                {
                    [self configurationFailed];
                }
            }];
        }
        else
        {
        }
    }
}

#pragma mark - Delegate


//-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didBindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage
//{
//    [GIZCommonUtils hideLoading];
//    
//    if (flag == YES) {
//        if([error intValue])
//        {
//            //绑定失败
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alertView.tag = 101;
//            [alertView show];
//        }
//        else
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alertView.tag = 101;
//            [alertView show];
//        }
//    }
//}

//- (void)bindDevice:(XPGWifiDevice *)device{
//    [SURCommonUtils hideLoading];
//    if (![device.did isEqualToString:@""] && !flag /*&& ![device isBind:SUR_PROCEES_MODEL.currentUid]*/)
//    {
//        [SURCommonUtils showLoadingWithTile:@"绑定中"];
//        flag = YES;
//        NSError *err;
//        [service bindDeviceForSDKWithDid:device.did passcode:device.passcode remark:nil error:&err];
//        
//        bindTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changeBindValue) userInfo:nil repeats:NO];
//    }
//}

-(void)pushToQRViewControllor:(XPGWifiDevice *)device{
    [GIZCommonUtils hideLoading];
//    SURQRViewController *qrVC = [[SURQRViewController alloc] initWithDevice:device];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0) {
//        [self.navigationController pushViewController:qrVC animated:NO];
//    }else{
//        [self.navigationController pushViewController:qrVC animated:YES];
//    }
}

-(void)configurationFailed
{
    if (self.navigationController.viewControllers.lastObject == self)
    {
        self.navigationItem.hidesBackButton = YES;
        [self performSegueWithIdentifier:@"toAirLinkFailStep" sender:self];
    }
}

#pragma mark - 开始计时
- (void)startLoading{
    counterTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeValue) userInfo:nil repeats:YES];
}

#pragma mark - 修改timeout的值，并显示出来
-(void)changeValue{
    self.timeout --;
    if(self.timeout < 0){
        [self releaseTimer];
        [self configurationFailed];
        return;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%ld",(long)self.timeout];
}

-(void)changeBindValue{
    self.bindTimeout --;
    if (self.bindTimeout < 0) {
        [self releaseBindTimer];
        [self popToNewDevicesListViewController];
    }
}

#pragma mark - 释放Timber
-(void)releaseTimer{
    [counterTimer invalidate];
    if(counterTimer){
        counterTimer = nil;
    }
}

-(void)releaseBindTimer{
    [bindTimer invalidate];
    if (bindTimer) {
        bindTimer = nil;
    }
}

#pragma mark 回调跳转
-(void)popToNewDevicesListViewController{
    [GIZCommonUtils hideLoading];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 6)] animated:YES];
}

-(void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        [self popToNewDevicesListViewController];
    }
}

#pragma Zbar delegate
- (NSDictionary *)getScanResult:(NSString *)result
{
    NSArray *arr1 = [result componentsSeparatedByString:@"?"];
    if(arr1.count != 2)
        return nil;
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    NSArray *arr2 = [arr1[1] componentsSeparatedByString:@"&"];
    for(NSString *str in arr2)
    {
        NSArray *keyValue = [str componentsSeparatedByString:@"="];
        if(keyValue.count != 2)
            continue;
        
        NSString *key = keyValue[0];
        NSString *value = keyValue[1];
        [mdict setValue:value forKeyPath:key];
    }
    return mdict;
}

- (void)imagePickerController: (UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    // ADD: 获取解码结果
//    id<NSFastEnumeration> results =[info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results) {
//        // 例子: 只获取第一个BarCode
//        break;
//    }
    
//    NSString *resultStr=symbol.data;
//    //处理中文乱码问题
//    //    if ([resultStr canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
//    //        resultStr = [NSString stringWithCString:[resultStr cStringUsingEncoding: NSShiftJISStringEncoding]  encoding:NSUTF8StringEncoding];
//    //    }
//    
//    NSDictionary *dict = [self getScanResult:resultStr];
//    if(nil != dict)
//    {
//        NSString *did = [dict valueForKey:@"did"];
//        NSString *passcode = [dict valueForKey:@"passcode"];
//        NSString *productkey = [dict valueForKey:@"product_key"];
//        
//        //这里，要通过did，passcode，productkey获取一个设备
//        if(did.length > 0 && passcode.length > 0)
//        {
//            [SURCommonUtils showLoadingWithTile:@"添加中..."];
//            [[XPGWifiSDK sharedInstance] bindDeviceWithUid:SUR_PROCEES_MODEL.currentUid token:SUR_PROCEES_MODEL.currentToken did:did passCode:passcode remark:nil];
//            
//            [reader dismissViewControllerAnimated:YES completion:^{
//            }];
//        }
//    }
    //    // 例子: 处理文本结果
    //    resultText.text = resultStr;
    //
    //    // 例子: 处理barcode图片
    //    resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
}


@end
