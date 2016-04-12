//
//  GIZBaseViewController.m
//  main-process-ios
//
//  Created by ChaoSo on 16/1/5.
//  Copyright © 2016年 Sunrain. All rights reserved.
//

#import "GIZBasicFlowViewController.h"
#import "GIZUtils.h"
#import "GizSDKCommunicateService.h"
#import "SURMainViewController.h"
#import "SURErrorView.h"
#import "GIZAppInfo.h"


@interface GIZBasicFlowViewController ()

@end

@implementation GIZBasicFlowViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    只需要执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_PROCEES_MODEL.isLogined)
        {
            [GIZCommonUtils showLoadingWithTile:@"自动登录中..."];
            //TODO 跳转到main
            [self pushToMainVC:YES];
        }
        else
        {
            if ([self isMemberOfClass:[GIZBasicFlowViewController class]])
            {
                [self performSegueWithIdentifier:@"toLoginPage" sender:nil];
            }
        }
    });
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToMainVC:(BOOL)isNeedToLogin
{
    @try {
        if(self.navigationController.viewControllers.lastObject == self)
        {
            //TODO 跳转
            SURMainViewController *main = [[SURMainViewController alloc] init];
            main->isNeedToLogin = isNeedToLogin;
            [self.navigationController pushViewController:main animated:NO];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error:%@", exception);
    }
}

- (void)pushToRegisterVC
{
    @try {
        if(self.navigationController.viewControllers.lastObject == self)
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SURUser"
                                                                     bundle: nil];
            UIViewController *registerVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"GIZRegisterViewController"];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error:%@", exception);
    }
}

- (void)pushToForgetVC
{
    @try {
        if(self.navigationController.viewControllers.lastObject == self)
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SURUser"
                                                                     bundle: nil];
            UIViewController *forgetVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"GIZForgetViewController"];
            [self.navigationController pushViewController:forgetVC animated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error:%@", exception);
    }
}

- (void)pushToControl:(XPGWifiDevice *)selectedDevice
{
    
    @try {
        if(self.navigationController.viewControllers.lastObject == self)
        {
            NSString *cunstomViewControllerIdentifier = GIZDeviceCustomIdentifier;
            if (cunstomViewControllerIdentifier && [cunstomViewControllerIdentifier length] == 0)
            {
                cunstomViewControllerIdentifier = @"GIZBasicDeviceViewController";
            }
            else
            {
                Class clazz = NSClassFromString(cunstomViewControllerIdentifier);
                id viewController = [[clazz alloc] init];
                [viewController setValue:selectedDevice forKey:@"device"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error:%@", exception);
    }
}


@end
