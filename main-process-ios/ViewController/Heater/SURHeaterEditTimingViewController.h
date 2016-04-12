//
//  SURHeaterEditTimingViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 9/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SURHeaterEditTimingPickerView,
    SURHeaterEditTimingDatePicker,
    SURHeaterEditTimingNone,
}SURHeaterAddTimingMode;

@interface SURHeaterEditTimingViewController : UIViewController

@property (strong,nonatomic)  NSString* identificationName;

@end
