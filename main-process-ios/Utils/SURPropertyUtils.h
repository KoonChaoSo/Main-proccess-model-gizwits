//
//  XPGPropertyUtils.h
//  Gizwits-HeatingApparatu
//
//  Created by ChaoSo on 15/7/22.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SURPropertyUtils : NSObject
+ (SURPropertyUtils *)sharedUtils;



//- (SURAppInfoModel *)getSurInfoFromPlist;

-(NSArray *)allPropertyNames:(id)class_object;
- (SEL)creatSetterWithPropertyName: (NSString *)propertyName;
- (NSString *)encodeToPercentEscapeString: (NSString *) input;
- (NSString *)getAuthenticationStringWith:(NSString *)username password:(NSString *)password;
@end
