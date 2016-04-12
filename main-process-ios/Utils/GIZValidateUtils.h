//
//  GIZValidateUtils.h
//  Gizwits-HeatingApparatu
//
//  Created by ChaoSo on 15/7/22.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GIZAppInfo.h"

@interface GIZValidateUtils : NSObject

+ (GIZValidateUtils *)sharedUtils;

/**
 * @brief 验证用户是电话还是邮箱，还是什么都不是
 */
- (BOOL)validatePhone:(NSString *)phone;
- (BOOL)validateEmail:(NSString *)email;
- (BOOL)validatePassword:(NSString *)password;
- (SUROSVersion)validateOSVersion;
- (BOOL)validateCamera;
- (BOOL)validateLenghtString:(NSString *)str min:(NSInteger)min max:(NSInteger)max;
@end
