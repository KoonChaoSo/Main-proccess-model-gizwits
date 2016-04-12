
#import <Foundation/Foundation.h>
#import "SURDevicesListService.h"
@interface SURDeviceService : NSObject
@property (nonatomic,strong) NSArray *sortedLanList;

#pragma mark - Static
+ (SURDeviceService *)sharedService;

@end
