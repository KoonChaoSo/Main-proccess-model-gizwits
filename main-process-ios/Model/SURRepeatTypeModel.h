//
//  GIZRepeatTypeModel.h
//  GizOpenAppV2-HeatingApparatus
//
//  Created by Cmb on 14/8/15.
//  Copyright (c) 2015 ChaoSo. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - HACK
@interface SURRepeatTypeModel : NSObject

// 类型枚举
typedef enum{
    RepeatNone = 0,
    RepeatOnce  = 1,
    RepeatEveryday = 2,
    RepeatWorkingday = 3,
    RepeatCustom = 4
}SURRepeatTypeEnum;

// 类型枚举
typedef enum{
    isDetail = 0,
    isAbract
}timeTypeEnum;

// 类型
@property(assign, nonatomic) SURRepeatTypeEnum repeatType;

//七日的记录
@property(assign, nonatomic) BOOL mon;
@property(assign, nonatomic) BOOL tue;
@property(assign, nonatomic) BOOL wed;
@property(assign, nonatomic) BOOL thu;
@property(assign, nonatomic) BOOL fri;
@property(assign, nonatomic) BOOL sat;
@property(assign, nonatomic) BOOL sun;

@property (strong, nonatomic) NSString *repeatString;

// 时间类型
@property(assign, nonatomic) timeTypeEnum timeType;
// 时间文字
@property(strong, nonatomic) NSString* timeText;

@end


