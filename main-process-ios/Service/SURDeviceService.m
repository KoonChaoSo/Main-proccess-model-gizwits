#import "SURDeviceService.h"
#import "GIZProcessModel.h"
#import "NSMutableArray+SURNSMutableArrayExtension.h"
#import <XPGWifiSDK/XPGWifiSDK.h>

static SURDeviceService *sharedService = nil;
@interface SURDeviceService ()

@end
@implementation SURDeviceService

+ (SURDeviceService *)sharedService
{
    if(nil == sharedService)
    {
        sharedService = [[SURDeviceService alloc] init];
    }
    return sharedService;
}

-(NSArray *)softWanOnlineDeviceFromDevicesList:(NSArray *)devicesList{
    NSMutableArray
    *onlineInWanList = [NSMutableArray array];//在线
//    *outlineInWanList = [NSMutableArray array]; //不在线
    
    NSMutableArray *sortedList = [NSMutableArray array];
    
    if(devicesList){
        for(XPGWifiDevice *device in devicesList){
            if (device.isDisabled)
            {
                continue;
            }
            
            if([device isBind:_PROCEES_MODEL.currentUid] && device.isOnline){
                [onlineInWanList addObjectInRemoveDuplicateForSUR:device];
            }
//            else if(!device.isLAN && [device isBind:_PROCEES_MODEL.currentUid] && !device.isOnline){
//                [outlineInWanList addObjectInRemoveDuplicateForSUR:device];
//            }
        }
    }
    
    [sortedList addObjectsFromArray:onlineInWanList];
//    [sortedList addObjectsFromArray:outlineInWanList];
    return [sortedList copy];
}

-(NSMutableArray *)softWanDeviceFromDevicesList:(NSMutableArray *)devicesList{
    NSMutableArray
    *onlineInWanList = [NSMutableArray array], //在线
    *outlineInWanList = [NSMutableArray array]; //不在线
    
    NSMutableArray *sortedList = [NSMutableArray array];
    
    if(devicesList){
        for(XPGWifiDevice *device in devicesList){
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
    return [sortedList mutableCopy];
}

-(NSArray *)softLanDeviceFromDevicesList:(NSArray *)devicesList{
    NSMutableArray *lanList = [[NSMutableArray alloc] init];
    if(devicesList){
        for(XPGWifiDevice *device in devicesList){
            if (device.isDisabled)
            {
                continue;
            }
            if(device.isLAN && ![device isBind:_PROCEES_MODEL.currentUid] && device.isOnline){

                [lanList addObjectInRemoveDuplicateForSUR:device];
            }
        }
    }
    self.sortedLanList = [lanList copy];
    return [lanList copy];
}


@end
