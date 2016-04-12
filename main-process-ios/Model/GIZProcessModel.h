//
//  GIZProcessViewModel.h
//  Gizwits-HeatingApparatu
//
//  Created by ChaoSo on 15/7/22.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SURUserInfoModel.h"


#define MODEL_NAME @"ModelsStatusName"
typedef enum
{
    AccountTypeGuest,
    AccountTypeDefault,//电话和邮箱都一样
}SURAccountType;

@interface GIZProcessModel : NSObject
{
    
}
@property (nonatomic , assign ) SURAccountType accountType;

//登录后的token
@property (strong,nonatomic  ) NSString *token;

//登录后的uid
@property (strong,nonatomic  ) NSString *uid;

//登录的密码
@property (strong,nonatomic  ) NSString *password;

//登录的用户名
@property (strong,nonatomic  ) NSString *username;

//连接的WiFi名称
@property (strong,nonatomic) NSString *ssid;

//gizwits app secret
@property (strong , nonatomic) NSString *appSecret;

@property (strong, nonatomic) NSString *sendMsgToken;

@property (assign , nonatomic)BOOL isRemember;

@property (assign, nonatomic) BOOL isNew;

@property (assign, nonatomic)BOOL isLogined;

/**
 * @brief 当前已登录的用户名、uid、token
 */
@property (nonatomic, strong, readonly) NSString *currentUser;
@property (nonatomic, strong, readonly) NSString *currentUid;
@property (nonatomic, strong, readonly) NSString *currentToken;

+ (GIZProcessModel *)sharedModel;

- (BOOL)isLogined;


@end
