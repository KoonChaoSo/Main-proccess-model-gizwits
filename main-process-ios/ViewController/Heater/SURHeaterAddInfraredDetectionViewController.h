//
//  SURHeaterAddInfraredDetectionViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 10/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SURBaseControlViewController.h"
#import "SURUtils.h"

@interface SURHeaterAddInfraredDetectionViewController : SURBaseControlViewController
@property (strong, nonatomic) NSString *infraredDetectionStartTimePoint;
@property (strong, nonatomic) NSString *infraredDetectionEndTimePoint;
@property (strong, nonatomic) NSString *infraredDetectionSetPoint;

@end
