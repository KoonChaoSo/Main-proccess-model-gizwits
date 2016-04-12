//
//  GIZUserInfoModel.m
//  Gizwits-HeatingApparatu
//
//  Created by ChaoSo on 15/7/22.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "SURUserInfoModel.h"

@implementation SURUserInfoModel
@synthesize username = _username;
@synthesize password = _password;
@synthesize token = _token;
@synthesize uid = _uid;

-(instancetype)init:(NSString *)token
            WithUid:(NSString *)uid
       WithUserName:(NSString *)username
       WithPassword:(NSString *)password{
    
    self = [super init];
    if(self){
        _username = username;
        _password = password;
        _token = token;
        _uid = uid;
    }
    
    return self;
}

@end
