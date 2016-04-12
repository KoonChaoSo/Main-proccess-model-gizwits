//
//  SURWebViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/24.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURWebViewController.h"

@interface SURWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SURWebViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    NSURL *url =[NSURL URLWithString:_url];
//    NSLog(urlString);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    self.navigationItem.title = self.navigationBarName;
}





@end
