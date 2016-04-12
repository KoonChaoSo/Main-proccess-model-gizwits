//
//  NSTimer+GIZTimer.m
//  sunrainapp_ios
//
//  Created by Jubal on 15/12/24.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "NSTimer+GIZTimer.h"

@implementation NSTimer (GIZTimer)

+ (NSTimer *)giz_scheduledTimerWithTimerInterval:(NSTimeInterval)intrtval
                                           block:(void(^)())block
                                         repeats:(BOOL)repeats{
    
    return [self scheduledTimerWithTimeInterval:intrtval target:self selector:@selector(countDownTimer:) userInfo:block repeats:repeats];
    
    
}

+ (void)countDownTimer:(NSTimer *)time
{
    void (^block)() = time.userInfo;
    if (block) {
        block();
    }
}



@end
