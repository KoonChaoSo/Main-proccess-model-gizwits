//
//  GIZTimeReservationServiceImp.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/8/6.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "BaseRemoteService.h"
#import "GIZUtils.h"
#import "GIZAppInfo.h"
#import "GIZUtils.h"

#define CONTENTYPE_JSON         @"application/json"
#define CONTENTYPE_TEXT         @"application/text"

#define DATA_KEY_OPERATION      @"operation"
#define DATA_KEY_RESPONSEOBJECT @"responseObject"
#define DATA_KEY_ERROR          @"error"

#define DATA_KEY_ERRORMSG       @"errorMessage"
#define DATA_KEY_ERRORCODE      @"erroCode"

#define TIME_OUT_INTERVAL       10
static  NSString *const GIZWITS_SCHEDULER_URL = @"http://api.gizwits.com/app/scheduler";
static BaseRemoteService *sharedService = nil;
@interface BaseRemoteService()
{
    GIZTimeAppoint appointType;
}

@end


@implementation BaseRemoteService


+ (BaseRemoteService *)sharedService
{
    if(nil == sharedService)
    {
        sharedService = [[BaseRemoteService alloc] init];
    }
    return sharedService;
}

-(AFHTTPSessionManager *)prepareRequest:(NSString *)token contentType:(NSString *)contentType param:(NSDictionary *)param
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时
    manager.requestSerializer.timeoutInterval = TIME_OUT_INTERVAL;
    
    [manager.requestSerializer setValue:GIZAppId forHTTPHeaderField:@"X-Gizwits-Application-Id"];
     [manager.requestSerializer setValue:self.enterprisesToken forHTTPHeaderField:@"Api-Token"];

    if(nil != token)
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-Gizwits-User-token"];
    
    
    if(contentType.length > 0)
        [manager.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
    if([contentType isEqualToString:CONTENTYPE_JSON])
    {
        [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
            
            NSData *encodeData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
            if(nil == encodeData)
                return @"";
            NSString *content = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
            NSLog(@"Content:%@", content);
            return content;
        }];
    }
    
    NSLog(@"%@", manager.requestSerializer.HTTPRequestHeaders);
    return manager;
}



- (AFHTTPSessionManager *)prepareRequest:(NSString *)token contentType:(NSString *)contentType
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时
    manager.requestSerializer.timeoutInterval = TIME_OUT_INTERVAL;

    [manager.requestSerializer setValue:GIZAppId forHTTPHeaderField:@"X-Gizwits-Application-Id"];
   
     [manager.requestSerializer setValue:[self getAuthenticationStringWith:@"solareast" password:@"gdms"] forHTTPHeaderField:@"Api-Token"];
    if(nil != token)
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-Gizwits-User-token"];

    
    if(contentType.length > 0)
        [manager.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
    if([contentType isEqualToString:CONTENTYPE_JSON])
    {
        [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
            
            NSData *encodeData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
            if(nil == encodeData)
                return @"";
            NSString *content = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
            NSLog(@"Content:%@", content);
            return content;
        }];
    }
    
    NSLog(@"%@", manager.requestSerializer.HTTPRequestHeaders);
    return manager;
}

#pragma mark -
#pragma mark HTTP协议封装
- (NSURLSessionTask *)getUrl:(NSString *)url
                            params:(NSDictionary *)dict
                       withSesskon:(NSString *)session
                       contentType:(NSString *)contentType
                           success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                              fail:(void (^)(NSURLSessionTask *operation, NSError *error)) fail
{
    AFHTTPSessionManager *manager = [self prepareRequest:session contentType:contentType];
    return [manager GET:url parameters:dict progress:nil success:^(NSURLSessionTask *operation, id responseObject) {
        NSInteger statusCode = [(NSHTTPURLResponse *)operation.response statusCode];
        NSString *str;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        if (statusCode == 401)
        {
            str = [NSString stringWithFormat:@"未授权访问。(%ld)", (long)statusCode];
        }
        else if (statusCode == 404)
        {
            str = [NSString stringWithFormat:@"资源不存在。(%ld)", (long)statusCode];
        }
        else if (statusCode == 400)
        {
            str = [NSString stringWithFormat:@"数据请求错误。(%ld)", (long)statusCode];
        }
        else if (statusCode == 500)
        {
            str = [NSString stringWithFormat:@"服务器错误。(%ld)", (long)statusCode];
        }
        
        if (statusCode == 200)
        {
            success(operation, responseDic);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:str code:statusCode userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (fail){
                    fail(operation, error);
                }
            });
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fail){
                fail(operation, error);
            }
        });
    }];
}

- (NSURLSessionTask *)postUrl:(NSString *)url
                            params:(NSDictionary *)dict
                       withSession:(NSString *)session
                       contentType:(NSString *)contentType
                           success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                              fail:(void (^)(NSURLSessionTask *operation, NSError *error)) fail
{
    AFHTTPSessionManager *manager = [self prepareRequest:session contentType:contentType];
    
    return [manager POST:url parameters:dict progress:nil success:^(NSURLSessionTask *operation, id responseObject)
    {
        NSInteger statusCode = [(NSHTTPURLResponse *)operation.response statusCode];
        NSString *str;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        if (statusCode == 401)
        {
            str = [NSString stringWithFormat:@"未授权访问。(%ld)", (long)statusCode];
        }
        else if (statusCode == 404)
        {
            str = [NSString stringWithFormat:@"资源不存在。(%ld)", (long)statusCode];
        }
        else if (statusCode == 400)
        {
            str = [NSString stringWithFormat:@"数据请求错误。(%ld)", (long)statusCode];
        }
        else if (statusCode == 500)
        {
            str = [NSString stringWithFormat:@"服务器错误。(%ld)", (long)statusCode];
        }
        
        if (statusCode == 200)
        {
            success(operation, responseDic);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:str code:statusCode userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (fail){
                    fail(operation, error);
                }
            });
        }
    } failure:^(NSURLSessionTask *operation, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fail){
                fail(operation, error);
            }
        });
    }];
}
- (NSURLSessionTask *)putUrl:(NSString *)url
                             params:(NSDictionary *)dict
                        withSession:(NSString *)session
                        contentType:(NSString *)contentType
                            success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                               fail:(void (^)(NSURLSessionTask *operation, NSError *error)) fail
{
    AFHTTPSessionManager *manager = [self prepareRequest:session contentType:contentType];
    return [manager PUT:url parameters:dict success:^(NSURLSessionTask *operation, id responseObject) {
        NSInteger statusCode = [(NSHTTPURLResponse *)operation.response statusCode];
        NSString *str;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        if (statusCode == 401)
        {
            str = [NSString stringWithFormat:@"未授权访问。(%ld)", (long)statusCode];
        }
        else if (statusCode == 404)
        {
            str = [NSString stringWithFormat:@"资源不存在。(%ld)", (long)statusCode];
        }
        else if (statusCode == 400)
        {
            str = [NSString stringWithFormat:@"数据请求错误。(%ld)", (long)statusCode];
        }
        else if (statusCode == 500)
        {
            str = [NSString stringWithFormat:@"服务器错误。(%ld)", (long)statusCode];
        }
        
        if (statusCode == 200)
        {
            success(operation, responseDic);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:str code:statusCode userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (fail){
                    fail(operation, error);
                }
            });
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fail){
                fail(operation, error);
            }
        });
    }];
}

- (NSURLSessionTask *)deleteUrl:(NSString *)url
                             params:(NSDictionary *)dict
                        withSession:(NSString *)session
                        contentType:(NSString *)contentType
                            success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                               fail:(void (^)(NSURLSessionTask *operation, NSError *error)) fail
{
    AFHTTPSessionManager *manager = [self prepareRequest:session contentType:contentType];
    return [manager DELETE:url parameters:dict success:^(NSURLSessionTask *operation, id responseObject) {
        NSInteger statusCode = [(NSHTTPURLResponse *)operation.response statusCode];
        NSString *str;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        if (statusCode == 401)
        {
            str = [NSString stringWithFormat:@"未授权访问。(%ld)", (long)statusCode];
        }
        else if (statusCode == 404)
        {
            str = [NSString stringWithFormat:@"资源不存在。(%ld)", (long)statusCode];
        }
        else if (statusCode == 400)
        {
            str = [NSString stringWithFormat:@"数据请求错误。(%ld)", (long)statusCode];
        }
        else if (statusCode == 500)
        {
            str = [NSString stringWithFormat:@"服务器错误。(%ld)", (long)statusCode];
        }
        
        if (statusCode == 200)
        {
            success(operation, responseDic);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:str code:statusCode userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (fail){
                    fail(operation, error);
                }
            });
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fail){
                fail(operation, error);
            }
        });
    }];
}

#pragma mark - Main Thread
- (void)receiveData:(NSDictionary *)data
{
    if([self.delegate respondsToSelector:@selector(gizTimeAppointment:)])
    {
        [self.delegate gizTimeAppointment:data];
    }
}

- (void)receiveError:(NSDictionary *)data
{
    NSLog(@"Networking Error!!");
    if([self.delegate respondsToSelector:@selector(gizTimeAppointment:)])
        [self.delegate gizTimeAppointment:data];
}


//将本地日期字符串转为UTC日期字符串
//本地日期格式:2013-08-03 12:53:51
//可自行指定输入输出格式
-(NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
-(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
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
