//
//  GIZTimeReservationServiceImp.h
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/8/6.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef enum{
    GIZTimeDeleteAppoint = 0,
    GIZTimeShutDownAppoint,
    GIZTimeDefiniteAppoint,
    GIZTimeGetAppointments,
    GIZTimeAppointError,
}GIZTimeAppoint;

typedef enum {
    
    GIZTempModeComfortable = 0,
    GIZTempModeThrifty,
    GIZTempModeAntifreezing,
    GIZTempModeCustom
}GIZTempModeEnum;

@class BaseRemoteService;

@protocol SURNetworkingDelegate <NSObject>
@optional
- (void)gizTimeAppointment:(NSDictionary *)dic;
- (void)networkingDelegate:(BaseRemoteService *)networkingService data:(NSDictionary *)data;
@end


#define APPLICATION_JSON @"application/json"
#define APPLICATION_TEXT @"application/text"
@interface BaseRemoteService : NSObject
+ (BaseRemoteService *)sharedService;

@property (strong, nonatomic) NSString *enterprisesToken;

@property (nonatomic, assign) id <SURNetworkingDelegate>delegate;


- (NSURLSessionTask *)getUrl:(NSString *)url
                      params:(NSDictionary *)dict
                 withSesskon:(NSString *)session
                 contentType:(NSString *)contentType
                     success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                        fail:(void (^)(NSURLSessionTask *operation, NSError *error)) fail;

- (NSURLSessionTask *)postUrl:(NSString *)url
                               params:(NSDictionary *)dict
                          withSession:(NSString *)session
                          contentType:(NSString *)contentType
                              success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                               fail:(void (^)(NSURLSessionTask *operation, NSError *error)) fail;

- (NSURLSessionTask *)putUrl:(NSString *)url
                               params:(NSDictionary *)dict
                          withSession:(NSString *)session
                          contentType:(NSString *)contentType
                              success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                              fail:(void (^)(NSURLSessionTask *operation, NSError *error)) fail;

- (NSURLSessionTask *)deleteUrl:(NSString *)url
                               params:(NSDictionary *)dict
                          withSession:(NSString *)session
                          contentType:(NSString *)contentType
                              success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                                 fail:(void (^)(NSURLSessionTask *operation, NSError *error)) fail;


@end
