//
//  GIZBaseModel.m
//  main-process-ios
//
//  Created by ChaoSo on 16/2/29.
//  Copyright © 2016年 gitzwits. All rights reserved.
//

#import "GIZBasicDataPointModel.h"

@implementation GIZBasicDataPointModel
+ (GIZBasicDataPointModel *)sharedModel
{
    static GIZBasicDataPointModel *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
