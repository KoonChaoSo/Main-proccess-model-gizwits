//
//  SURConfiguredDeviceViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 24/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "GIZConfiguredDeviceListViewController.h"
#import "SURBindTableViewCell.h"
#import "SURDeviceService.h"
#import "MJRefresh.h"
#import "GIZSDKCommunicateService.h"
#import "GIZUtils.h"
//#import "SURAirLinkViewController.h"
#import "StepFrameView.h"
#import "Reachability.h"
#import "GIZAppInfo.h"
#import "NSArray+GizNSArray.h"

//#import "SURQRViewController.h"

@interface GIZConfiguredDeviceListViewController (){
    XPGWifiDevice *selectedDevice;
    BOOL isConnect;
    double angle;
    Reachability *wifiAbility;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIView *unfoundView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *stepFrameView;
@property (weak, nonatomic) IBOutlet UIView *disconncetView;

@property (strong, nonatomic) SURDeviceService *deviceService;
@property (strong, nonatomic) NSMutableArray *devicesList;
@property (strong, nonatomic) GIZSDKCommunicateService *service;

@property (weak, nonatomic) IBOutlet UIButton *buttonreload;

@end

static BOOL isRefreshed = NO;

@implementation GIZConfiguredDeviceListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // 虚拟数据导入，后面删除
//    self.service = [[SURCommonService alloc] init];

    self.deviceService  = [[SURDeviceService alloc] init];
    self.service = [GIZSDKCommunicateService sharedInstance];
    self.navigationController.navigationBarHidden = YES;
    
    
    StepFrameView *sf = [[StepFrameView alloc] initFourStep:secondStep];
    [self.stepFrameView addSubview:sf];
    [sf.backButton addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];

//    wifiAbility = [Reachability reachabilityForLocalWiFi];
//    [wifiAbility startNotifier];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];

    [[AFNetworkReachabilityManager sharedManager] addObserver:self forKeyPath:@"networkReachabilityStatus" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReloadDevice) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.disconncetView setHidden:YES];
    if(nil != selectedDevice)
    {
        [selectedDevice disconnect];
    }

    [self changeMode:searchingDevice];
    [self performSelector:@selector(onReloadDevice) withObject:nil afterDelay:1];


    [self.loadingView setHidden:YES];

    
    [self checkNetwokStatus];

    isConnect = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.devicesList = nil;

    for(XPGWifiDevice *device in self.deviceService.sortedLanList)
    {
        device.delegate = nil;
    }

}

-(void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] removeObserver:self forKeyPath:@"networkReachabilityStatus"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

// 模式转换方法
// searchingDevice : 正在查找设备
// unfoundDevice   : 查找设备失败
// foundDeviceList : 打印设备列表
- (void)changeMode:(configureViewMode) mode{
    switch (mode) {
        case searchingDevice:
            [self startAnimation];
            [self.searchView  setHidden:NO];
            [self.unfoundView setHidden:YES];
            [self.tableView   setHidden:YES];
            break;
        case unfoundDevice:
            [self.searchView  setHidden:YES];
            [self.unfoundView setHidden:NO];
            [self.tableView   setHidden:YES];
            break;
        case foundDeviceList:
            [self.searchView  setHidden:YES];
            [self.unfoundView setHidden:YES];
            [self.tableView   setHidden:NO];
            break;
        default:
            NSLog(@"Class:SURConfiguredDeviceViewController Method:changeMode Messgae:parameter error");
            break;
    }
}

- (IBAction)configurationDeviceButtonAction:(id)sender {
    isConnect = YES;
    [self checkNetwokStatus];
//    [self reachabilityChanged:nil];


}
- (IBAction)cancelButton:(id)sender {
    [self.disconncetView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate
/*tableView显示个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.devicesList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

/*生成row*/
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *customCellIdentifier = @"selectedDeviceType";
    static NSString *nibIdentifier        = @"SURBindTableViewCell";


    SURBindTableViewCell *cell = (SURBindTableViewCell *)[tableView dequeueReusableCellWithIdentifier:customCellIdentifier];

    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:nibIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:customCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    }
    if (!self.devicesList)
    {
        [self changeMode:searchingDevice];
    }
    else
    {
        if(self.devicesList.count ==  0)
        {
            //显示没有设备
            [self changeMode:unfoundDevice];
        }
        else
        {
            [self changeMode:foundDeviceList];
            XPGWifiDevice *device = self.devicesList[indexPath.row];
            //设置delegate
            device.delegate = self;

            //更新cell
            NSString *labelNameContent = device.productName;
            NSString *selectedTypeProductKey = device.productKey;

            cell.cellLabel.text = labelNameContent;
            if ([selectedTypeProductKey isEqualToString:GIZWaterHeaterProductKey])
            {
                cell.cellImageView.image = [UIImage imageNamed:@"search_device_heater"];
                cell.cellLabel.textColor = SUNRAIN_ORANGE;
            }
            else if ([selectedTypeProductKey isEqualToString:GIZWaterPurifierProductKey])
            {
                cell.cellImageView.image = [UIImage imageNamed:@"search_device_water"];
                cell.cellLabel.textColor = SUNRAIN_BLUE;
            }
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

    XPGWifiDevice *device = [_devicesList objectAtIndex:indexPath.row];
    selectedDevice = device;

//    [self pushToQRViewControllor:device];
    if (![device isBind:_PROCEES_MODEL.uid])
    {
        [GIZCommonUtils showLoadingWithTile:@"绑定中"];
        [self.service bindDeviceForSDKWithDid:device.did passcode:device.passcode remark:@"" completion:^(NSString *did, NSError *err) {
            [GIZCommonUtils hideLoading];
            if(err.code)
            {
                //绑定失败
                NSString *message = [NSString stringWithFormat:@"设备绑定失败，请稍后重试"];
                [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alertView.tag = 101;
                [alertView show];
            }
        }];
    }


}
-(void)pushToQRViewControllor:(XPGWifiDevice *)device{
    [GIZCommonUtils hideLoading];
//    SURQRViewController *qrVC = [[SURQRViewController alloc] initWithDevice:device];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0) {
//        [self.navigationController pushViewController:qrVC animated:NO];
//    }else{
//        [self.navigationController pushViewController:qrVC animated:YES];
//    }
}

#pragma mark 请求
-(void)onReloadDevice
{
    self.devicesList = nil;
    isRefreshed = YES;
    //请求SDK
    [self.service getBoundDeviceListWithProductKey:GIZWaterPurifierProductKey productKey:GIZWaterHeaterProductKey completion:^(NSArray *deviceList, NSError *err)
     {
        if (deviceList.count == 0 || deviceList == nil)
        {
            [self changeMode:unfoundDevice];
            return;
        }
         [self endAnimation];
         self.devicesList = [[deviceList giz_softedLanDevice] mutableCopy];
         self.tableView.userInteractionEnabled = NO;
         //在tabelview 更新数据前
         //筛选小循环设备

         if (self.devicesList != nil) {
             [self changeMode:foundDeviceList];
         }
         //只刷新一次列表
         if (isRefreshed)
         {
             [self.tableView headerEndRefreshing];
             isRefreshed = NO;
         }
         [self.tableView reloadData];
          //在tabelview 更新数据后
         self.tableView.userInteractionEnabled = YES;
     }];
}

-(void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 检查网络
- (void)checkNetwokStatus
{
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            [self.disconncetView setHidden:YES];
            if (isConnect == YES) {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SURConfigure" bundle:nil];
                SURAirLinkViewController *accountManager = [storyBoard instantiateViewControllerWithIdentifier:@"SURAirLink"];
                isConnect = NO;
                [self.navigationController pushViewController:accountManager animated:YES];
            }
            break;
        }
        case AFNetworkReachabilityStatusNotReachable:
        {
            [self.disconncetView setHidden:NO];
            isConnect = NO;
            break;
        }
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"networkReachabilityStatus"])
        [self checkNetwokStatus];
}

#pragma alertView delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 2)] animated:YES];
    }
}

- (IBAction)onReloadList:(id)sender {
    angle = 0;
    [self changeMode:searchingDevice];
    [self performSelector:@selector(onReloadDevice) withObject:nil afterDelay:1.0f];
}
- (void)startAnimation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));

    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _buttonreload.transform = endAngle;
    } completion:^(BOOL finished) {
        if (angle >= 0)
        {
            angle += 7;
            [self startAnimation];
        }
    }];

}

-(void)endAnimation
{
    angle = -1;
}

@end
