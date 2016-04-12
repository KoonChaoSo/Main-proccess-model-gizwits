//
//  SURMainTableViewCell.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/30.
//  Copyright © 2015年 Sunrain. All rights reserved.
//
#import <UIKit/UIGraphics.h>

#import "SURDeviceCell.h"
#import "GIZAppInfo.h"
#import "GIZUtils.h"
#import "UIView+SURUIViewExtension.h"

@implementation SURDeviceCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)updateDeviceWithoutOnline:(XPGWifiDevice *)device
{
    [self updateDeviceTableViewCell:device accordingOnline:NO];
}

- (void)updateDeviceTableViewCell:(XPGWifiDevice *)device
                  accordingOnline:(BOOL)accordingOnline
{
    NSString *labelNameContent = device.productName;
    NSString *deviceRemark = device.remark;
    
    NSString *macAddr = device.macAddress;
    NSString *selectedTypeProductKey = device.productKey;
    self.addBtnImageView.hidden = YES;
    
    NSString *deviceName = @"";
    if ([deviceRemark isEqualToString:@""])
    {
        deviceName = [NSString stringWithFormat:@"%@",labelNameContent];
    }
    else
    {
        deviceName = [NSString stringWithFormat:@"%@",deviceRemark];
    }
    
    self.labelDeviceName.text = deviceName;
    
    
    if ([selectedTypeProductKey isEqualToString:@"cf20195fdb364789a45d00c9d31e9437"])
    {
        if (!device.isOnline && accordingOnline)
        {
            self.imageViewDeviceImage.image = [UIImage imageNamed:@"search_device_heater_off_ps"];
            self.labelDeviceName.textColor = SUNRAIN_GRAY;
            self.onlineStatus.text = @"离线";
            self.onlineStatus.textColor = SUNRAIN_GRAY;
        }
        else
        {
            self.imageViewDeviceImage.image = [UIImage imageNamed:@"search_device_heater"];
            self.labelDeviceName.textColor = SUNRAIN_ORANGE;
            if (accordingOnline)
            {
                self.onlineStatus.text = @"在线";
                self.onlineStatus.textColor = SUNRAIN_ORANGE;
            }
        }
        
    }
    else if ([selectedTypeProductKey isEqualToString:GIZWaterPurifierProductKey  ])
    {
        if (!device.isOnline && accordingOnline)
        {
            self.imageViewDeviceImage.image = [UIImage imageNamed:@"search_device_water_off_ps"];
            self.labelDeviceName.textColor = SUNRAIN_GRAY;
            self.onlineStatus.text = @"离线";
            self.onlineStatus.textColor = SUNRAIN_GRAY;
        }
        else
        {
            self.imageViewDeviceImage.image = [UIImage imageNamed:@"search_device_water_ps"];
            self.labelDeviceName.textColor = SUNRAIN_BLUE;
            if (accordingOnline)
            {
                self.onlineStatus.text = @"在线";
                self.onlineStatus.textColor = SUNRAIN_BLUE;
            }
            

        }
        
        
    }
}
-(void)updateDeviceTableViewCellWithOnline:(XPGWifiDevice *)device
{
    [self updateDeviceTableViewCell:device accordingOnline:YES];
}

- (void)openGesture{
    self.isOpenGesture = YES;
//    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//     [self.gestureView addGestureRecognizer:panGes];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(self.isOpenGesture){
        if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
            return NO;
        }
        CGPoint translation = [(UIPanGestureRecognizer *)otherGestureRecognizer translationInView:self];
        if (translation.x>0) {
            [self.editView setHidden:YES];
        }
        if(translation.x<0){
            [self.editView setHidden:NO];
        }
    }
    return YES;
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.gestureView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.gestureView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.gestureView];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y)); 
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.gestureView.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.gestureView.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];
    }
}


-(void)updateToNoneDevice
{
    self.imageViewDeviceImage.image = [UIImage imageNamed:@"search_device_heater_p"];
    self.addBtnImageView.hidden = NO;
    self.labelDeviceName.text = @"您还没有添加设备？";
    self.onlineStatus.text = @"";
    self.labelDeviceName.textColor = SUNRAIN_OCEAN_BLUE;
}

-(void)updateBackgroundView
{
    [self.deviceBackgroundView.layer setBorderWidth:1];
    [self.deviceBackgroundView.layer setBorderColor:RGB(221, 221, 221).CGColor];
    [self.deviceBackgroundView setRoundCornerWithRadius:5];
}



@end