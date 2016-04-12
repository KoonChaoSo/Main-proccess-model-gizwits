//
//  StepFrameView.h
//  sunrainapp_ios
//
//  Created by Cmb on 28/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepFrameView : UIView

typedef enum{
    firstStep,
    secondStep,
    thirdStep,
    fourthStep
}stepModel;

@property(strong, nonatomic) UIButton *backButton;
@property(strong, nonatomic) UIView *header;
- (instancetype)initFourStep:(stepModel) step;
- (instancetype)initTwoStep:(stepModel) step;

-(void) backButtonAction:(id)target withSelector:(SEL)selector;
-(void)hideBackButton;

@end
