#import <Foundation/Foundation.h>
#import "SURControllerService.h"
@interface SURControlServiceImp : NSObject<SURControllerService>

+ (SURControlServiceImp *)sharedService;
@end
