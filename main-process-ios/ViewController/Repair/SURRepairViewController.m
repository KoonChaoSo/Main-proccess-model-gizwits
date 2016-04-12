//
//  SURRepairViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 17/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURRepairViewController.h"
#import "GizSDKCommunicateService.h"
#import "SURAppInfo.h"

@interface SURRepairViewController ()<UITextViewDelegate,UIPickerViewDelegate,XPGWifiSDKDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextView  *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *faultText;
@property (weak, nonatomic) IBOutlet UIButton    *deviceButton;
@property (weak, nonatomic) IBOutlet UILabel     *deviceLabel;
@property (strong, nonatomic) NSMutableArray     *deviceArray;
@property (strong, nonatomic) NSMutableArray     *faultsArray;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) NSArray *deviceList;

@property (strong, nonatomic) XPGWifiDevice *selectedDevice;

@end

@implementation SURRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionTextView.delegate  = self;
    self.descriptionTextView.layer.borderColor = [RGB(205, 205, 205) CGColor];
    self.descriptionTextView.layer.borderWidth = 0.5;
    [self.descriptionTextView.layer setCornerRadius:5];
    self.selectedDevice = self.deviceArray[0];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.descriptionTextView.text.length<1) {
        self.descriptionTextView.text = @"请输入问题描述";
        self.descriptionTextView.textColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.descriptionTextView.text isEqualToString:@"请输入问题描述"]) {
        self.descriptionTextView.text = @"";
        self.descriptionTextView.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@" ============ %@",((XPGWifiDevice *)[self.deviceArray objectAtIndex:row]).productName);
    return ((XPGWifiDevice *)[self.deviceArray objectAtIndex:row]).productName;
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSLog(@"%d",[self.deviceArray count]);
       return [self.deviceArray count];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectedDevice = self.deviceArray[row];
    self.deviceLabel.text = self.selectedDevice.productName;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.descriptionTextView resignFirstResponder];
    [self.nameText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.addressText resignFirstResponder];
    [self.faultText resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title                     = @"一键报修";
    [XPGWifiSDK sharedInstance].delegate = self;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    NSError *err;
    GizSDKCommunicateService *service = [[GizSDKCommunicateService alloc] init];
    [service getBoundDeviceListForSDKWithProductKey:SURWaterHeaterProductKey productKey:SURWaterPurifierProductKey error:&err];
}


- (IBAction)onTapDeviceList:(id)sender {
    self.pickerView.hidden = !self.pickerView.hidden;
}

-(void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didDiscovered:(NSArray *)deviceList result:(int)result
{
    if (result == 0)
    {
        self.deviceArray = [deviceList mutableCopy];
    }
    [self.pickerView reloadAllComponents];
}

@end
