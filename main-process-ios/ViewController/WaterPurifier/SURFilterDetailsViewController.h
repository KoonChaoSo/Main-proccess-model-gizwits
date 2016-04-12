//
//  SURFilterDetailsViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 5/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURBaseControlViewController.h"
#import "GizSDKCommunicateService.h"
#import "SURCommonUtils.h"

typedef enum{
    firstArrow,
    secondArrow,
    thirdArrow,
    fourthArrow,
    fifthArrow
}SURArrowModel;

@interface SURFilterDetailsViewController : SURBaseControlViewController<XPGWifiSDKDelegate, XPGWifiDeviceDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) NSInteger selectSerial;
@end
