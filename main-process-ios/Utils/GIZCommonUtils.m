//
//  GIZCommonUtils.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/7/29.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "GIZCommonUtils.h"
#import "AppDelegate.h"
@interface GIZCommonUtils()
@property (nonatomic,strong) NSDictionary *dateDic;
@end

@implementation GIZCommonUtils


+(NSString *)transEngStrToDate:(NSString *)dateEngStr time:(NSString *)setTime date:(NSString *)setDate
{
    GIZCommonUtils *utils = [[GIZCommonUtils alloc] init];
    utils.dateDic = @{@"mon" : @"周一" ,
                      @"tue" : @"周二" ,
                      @"wed" : @"周三" ,
                      @"thu" : @"周四" ,
                      @"fri" : @"周五" ,
                      @"sat" : @"周六" ,
                      @"sun" : @"周日" };
    
    
    NSArray *dateList = [dateEngStr componentsSeparatedByString:@","];
    NSMutableString *date = [[NSMutableString alloc] init];
    if (dateList.count >= 7)
    {
        [date appendString:@"每天"];
    }
    else
    {
        for (NSString *dateKey in dateList)
        {
            if ([dateKey isEqualToString:@"none"])
            {
                NSString *allDateInfo = [NSString stringWithFormat:@"%@ %@",setDate,setTime];
                NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
                [fomatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate *allDate = [fomatter dateFromString:allDateInfo];
                [fomatter setDateFormat:@"MM-dd EE HH:mm"];
                [date appendString:[fomatter stringFromDate:allDate]];
            }
            else
            {
                NSString *str = @"";
                if([date isEqualToString:@""])
                {
                    str = [NSString stringWithFormat:@"%@",[utils.dateDic objectForKey:dateKey]];
                }
                else
                {
                    str = [NSString stringWithFormat:@" %@",[utils.dateDic objectForKey:dateKey]];
                }
                [date appendString:str];
            }
           
        }
    }
    return [date copy];
}

+(void)showLoading{
    [[APP_DELEGATE hud] hide:YES];
    [[APP_DELEGATE hud] hide:YES afterDelay:60];
}

+(void)showLoadingWithTile:(NSString *)title{
    MBProgressHUD *hud = [APP_DELEGATE hud];
    hud.labelText = title;
    [hud show:YES];
    [hud hide:YES afterDelay:60];
}

+(void)hideLoading{
    [[APP_DELEGATE hud] hide:NO];
}

//读取modelstatus.plist的数据
+(id)getPlistWithName:(NSString *)name{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    if (!plistPath)
    {
        NSLog(@"Can't find plist");
        return @[];
    }
    
    NSArray *resultArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSDictionary *resultDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (resultArray)
    {
        return resultArray;
    }
    else if (resultDic)
    {
        return resultDic;
    }
    else
    {
        NSLog(@"Why the root is nil ?!");
        return @[];
    }
}

@end
