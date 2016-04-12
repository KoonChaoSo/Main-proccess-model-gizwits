//
//  GIZRepeatTypeModel.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by Cmb on 14/8/15.
//  Copyright (c) 2015 ChaoSo. All rights reserved.
//

#import "SURRepeatTypeModel.h"
#import "SURPropertyUtils.h"

@implementation SURRepeatTypeModel
@synthesize repeatString = _repeatString;
-(void)setRepeatString:(NSArray *)repeatArray
{
    NSMutableArray *tempList = [NSMutableArray array];
    if (repeatArray.count >= 7)
    {
        for (NSString *str in repeatArray)
        {
            if (![str isEqualToString:@""])
            {
                [tempList addObject:str];
            }
        }
        _repeatString = [tempList componentsJoinedByString:@","];
    }
}

-(NSString *)repeatString
{
    return _repeatString;
}

@end
