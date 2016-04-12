//
//  SURDior.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/11/24.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURDior.h"

#import "SURTestVC.h"

typedef void (^Test)(id data);
@implementation SURDior

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self linkWithTest:^(id data) {
        NSLog(@"dsadsa123321");
    }];
}

- (void)test1
{
    
    Test test = [self.dic objectForKey:@"Test"];
    
    test = ^(id data)
    {
        NSLog(@"dsadsa");
    };
    
    
    
    
}

-(void)linkWithTest:(Test)block
{
    [self.dic setObject:block forKey:@"Test"];
}
@end
