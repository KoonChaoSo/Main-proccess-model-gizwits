//
//  SURMainTableViewCell.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/30.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface SURDeviceCell : SWTableViewCell<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDeviceImage;
@property (weak, nonatomic) IBOutlet UIView *deviceBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *imageBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewArrow;
@property (weak, nonatomic) IBOutlet UILabel *macAddrName;
@property (weak, nonatomic) IBOutlet UIView  *gestureView;
@property (assign, nonatomic) BOOL isOpenGesture;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UILabel *onlineStatus;
@property (weak, nonatomic) IBOutlet UIImageView *addBtnImageView;

-(void)updateDeviceTableViewCellWithOnline:(XPGWifiDevice *)device;
-(void)updateDeviceWithoutOnline:(XPGWifiDevice *)device;
- (void)openGesture;
-(void)updateToNoneDevice;
@end
