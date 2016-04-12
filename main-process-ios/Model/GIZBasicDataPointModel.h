//
//  GIZBaseModel.h
//  main-process-ios
//
//  Created by ChaoSo on 16/2/29.
//  Copyright © 2016年 gitzwits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GIZBasicDataPointModel : JSONModel
+ (GIZBasicDataPointModel *)sharedModel;
@end
