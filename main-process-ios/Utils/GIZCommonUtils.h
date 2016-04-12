//
//  GIZCommonUtils.h
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/7/29.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GIZAppInfo.h"

@interface GIZCommonUtils : NSObject

+(void)showLoadingWithTile:(NSString *)title;
+(void)showLoading;
+(void)hideLoading;
+(NSString *)transEngStrToDate:(NSString *)dateEngStr time:(NSString *)setTime date:(NSString *)setDate;
+(id)getPlistWithName:(NSString *)name;
@end
