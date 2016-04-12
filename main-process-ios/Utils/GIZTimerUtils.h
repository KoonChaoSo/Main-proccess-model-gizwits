//
//  SURTimerUtils.h
//  sunrainapp_ios
//
//  Created by 余振邦 on 15/12/24.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIZTimerUtils : NSTimer

+ (NSTimer *)GIZ_scheduledTimerWithTimerInterval:(NSTimeInterval)intrtval
                                       block:(void(^)())block
                                     repeats:(BOOL)repeats;

@end
