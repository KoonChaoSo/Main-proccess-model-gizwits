//
//  AppDelegate.m
//  sunrainapp_ios
//
//  Created by Cmb on 22/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "AppDelegate.h"
#import "GIZProcessModel.h"
#import "GIZAppInfo.h"
#import "AFNetworking.h"
#import "GIZUtils.h"
#import "LeftMenuViewController.h"

#import "TestAF.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
        NSSetUncaughtExceptionHandler(&MyExceptionHandler);
    [self applicationWillEnterForeground:application];
    [TestAF testRequest];
    NSDictionary *modelDic = (NSDictionary *)[GIZCommonUtils getPlistWithName:@"ProductkeyMappingTable"];
    NSAssert(modelDic != nil, @"The ProductkeyMappingTable is Empty");
    [self saveDicInUserDefault:modelDic];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SURUser"
                                                             bundle: nil];
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];

    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    

    
    self.window.rootViewController = [SlideNavigationController sharedInstance];
    
    if (nil == self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
    }
    [[UINavigationBar appearance] setBarTintColor:RGB(18, 112, 175)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.window makeKeyAndVisible];
    



    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
//        [XPGWifiSDK setSwitchService:5];
        [XPGWifiSDK startWithAppID:GIZAppId];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (MBProgressHUD *)hud
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.window];
    if(nil == hud)
    {
        hud = [[MBProgressHUD alloc] initWithWindow:self.window];
        [self.window addSubview:hud];
    }
    return hud;
}

void MyExceptionHandler(NSException *exception)
{
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSLog(@"name = %@",name);
    NSLog(@"reason = %@",reason);
    NSLog(@"callStackSymbols = %@",arr);
}


//保存
-(void)saveDicInUserDefault:(NSDictionary *)dicToSave
{
    [[NSUserDefaults standardUserDefaults] setObject:dicToSave forKey:MODEL_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
