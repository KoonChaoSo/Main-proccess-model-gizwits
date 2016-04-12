//
//  XPGPropertyUtils.m
//  Gizwits-HeatingApparatu
//
//  Created by ChaoSo on 15/7/22.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "SURPropertyUtils.h"
#import "NSString+SURNSString.h"

static SURPropertyUtils *sharedUtils = nil;
@implementation SURPropertyUtils


+ (SURPropertyUtils *)sharedUtils
{
    if(nil == sharedUtils)
    {
        sharedUtils = [[SURPropertyUtils alloc] init];
    }
    return sharedUtils;
}



///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
-(NSArray *)allPropertyNames:(id)class_object
{
    //    存储所有属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    //    存储属性的个数
    unsigned int propertyCount = 0;
    //    通过运行时获取当前类的属性
    objc_property_t *properties = class_copyPropertyList([class_object class], &propertyCount);
    for(int i = 0;i < propertyCount;i++){
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    return allNames;
}


- (SEL)creatSetterWithPropertyName: (NSString *) propertyName{
    
    //2.拼接上set关键字
    propertyName = [NSString stringWithFormat:@"set%@:", [propertyName firstCapitalLetter]];
    
    //3.返回set方法
    return NSSelectorFromString(propertyName);
}

// ARC encoding
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             
                                                                             NULL, /* allocator */
                                                                             
                                                                             (__bridge CFStringRef)input,
                                                                             
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             
                                                                             kCFStringEncodingUTF8);
    
    return outputStr;
}

- (NSString *)getAuthenticationStringWith:(NSString *)username password:(NSString *)password
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSString *authenticatingString = [NSString stringWithFormat:@"%@&%@&%@",username,password,dateString];
    
    NSData* originData = [authenticatingString dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return encodeResult;
}


@end
