//
//  SURConfigureFaileViewController.m
//  sunrainapp_ios
//
//  Created by Lau on 29/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "GIZAirlinkFailedViewController.h"
#import "StepFrameView.h"

@interface GIZAirlinkFailedViewController ()
@property (weak, nonatomic) IBOutlet UIView *stepFrameView;

@end

@implementation GIZAirlinkFailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StepFrameView *sf = [[StepFrameView alloc] initFourStep:fourthStep];
    sf.frame = CGRectMake(0, 0, 320, 82);
    [sf.backButton addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sf];
    [sf hideBackButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRetry:(id)sender {
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -4)] animated:YES];
}

- (IBAction)configurationSoftAp:(id)sender {
     [self performSegueWithIdentifier:@"toSoftAp" sender:self];
}

-(void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
