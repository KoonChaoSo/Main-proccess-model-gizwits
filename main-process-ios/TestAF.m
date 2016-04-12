//
//  TestAF.m
//  main-process-ios
//
//  Created by ChaoSo on 16/3/9.
//  Copyright © 2016年 gitzwits. All rights reserved.
//

#import "TestAF.h"
#import "BaseRemoteService.h"

@implementation TestAF

+(void)testRequest
{
    NSString *url = @"http://enterprise.gizwits.com:80/app_api/v1/enterprises/";
    NSDictionary *params = @{@"app_id":@"5608f1d5540bcc263a94155bf66cb119708902481dd87157d53999a478e48d7f",@"secret_key":@"6bddc7d45342e6ade5f04493085edff02414291dff4b7db2c19e5a2a6efc8ebd"};
    
    NSString *url2 = @"http://enterprise.gizwits.com/app_api/v1/tickets";
    NSDictionary *params2 = @{@"uid":@"5129ac1035c74aeca1443028c7a22eed",@"did":@"cFrmzTUnGqmenLjLThewrj",@"ticket_rule_id":@"1",@"content":@"测试吗"};
    
    
    [[BaseRemoteService sharedService] getUrl:url params:params withSesskon:nil contentType:@"application/json" success:^(NSURLSessionTask *operation, id responseObject) {
        
        [BaseRemoteService sharedService].enterprisesToken = [(NSDictionary *)responseObject objectForKey:@"token"];
        [[BaseRemoteService sharedService] postUrl:url2 params:params2 withSession:nil contentType:@"multipart/form-data" success:^(NSURLSessionTask *operation, id responseObject) {
            NSLog(@"success");
            
        } fail:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"fail to post");
        }];
        
        
        
    } fail:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"fail!!");
    }];
    
    
}

@end
