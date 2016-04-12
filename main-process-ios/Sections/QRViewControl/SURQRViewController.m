#import <AVFoundation/AVFoundation.h>
#import "SURQRViewController.h"
#import "QRView.h"
#import "SURProcessModel.h"
#import "SURUtils.h"
#import "GizSDKCommunicateService.h"
#import "SURConfiguredDeviceViewController.h"
#import "SURMainViewController.h"

@interface SURQRViewController ()<AVCaptureMetadataOutputObjectsDelegate, QRViewDelegate, UIAlertViewDelegate>{
    BOOL isOpen;
    UIAlertView * alert;
}

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@end

@implementation SURQRViewController

#pragma mark 初始化带Deivce参数
-(instancetype)initWithDevice:(XPGWifiDevice *)device
{
    self = [super init];
    if (self) {
        selectedDeivce = device;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    
    
    [_session startRunning];
    
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    QRView *qrRectView = [[QRView alloc] initWithFrame:screenRect];
    qrRectView.transparentArea = CGSizeMake(200, 200);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    qrRectView.delegate = self;
    [self.view addSubview:qrRectView];
    
    UIButton *pop = [UIButton buttonWithType:UIButtonTypeCustom];
    pop.frame = CGRectMake(10, 20, 50, 50);
    [pop setTitle:@"返回" forState:UIControlStateNormal];
    [pop addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pop];
    
    UILabel * labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 20, 100, 50)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:20];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = @"扫描二维码";
    [self.view addSubview:labelTitle];
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,
                                 (screenHeight - qrRectView.transparentArea.height) / 2,
                                 qrRectView.transparentArea.width,
                                 qrRectView.transparentArea.height);
    
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
    //二维码说明
    UILabel *labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(0,5, self.view.frame.size.width,20);
    labIntroudction.numberOfLines = 1;
    labIntroudction.font = [UIFont systemFontOfSize:12.0];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码对准方框，即可自动扫描";
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 + qrRectView.transparentArea.height/2  , self.view.frame.size.width, 30)];
    darkView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:darkView];
    [darkView addSubview:labIntroudction];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isOpen = YES;
    [XPGWifiSDK sharedInstance].delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [XPGWifiSDK sharedInstance].delegate = nil;
}

#pragma mark 回调跳转
-(void)popToMainViewController{
    [SURCommonUtils hideLoading];

    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[SURMainViewController class]])
        {
            
            if (sysVer >= 8)
            {
                [self.navigationController popToViewController:viewController animated:YES];
            }
            else
            {
                [self.navigationController popToViewController:viewController animated:NO];
            }
            return;
        }
    }

}

-(void)popToSelecetedDevicesListViewController{
    [SURCommonUtils hideLoading];
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[SURConfiguredDeviceViewController class]])
        {
            if (sysVer >= 8)
            {
                [self.navigationController popToViewController:viewController animated:YES];
            }
            else
            {
                [self.navigationController popToViewController:viewController animated:NO];
            }
            return;
        }
    }
    
}

- (void)pop:(UIButton *)button{
    [SURCommonUtils hideLoading];
    
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[SURConfiguredDeviceViewController class]])
        {
            NSLog(@"%f",sysVer);
            if (sysVer >= 8)
            {
                [self.navigationController popToViewController:viewController animated:YES];
            }
            else
            {
                [self.navigationController popToViewController:viewController animated:NO];
            }
            return;
        }
    }
    
//    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 5)] animated:NO];
}

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

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if (isOpen == YES) {
        if (metadataObjects != nil && [metadataObjects count] > 0)
        {
            //停止扫描
            //            [_session stopRunning];
            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
            stringValue = metadataObject.stringValue;
            isOpen = NO;
            
            [self performSelector:@selector(bindDevice) withObject:nil afterDelay:2.0f];
        }
    }
    
    NSLog(@" stringValue = %@ ",stringValue);
    
    NSDictionary *dict = [self getScanResult:stringValue];
#warning 需要更改
    
    
//    if(nil != dict)
//    {
//        SURCommonService *service = [[SURCommonService alloc] init];
//        NSString *did = [dict valueForKey:@"did"];
//        NSString *passcode = [dict valueForKey:@"passcode"];
//        NSString *productkey = [dict valueForKey:@"product_key"];
//        
//        //这里，要通过did，passcode，productkey获取一个设备
//        if(did.length > 0 && passcode.length > 0)
//        {
//            [SURCommonUtils showLoadingWithTile:@"添加中..."];
//            NSError *error;
//            [service bindDeviceForSDKWithDid:did passcode:passcode remark:nil error:&error];
//        }
//    }
    
    if (self.qrUrlBlock) {
        self.qrUrlBlock(stringValue);
    }
}

#pragma mark - XPGWifiSDK delegate
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didBindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage{
    if([error intValue])
    {
        [SURCommonUtils hideLoading];
        NSString *message = [NSString stringWithFormat:@"设备绑定失败，请稍后重试"];
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];
        
    }else{
        [SURCommonUtils hideLoading];
        NSString *message = [NSString stringWithFormat:@"绑定成功"];
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 102;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101 && buttonIndex == 0) {
        [self popToSelecetedDevicesListViewController];
    }else if (alertView.tag == 102 && buttonIndex == 0){
        [self popToMainViewController];
    }
}

-(void)bindDevice
{
    GizSDKCommunicateService *service = [[GizSDKCommunicateService alloc] init];
    [SURCommonUtils showLoadingWithTile:@"绑定中..."];
    NSError *error;
    [service bindDeviceForSDKWithDid:selectedDeivce.did passcode:selectedDeivce.passcode remark:nil error:&error];
}

@end
