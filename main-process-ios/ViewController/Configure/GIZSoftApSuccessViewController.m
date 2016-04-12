//
//  SURSoftApSuccessViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/26.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "GIZSoftApSuccessViewController.h"
//#import "SURQRViewController.h"
#import "StepFrameView.h"
#import "GIZUtils.h"
//#import "SURConfiguredDeviceViewController.h"
#import "GIZDeviceListViewController.h"

@interface GIZSoftApSuccessViewController ()

@end

@implementation GIZSoftApSuccessViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    StepFrameView *sf = [[StepFrameView alloc] initTwoStep:secondStep];
    sf.frame = CGRectMake(0, 0, 320, 82);
    [sf.backButton addTarget:self action:@selector(backToSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sf];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToSelected
{
    [GIZCommonUtils hideLoading];
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[GIZDeviceListViewController class]])
        {
            if (sysVer >= 8)
            {
                [self.navigationController popToViewController:viewController animated:YES];
            }
            else
            {
                [self.navigationController popToViewController:viewController animated:NO];
            }
            return;
        }
    }
}

@end
