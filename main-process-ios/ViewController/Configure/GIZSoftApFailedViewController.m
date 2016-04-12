//
//  SURConfigureFaileViewController.m
//  sunrainapp_ios
//
//  Created by Lau on 29/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "GIZSoftApFailedViewController.h"
#import "StepFrameView.h"
//#import "SURConfiguredDeviceViewController.h"
#import "GIZDeviceListViewController.h"

@interface GIZSoftApFailedViewController ()
@property (weak, nonatomic) IBOutlet UIView *stepFrameView;

@end

@implementation GIZSoftApFailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StepFrameView *sf = [[StepFrameView alloc] initTwoStep:secondStep];
    sf.frame = CGRectMake(0, 0, 320, 82);
    [sf.backButton addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sf];
    
    self.navigationController.navigationBarHidden = YES;
    [sf hideBackButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onRetry:(id)sender {
   if (self.navigationController.viewControllers.lastObject == self)
   {
       [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -4)] animated:YES];
   }
}
-(void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
