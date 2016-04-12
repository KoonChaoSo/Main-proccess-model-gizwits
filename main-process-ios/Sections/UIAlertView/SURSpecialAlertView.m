//
//  CommonAlertView.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/9.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURSpecialAlertView.h"

@interface SURSpecialAlertView ()

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *leftBottomView;
@property (strong, nonatomic) UIView *rightBottomView;

@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation SURSpecialAlertView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(void)configureContainerView
{
    if (_containerView == NULL) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 190)];
    }
    
    
    
    
    
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

@end
