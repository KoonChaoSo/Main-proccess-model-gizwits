//
//  NSTimer+GIZTimer.h
//  sunrainapp_ios
//
//  Created by Jubal on 15/12/24.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (GIZTimer)

+ (NSTimer *)giz_scheduledTimerWithTimerInterval:(NSTimeInterval)intrtval
                                           block:(void(^)())block
                                         repeats:(BOOL)repeats;

@end
