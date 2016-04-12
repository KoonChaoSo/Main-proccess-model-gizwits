//
//  SURHeaterEditInfraredDetectionViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 10/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SURBaseControlViewController.h"
#import "SURUtils.h"

@interface SURHeaterEditInfraredDetectionViewController : SURBaseControlViewController

// 获取的数据标识点
@property (strong, nonatomic)NSString *appointmentRunTime;
@property (strong, nonatomic)NSString *appointmentStopTime;
@property (strong, nonatomic)NSString *appointmentSet;

@end
