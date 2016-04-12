//
//  SURHeaterAddTimingViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 9/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SURBaseControlViewController.h"

typedef enum{
    SURHeaterAddTimingPickerView,
    SURHeaterAddTimingDatePicker,
    SURHeaterAddTimingNone,
}SURHeaterAddTimingMode;

@interface SURHeaterAddTimingViewController : SURBaseControlViewController

@property (strong, nonatomic)NSString *appointmentTemp;
@property (strong, nonatomic)NSString *appointmentTime;

@property (strong, nonatomic)NSString *tempValue;
@property (strong, nonatomic)NSString *dateValue;


@end
