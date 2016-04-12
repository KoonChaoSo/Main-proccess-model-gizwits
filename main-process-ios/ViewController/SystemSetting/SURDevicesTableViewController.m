//
//  SURDevicesTableViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/26.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURDevicesTableViewController.h"
#import "SURDeviceInfoViewController.h"
#import "SURConfiguredDeviceViewController.h"
#import "GizSDKCommunicateService.h"
#import "SURDeviceService.h"
#import "SURDeviceCell.h"
#import "SURAppInfo.h"
#import "CommonAlertViewController.h"

@interface SURDevicesTableViewController ()<XPGWifiSDKDelegate,SWTableViewCellDelegate,UITextFieldDelegate>

@property (strong , nonatomic) GizSDKCommunicateService *service;
@property (strong , nonatomic) SURDeviceService *deviceService;
@property (strong , nonatomic) NSMutableArray *deviceList;
@property (weak, nonatomic) IBOutlet UIView *renameView;
@property (weak, nonatomic) IBOutlet UITextField *renameText;
@property (weak, nonatomic) IBOutlet UIButton *renameCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *renamecConfirmButton;

@property (strong, nonatomic) XPGWifiDevice *selectedDevice;
@property (strong, nonatomic) CommonAlertViewController *alerViewController;
@end

@implementation SURDevicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.service = [[SURCommonService alloc] init];
    self.deviceService = [[SURDeviceService alloc] init];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add"] style:UIBarButtonItemStyleDone target:self action:@selector(onAddDevice)];
    [rightBarButton setTitlePositionAdjustment:UIOffsetMake(-20, -10) forBarMetrics:UIBarMetricsCompact];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.navigationItem.title = @"设备管理";
    
    [self configureBackView];
    if(self.deviceList.count > 0)
    {
        self.tableView.backgroundView.hidden = YES;
    }
    else
    {
        self.tableView.backgroundView.hidden = NO;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [XPGWifiSDK sharedInstance].delegate = self;
    self.navigationController.navigationBarHidden = NO;
    [self onReload];
    [self.renameView setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XPGWifiSDK sharedInstance].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)onReload
{
    NSError *error;
    [self.service getBoundDeviceListForSDKWithProductKey:SURWaterHeaterProductKey productKey:SURWaterPurifierProductKey error:&error];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.deviceList.count > 0)
    {
        self.tableView.backgroundView.hidden = YES;
    }
    else
    {
        self.tableView.backgroundView.hidden = NO;
    }

    
    return [self.deviceList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *customCellIdentifier = @"deviceInfoCell";
    static NSString *nibIdentifier        = @"SURDeviceCell";
    
    XPGWifiDevice *device = nil;
    if (indexPath.row < self.deviceList.count)
    {
        device = self.deviceList[indexPath.row];
    }
    if (device == nil)
    {
        NSLog(@"error for deviceList");
        return nil;
    }
    
     SURDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    if (cell == nil) {

        UINib *nib = [UINib nibWithNibName:nibIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:customCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    }
    if ([cell isKindOfClass:[SURDeviceCell class]])
    {
        [(SURDeviceCell *)cell updateDeviceWithoutOnline:device];
    }
    cell.tag = indexPath.row;
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60.0f];
    cell.delegate = self;
    
    
       return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
     [rightUtilityButtons sw_addUtilityButtonWithColor:
      [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0]
                                                 icon:[UIImage imageNamed:@"device_list_button_delete_word"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0f]
                                            icon:[UIImage imageNamed:@"device_list_button_rename_word"]];
    
    return rightUtilityButtons;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.deviceList removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }else {
//        NSLog(@"Unhandled editing style! %d", editingStyle);
//    }
//}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // 取消选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"toSettingDevice" sender:indexPath];
}

#pragma  SDK delegate
-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK
    didDiscovered:(NSArray *)deviceList
           result:(int)result
{
    if (!result)
    {
        self.deviceList = [self.deviceService softWanDeviceFromDevicesList:deviceList];
        [self.tableView reloadData];
    }
}


#pragma mark - custom
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SURDeviceInfoViewController *infoViewController = segue.destinationViewController;
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    XPGWifiDevice *selectedDevice = self.deviceList[indexPath.row];
    if ([infoViewController respondsToSelector:@selector(setSelectedDevice:)])
    {
        [infoViewController setValue:selectedDevice forKey:@"selectedDevice"];
    }
}

-(void)onAddDevice
{
    UIStoryboard *bindStoryboard = [UIStoryboard storyboardWithName:@"SURBind" bundle:nil];
    SURConfiguredDeviceViewController *productTypeVC = [bindStoryboard instantiateViewControllerWithIdentifier:@"SURConfiguredDevice"];
    [self.navigationController pushViewController:productTypeVC animated:YES];
}

- (IBAction)renameCancelButtonAction:(id)sender {
    [self.renameView setHidden:YES];
    [self.renameText resignFirstResponder];
}
- (IBAction)renameConfirmButtonAction:(id)sender {
    [self.renameView setHidden:YES];
    
    UIButton *btn = (UIButton *)sender;
    XPGWifiDevice *device = nil;
    if (btn.tag < self.deviceList.count)
    {
        device = self.deviceList[btn.tag];
    }
    if (device == nil)
    {
        NSLog(@"error for deviceList");
        return;
    }

    [self onSaveRemark:device name:self.renameText.text];
}

-(void)onSaveRemark:(XPGWifiDevice *)device name:(NSString *)name
{
    NSError *err;
    [self.service bindDeviceForSDKWithDid:device.did passcode:device.passcode remark:name error:&err];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    XPGWifiDevice *device = nil;
    if (cell.tag < self.deviceList.count)
    {
        device = self.deviceList[cell.tag];
    }
    if (device == nil)
    {
        NSLog(@"error for deviceList");
        return;
    }
    switch (index) {
        case 0:
        {
            _selectedDevice = device;
            self.alerViewController = [[CommonAlertViewController alloc] init];
            [self.alerViewController showWithContent:@"是否删除该设备" title:@"温謦提示" delegate:self];
            
//            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            [self configureDeviceName:device];
            self.renamecConfirmButton.tag = cell.tag;
            [self.renameView setHidden:NO];
            
            
            break;
        }
        default:
            break;
    }
}


-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUnbindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    if (![error intValue])
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除设备成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alerView.tag = 102;
        [alerView show];
        
        [self onReload];
    }
    else
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除设备失败，请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
    
}


-(void)configureDeviceName:(XPGWifiDevice *)device
{
    NSString *remark = device.remark;
    NSString *productName = device.productName;
    
    if ([remark isEqualToString:@""])
    {
        self.renameText.text = productName;
    }
    else
    {
        self.renameText.text = remark;
    }
}

-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didBindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage
{
    [self.renameView setHidden:YES];
    if (!error.intValue)
    {
        NSString *message = @"保存成功";
        [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//
//        [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] - 2)] animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSString *message = @"保存失败,请稍后再试！";
        [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)configureBackView
{
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UILabel *noneDevice = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width,200)];
    noneDevice.textAlignment = NSTextAlignmentCenter;
    noneDevice.text = @"您还没有添加设备?";
    [self.tableView.backgroundView addSubview:noneDevice];
}

-(void)commonAlertView:(CommonAlertViewController *)commonAlertView
{
    [commonAlertView hideAlertView];
    NSError *error ;
    [self.service unbindDeviceForSDKWithDid:_selectedDevice.did passcode:_selectedDevice.passcode error:&error];
    if (error.code == kSURCommonNormalError)
    {
        NSLog(@"isn't delegate");
    }
    if (error.code == kSURCommonIsNotLogined)
    {
        NSLog(@"isn't logined");
    }
}
@end
