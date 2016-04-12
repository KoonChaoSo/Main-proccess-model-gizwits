//
//  CommonAlertViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/8.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "CommonAlertViewController.h"

typedef void(^SURCancelButtonActionBlock)(NSInteger index);
@interface CommonAlertViewController ()


#pragma 背景

@end

@implementation CommonAlertViewController
@synthesize  delegate = _delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void)showWithContent:(NSString *)content
                 title:(NSString *)title
              delegate:(id)delegate
{
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    _labelTitle.text = title;
    _labelContent.text = content;
    [_buttonCancel addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
    [_buttonComfirm addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    self.delegate = delegate;
    [SURAPP_DELEGATE.window addSubview:self.view];
}

-(void)hideAlertView
{
    [self.view removeFromSuperview];
}



-(void)onButton:(UIGestureRecognizer *)gesture
{
    if ([_delegate respondsToSelector:@selector(commonAlertView:)])
    {
        [_delegate commonAlertView:self];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
