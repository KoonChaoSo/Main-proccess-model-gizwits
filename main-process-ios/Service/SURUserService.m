//
//  GIZUserServiceImp.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/7/29.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "SURUserService.h"
#import "GIZProcessModel.h"

static SURUserService *sharedService = nil;
@interface SURUserService()
{
    NSTimer *counterTimer;
}

@end
@implementation SURUserService

+ (SURUserService *)sharedService
{
    if(nil == sharedService)
    {
        sharedService = [[SURUserService alloc] init];
    }
    return sharedService;
}


-(void)saveToken:(NSString *)token WithUid:(NSString *)uid WithAccoutType:(SURAccountType)type
{
    
    _PROCEES_MODEL.token = token;
    _PROCEES_MODEL.uid = uid;
    _PROCEES_MODEL.accountType = type;
}

-(void)saveAccount:(NSString *)account WithPassword :(NSString *)password{
    
    _PROCEES_MODEL.username = account;
    _PROCEES_MODEL.password = password;
}

-(void)removeTokenAndUidFromProccessModel{
    _PROCEES_MODEL.token = @"";
    _PROCEES_MODEL.uid = @"";
}



@end
