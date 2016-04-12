//
//  NSMutableArray+GIZNSMutableArrayExtension.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/8/6.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "NSMutableArray+SURNSMutableArrayExtension.h"
#import <XPGWifiSDK/XPGWifiSDK.h>
@implementation NSMutableArray (SURNSMutableArrayExtension)

-(NSMutableArray *)addObjectInRemoveDuplicateForSUR:(id)obj{
    int unEqualCount = 0;
    //判断obj是否XPGWIFIDevice
    if([obj isKindOfClass:[XPGWifiDevice class]]){
        //遍历self
        for(id deviceInArray in self){
//            再判断deviceInArray是否是XPGWifiDevice
            if([deviceInArray isKindOfClass:[XPGWifiDevice class]])
            {
                //判断两个device是否相等
                BOOL isEqualDid = [((XPGWifiDevice *)deviceInArray).did isEqualToString:((XPGWifiDevice *)obj).did];
                //不相等的时候就addObject
                if(!isEqualDid){
                    unEqualCount ++;
                    continue;
                }else
                {
                    break;
                }
            }
        }
        if(unEqualCount == self.count){
            [self addObject:obj];
        }
    }
    return self;
}
@end
