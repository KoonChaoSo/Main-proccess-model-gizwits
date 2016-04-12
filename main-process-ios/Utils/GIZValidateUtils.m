//
//  GIZValidateUtils.m
//  Gizwits-HeatingApparatu
//
//  Created by ChaoSo on 15/7/22.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "GIZValidateUtils.h"
#import "sys/utsname.h"


static GIZValidateUtils *sharedUtils = nil;
@implementation GIZValidateUtils

+ (GIZValidateUtils *)sharedUtils
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedUtils == nil)
        {
            sharedUtils = [[GIZValidateUtils alloc] init];
        }
    });
    return sharedUtils;
}


- (BOOL)validatePhone13:(NSString *)phone
{
    NSString *regex = @"13\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phone];
}

- (BOOL)validatePhone15:(NSString *)phone
{
    NSString *regex = @"15\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phone];
}

- (BOOL)validatePhone17:(NSString *)phone
{
    NSString *regex = @"17\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phone];
}

- (BOOL)validatePhone18:(NSString *)phone
{
    NSString *regex = @"18\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phone];
}

- (BOOL)validatePhone:(NSString *)phone
{
    return [self validatePhone13:phone] ||
    [self validatePhone15:phone] ||
    [self validatePhone17:phone] ||
    [self validatePhone18:phone];
}

- (BOOL)validateEmailFormat:(NSString *)email
{
    NSString *regex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:email];
}

- (BOOL)validateEmail:(NSString *)email
{
    return [self validateEmailFormat:email] &&
    ([email hasSuffix:@".com"] ||
     [email hasSuffix:@".cn"] ||
     [email hasSuffix:@".net"] ||
     [email hasSuffix:@".com.cn"]);
}

- (BOOL)validatePassword:(NSString *)password
{
    NSString *regex = @"^[\\x10-\\x1f\\x21-\\x7f]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password];
}

- (SUROSVersion)validateOSVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString rangeOfString:@"iPhone3"].length > 0)    return UIDeviceiPhone4sOS;
    if ([deviceString rangeOfString:@"iPhone4"].length > 0)    return UIDeviceiPhone4sOS;
    if ([deviceString rangeOfString:@"iPhone5"].length > 0)    return UIDeviceiPhone5OS;
    if ([deviceString rangeOfString:@"iPhone6"].length > 0)    return UIDeviceiPhone5OS;
    if ([deviceString rangeOfString:@"iPhone7"].length > 0)    return UIDeviceiPhone6OS;
    if ([deviceString rangeOfString:@"iPhone7"].length > 0)    return UIDeviceiPhone6OS;
    else{
        return UIDeviceUnknowOS;
    }
}
- (BOOL)validateCamera {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

-(BOOL)validateLenghtString:(NSString *)str min:(NSInteger)min max:(NSInteger)max
{
    return str.length >= min && str.length <= max;
}
@end
