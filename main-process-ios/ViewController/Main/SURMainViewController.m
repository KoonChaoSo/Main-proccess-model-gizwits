//
//  SURMainViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/29.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURMainViewController.h"
#import "GizSDKCommunicateService.h"
#import "SURDeviceService.h"
#import "SURDeviceCell.h"
#import "SURFeatureFuntionTableViewCell.h"
#import "UIView+SURUIViewExtension.h"
#import "GIZAppInfo.h"
#import "GIZCommonUtils.h"

#import "SURRequestRepairCell.h"
#import "SURShoppingOnlineTableViewCell.h"
#import "SlideNavigationController.h"

#import "MJRefresh.h"
#import "ImagesCircleView.h"
#import "SURWebViewController.h"
#import "UIAlertView+SURUIAlertView.h"
#import "NSArray+GizNSArray.h"
#import "XPGWifiDevice+SDKExtension.h"
#import "GIZDeviceListViewController.h"


//#define SECTION_HEADER_VIEW             0
#define SECTION_MY_DEVICE               0
#define SECTION_ONLINE_SHOPPING         2
#define SECTION_REQUEST_REPAIR          1
#define SECTION_FEATURE_FUNCTION        3


static BOOL isRefreshed = NO;
@interface SURMainViewController ()<XPGWifiSDKDelegate,XPGWifiDeviceDelegate,ImagesCircleViewDelegate>
{
    NSArray *headerTitles;
    XPGWifiDevice *selectedDevice;
    BOOL isLockDiscovery;
    UIWebView *webView;
    NSArray *onlineShopArrayTitle;
}
@property (strong, nonatomic) GIZSDKCommunicateService *service;
@property (strong, nonatomic) SURDeviceService *deviceService;

@property (nonatomic, strong) ImagesCircleView *imageCicleView;
@property (strong, nonatomic) NSArray *devicesList;
@end

@implementation SURMainViewController

#pragma mark Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.service = [GIZSDKCommunicateService sharedInstance];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configureLeftItem];
    [self configureCustomNavigationItem];
    [self configureTableViewHeaderView:nil advertisementImage:nil];
    
    headerTitles = @[@"我的设备",@"",@"",@""];
    onlineShopArrayTitle = @[@"太阳雨官方商城  太阳能一切",@"热门商城   科技让生活回归自然"];
    
    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self onReloadDeviceList];
    }];
    
    //添加右按钮
    self.navigationItem.hidesBackButton = YES;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.tableview.mj_header beginRefreshing];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [GIZCommonUtils hideLoading];
}

#pragma mark - Main View Configure
-(void)configureCustomNavigationItem
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    titleImageView.frame = titleView.frame;
    [titleView addSubview:titleImageView];
    self.navigationItem.titleView = titleView;
}

-(void)configureLeftItem
{
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,25)];
    [leftButton setImage:[UIImage imageNamed:@"me_photo"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}


-(void)configureTableViewHeaderView:(UIImage *)userInfoImage advertisementImage:(UIImage *)adervertisementImage
{
    _imageCicleView = [[ImagesCircleView alloc] initWithFrame:CGRectMake(0, 22, kScreen_Width, 150)];
    _imageCicleView.pagingEnabled = YES;
    _imageCicleView.backgroundColor = [UIColor colorWithRed:0xf9/255.0 green:0xf9/255.0 blue:0xfa/255.0 alpha:1];
    _imageCicleView.showsHorizontalScrollIndicator = NO;
    _imageCicleView.bounces = NO;
    _imageCicleView.scrollsToTop = NO;
    _imageCicleView.imagesCircleDelegate = self;
    
    _imageCicleView.imageInfos = @[@"e+_top_image1", @"e+_top_image2",@"e+_top_image1",@"e+_top_image4"];
    
    /**
     *  轮询时间间隔 设置为0自动停止
     */
    _imageCicleView.duration = 8;
    //    [self.tableview.tableHeaderView addSubview:userImageView];
    
    self.tableview.tableHeaderView = _imageCicleView;
}

#pragma mark - DataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_MY_DEVICE || section == SECTION_ONLINE_SHOPPING)
    {
        NSString *sectionTitle = headerTitles[section];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                                0.0,
                                                                kScreen_Width,
                                                                100.0)];
        view.backgroundColor = [UIColor whiteColor];
        // Create label with section title
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(25.0,
                                 8.0,
                                 150,
                                 24.0);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0];
        label.text = sectionTitle;
        label.textColor = RGB(108, 108, 108);
        label.backgroundColor = [UIColor clearColor];
        
        [view addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, view.frame.size.width, 1)];
        lineView.backgroundColor = RGB(230, 230, 230);
        [view addSubview:lineView];
        
        if (section == SECTION_MY_DEVICE)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width - 100, 5.0, 80, 28)];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [view addSubview:btn];
            [btn setTitle:@"添加" forState:UIControlStateNormal];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            btn.titleLabel.font = [UIFont systemFontOfSize:10.f];
            [btn setBackgroundImage:[UIImage imageNamed:@"e+_button_add"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pushSelectedDeviceList) forControlEvents:UIControlEventTouchUpInside];
        }
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_MY_DEVICE)
    {
        return 40;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_ONLINE_SHOPPING)
    {
        return 80;
    }
    else if (indexPath.section == SECTION_FEATURE_FUNCTION)
    {
        return 80;
    }
    else if (indexPath.section == SECTION_REQUEST_REPAIR)
    {
        return 80;
    }
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == SECTION_MY_DEVICE)
    {
        if (self.devicesList.count == 0)
        {
            return 1;
        }
        else
        {
            return [self.devicesList count];
        }
    }
    if (section == SECTION_ONLINE_SHOPPING)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *deviceCell = @"deviceInfoCell";
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deviceCell];
    XPGWifiDevice *device = nil;
    if (indexPath.row < self.devicesList.count)
    {
        device = self.devicesList[indexPath.row];
    }

    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"SURDeviceCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:deviceCell];
        cell = [tableView dequeueReusableCellWithIdentifier:deviceCell];
    }
    if (!device)
    {
        [(SURDeviceCell *)cell updateToNoneDevice];
        return cell;
    }
    if ([cell isKindOfClass:[SURDeviceCell class]])
    {
        [(SURDeviceCell *)cell updateDeviceTableViewCellWithOnline:device];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == SECTION_MY_DEVICE)
    {
        if (self.devicesList.count != 0)
        {
            selectedDevice = self.devicesList[indexPath.row];
            BOOL isOnline = selectedDevice.isOnline;
//            if (!isOnline)
//            {
//                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不在线" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//                return ;
//            }
            [GIZCommonUtils showLoadingWithTile:@"正在登录设备"];
            
            [selectedDevice giz_loginDeviceWithCompletion:^(XPGWifiDevice *device, NSError *err) {
                [GIZCommonUtils hideLoading];
                if(err.code == XPGWifiError_NONE)
                {
                    //登录成功
                    [self pushToControl:selectedDevice];
                }
                else
                {
                    //登录失败
                    NSString *message = @"登录设备失败";
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }

            }];
        }
        else
        {
            [self pushSelectedDeviceList];
            return ;
        }
    }
}

#pragma mark - Main And SDK Method
/**
 *  发现设备成功
 *
 *  @param deviceList 发现设备列表
 */
-(void)discoveryDeviceListSuccess:(NSArray *)deviceList
{
    if (!isLockDiscovery)
    {
        [self performSelector:@selector(discoveryToShow:) withObject:deviceList afterDelay:5.0];
    }
    else
    {
        [self.tableview.mj_header endRefreshing];
        [GIZCommonUtils hideLoading];
        return ;
    }
}

/**
 *  发现设备失败
 */
-(void)discoveryDeviceListFail
{
    [GIZCommonUtils hideLoading];
    if (isRefreshed)
    {
        [self.tableview.mj_header endRefreshing];
        isRefreshed = NO;
    }
}
/**
 *  加载设备列表
 */
-(void)onReloadDeviceList
{
    [self unLockDiscovery];
    
    isRefreshed = YES;
    
    [self.service getBoundDeviceListWithProductkeyList:@[@"6f3074fe43894547a4f1314bd7e3ae0b",GIZWaterHeaterProductKey] completion:^(NSArray *deviceList, NSError *err, BOOL **stop)
    {
        if (err.code == 0)
        {
            [self discoveryDeviceListSuccess:deviceList];
        }
        else
        {
            [self discoveryDeviceListFail];
        }
    }];
}


-(void)disconnectAllDevice:(NSArray *)deviceList
{
    for (XPGWifiDevice *dev in deviceList)
    {
        if (dev.isConnected)
        {
            dev.delegate = self;
            [dev disconnect];
        }
    }
}

-(void)discoveryToShow:(id)deviceList
{
    
    [GIZCommonUtils hideLoading];
    [self lockDiscovery];
    
    [self.tableview.mj_header endRefreshing];
    
    self.devicesList = [deviceList giz_softedWanDevice];
    [self disconnectAllDevice:self.devicesList];
    [self.tableview reloadData];
    [self unLockDiscovery];
}

- (void)lockDiscovery
{
    isLockDiscovery = YES;
}
- (void)unLockDiscovery
{
    [self.service stopDiscovery];
    isLockDiscovery = NO;
}

#pragma mark - delegate
#pragma mark - did Tap
- (void)scrollImagesDidSelectItemInfo:(id)info {
    NSLog(@"%@ did Tap", info);
}

#pragma mark dataSours
- (void)scrollImagesFromView:(UIView *)view info:(id)info {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:info]];
    view.backgroundColor = [UIColor whiteColor];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.frame = CGRectMake(0, 0, kScreen_Width, view.frame.size.height);
    [view addSubview:imageView];
}

#pragma mark -Action
-(void)pushSelectedDeviceList
{
    UIStoryboard *bindStoryboard = [UIStoryboard storyboardWithName:@"GIZMainFlow" bundle:nil];
    GIZDeviceListViewController *productTypeVC = [bindStoryboard instantiateViewControllerWithIdentifier:@"SURConfiguredDevice"];
    [self.navigationController pushViewController:productTypeVC animated:YES];
}

-(void)toggleLeftMenu
{
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}


@end

