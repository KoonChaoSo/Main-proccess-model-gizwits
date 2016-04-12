//
//  SURLaunchViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 23/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURLaunchViewController.h"
#import "SlideNavigationController.h"

@interface SURLaunchViewController ()

@end

@implementation SURLaunchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏navigationBar
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //显示延迟
    [self performSelector:@selector(pushToGuide) withObject:nil afterDelay:3.0f];
}

- (void)pushToGuide{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SURGuide" bundle:nil];
    UIViewController *pushToNextView = [storyBoard instantiateViewControllerWithIdentifier:@"toGuide"];
    [self.navigationController pushViewController:pushToNextView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
