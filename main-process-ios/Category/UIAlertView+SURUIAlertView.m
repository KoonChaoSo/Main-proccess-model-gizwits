//
//  UIAlertView+GIZUIAlertView.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/8/4.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "UIAlertView+SURUIAlertView.h"

@implementation UIAlertView (SURUIAlertView)

-(void)showAfterTimeInterval:(NSTimeInterval)interval
{
    [self show];
    [self performSelector:@selector(performDissmissForAlertView) withObject:nil afterDelay:interval];
}

-(void)performDissmissForAlertView
{
    [self dismissWithClickedButtonIndex:0 animated:NO];
}


@end
