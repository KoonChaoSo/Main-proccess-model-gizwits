//
//  NSArray+GizNSArray.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/11/24.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "NSArray+GizNSArray.h"
#import "NSMutableArray+SURNSMutableArrayExtension.h"

@implementation NSArray (GizNSArray)

-(NSArray *)giz_softedWanOnlineDevice{
    NSMutableArray
    *onlineInWanList = [NSMutableArray array];//在线
    //    *outlineInWanList = [NSMutableArray array]; //不在线
    
    if(self){
        for(XPGWifiDevice *device in self){
            if (device.isDisabled)
            {
                continue;
            }
            
            if([device isBind:_PROCEES_MODEL.currentUid] && device.isOnline){
                [onlineInWanList addObjectInRemoveDuplicateForSUR:device];
            }
        }
    }
    return [onlineInWanList copy];
}

-(NSArray *)giz_softedWanDevice{
    NSMutableArray
    *onlineInWanList = [NSMutableArray array], //在线
    *outlineInWanList = [NSMutableArray array]; //不在线
    
    NSMutableArray *sortedList = [NSMutableArray array];
    
    if(self){
        for(XPGWifiDevice *device in self){
            if (device.isDisabled)
            {
                continue;
            }
            
            if([device isBind:_PROCEES_MODEL.currentUid] && device.isOnline){
                [onlineInWanList addObjectInRemoveDuplicateForSUR:device];
            }
            else if(!device.isLAN && [device isBind:_PROCEES_MODEL.currentUid] && !device.isOnline){
                [outlineInWanList addObjectInRemoveDuplicateForSUR:device];
            }
        }
    }
    
    [sortedList addObjectsFromArray:onlineInWanList];
    [sortedList addObjectsFromArray:outlineInWanList];
    return [sortedList copy];
}

-(NSArray *)giz_softedLanDevice{
    NSMutableArray *lanList = [[NSMutableArray alloc] init];
    if(self){
        for(XPGWifiDevice *device in self){
            if (device.isDisabled)
            {
                continue;
            }
            if(device.isLAN && ![device isBind:_PROCEES_MODEL.currentUid] && device.isOnline)
            {
                [lanList addObjectInRemoveDuplicateForSUR:device];
            }
        }
    }
    return [lanList copy];
}

@end
