//
//  SURConfigureFaileViewController.m
//  sunrainapp_ios
//
//  Created by Lau on 29/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURConfigureFaileViewController.h"
#import "StepFrameView.h"

@interface SURConfigureFaileViewController ()
@property (weak, nonatomic) IBOutlet UIView *stepFrameView;

@end

@implementation SURConfigureFaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StepFrameView *sf = [[StepFrameView alloc] initFourStep:fourthStep];
    sf.frame = CGRectMake(0, 0, 320, 82);
    [sf.backButton addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sf];
    self.navigationController.navigationBarHidden = YES;
    [sf hideBackButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRetry:(id)sender {
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -4)] animated:YES];
}


-(void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
