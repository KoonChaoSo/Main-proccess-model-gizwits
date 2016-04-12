//
//  SURGuideViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/30.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURGuideViewController.h"
#import "StartAppView.h"

@interface SURGuideViewController ()<UIScrollViewDelegate,StartAppDelegate>
{
    BOOL isOut;
}
@property (strong, nonatomic) StartAppView *startAppView;
@end

@implementation SURGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeLaunchView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeLaunchView{
    _startAppView = [[StartAppView alloc] initWithFrame:self.view.frame Delegate:self];
    [self.view addSubview:_startAppView];
}

- (void)introDidFinish{
    SUR_PROCEES_MODEL.isNew = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
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
