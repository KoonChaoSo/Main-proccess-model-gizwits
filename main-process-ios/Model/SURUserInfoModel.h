//
//  GIZUserInfoModel.h
//  Gizwits-HeatingApparatu
//
//  Created by ChaoSo on 15/7/22.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SURUserInfoModel : NSObject
//登录后的token
@property (strong,nonatomic  ) NSString *token;

//登录后的uid
@property (strong,nonatomic  ) NSString *uid;

//登录的密码
@property (strong,nonatomic  ) NSString *password;

//登录的用户名
@property (strong,nonatomic  ) NSString *username;

-(instancetype)init:(NSString *)token
            WithUid:(NSString *)uid
       WithUserName:(NSString *)username
       WithPassword:(NSString *)password;
@end
