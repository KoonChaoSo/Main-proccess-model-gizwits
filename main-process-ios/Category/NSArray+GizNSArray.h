//
//  NSArray+GizNSArray.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/11/24.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (GizNSArray)

/**
 *  筛选大循环在线设备
 *
 *  @return 筛选后的设备
 */
-(NSArray *)giz_softedWanOnlineDevice;

/**
 *  筛选大循环设备
 *
 *  @return 筛选后的设备
 */
-(NSArray *)giz_softedWanDevice;

/**
 *  筛选小循环设备
 *
 *  @return 筛选后的设备
 */
-(NSArray *)giz_softedLanDevice;
@end
