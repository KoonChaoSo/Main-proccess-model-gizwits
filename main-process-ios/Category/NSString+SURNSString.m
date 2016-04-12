//
//  NSString+GIZNSString.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/8/20.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "NSString+SURNSString.h"

@implementation NSString(SURNSString)

-(NSString *)removeUnderlineInVariable
{
    NSArray *paraArray = [self componentsSeparatedByString:@"_"];
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < paraArray.count; i++)
    {
        NSString *str = paraArray[i];
        if (i == 0)
        {
            [result appendString:str];
        }else
        {
            [result appendString:str.capitalizedString];
        }
    }
    return result;
}

-(NSString *)firstCapitalLetter{
    
    char firstChar = [self characterAtIndex:0];
    
    NSString *firstStr = [NSString stringWithFormat:@"%c",firstChar];
    
    firstStr = firstStr.uppercaseString;
    
    NSMutableString *mutableStr = [[NSMutableString alloc] init];
    
    [mutableStr appendString:firstStr];
    [mutableStr appendString:[self substringFromIndex:1]];
    
    return [mutableStr copy];
}

-(NSString *)handleKeyWord
{
    char firstChar = [self characterAtIndex:0];
    
    NSString *firstStr = [NSString stringWithFormat:@"%c",firstChar];
    
    if ([firstStr isEqualToString:@"_"])
    {
        return [self substringFromIndex:1];
    }
    return self;
}

@end
