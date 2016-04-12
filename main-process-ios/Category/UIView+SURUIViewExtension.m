//
//  UIView+GIZUIViewExtension.m
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/7/28.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import "UIView+SURUIViewExtension.h"
//#import "SURAlertView.h"

@implementation UIView (SURUIViewExtension)
-(void)setRoundCorner{
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
}

-(void)setRoundCornerWithRadius:(double)radius{
    [self.layer setCornerRadius:radius];
    self.layer.masksToBounds = YES;
}



@end
