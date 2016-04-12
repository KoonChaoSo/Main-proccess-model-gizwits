//
//  StepFrameView.m
//  ;
//
//  Created by Cmb on 28/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "StepFrameView.h"

@implementation StepFrameView
{
    CGFloat width;
    CGFloat height;

}

- (instancetype)initFourStep:(stepModel) step
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 82)];
    if (self) {
        [self designWithFourStep:step];
    }
    return self;
}

- (instancetype)initTwoStep:(stepModel) step
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 82)];
    if (self) {
        [self designWithTwoStep:step];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self designWithTwoStep:secondStep];
    }
    return self;
}

-(void)designWithTwoStep:(stepModel)step{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    width  = size.width;
    height = size.height;
    _header = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, width, 82)];
    _header.backgroundColor = [UIColor colorWithRed:5/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(6, 41-22, 44, 44)];
    [self.backButton setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [_header addSubview:self.backButton];
    
    switch (step) {
        case firstStep:
            [self firstTwoStepView];
            break;
            
        case secondStep:
            [self secondTwoStepView];
            break;
            
        default:
            break;
    }
}

-(void) firstTwoStepView{
    UIImageView *stepBackground = [[UIImageView alloc] initWithFrame:CGRectMake((width+5)/2-40, 41-12, 80, 24)];
    [stepBackground setImage:[UIImage imageNamed:@"step-17"]];
    [_header addSubview:stepBackground];
    
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake((width+5)/2-100-4+30, 41+5, 120, 30)];
    registerLabel.text = @"选择设备热点";
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.font =  [UIFont boldSystemFontOfSize:14.0f];
    [_header addSubview:registerLabel];
}

-(void) secondTwoStepView{
    UIImageView *stepBackground = [[UIImageView alloc] initWithFrame:CGRectMake((width+5)/2-40, 41-12, 80, 24)];
    [stepBackground setImage:[UIImage imageNamed:@"step-18"]];
    [_header addSubview:stepBackground];
    
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake((width+5)/2-100-4+108, 41+5, 100, 30)];
    registerLabel.text = @"输入密码";
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.font =  [UIFont boldSystemFontOfSize:14.0f];
    [_header addSubview:registerLabel];
}

-(void)designWithFourStep:(stepModel)step{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    width  = size.width;
    height = size.height;
    _header = [[UIView  alloc] initWithFrame:CGRectMake(0, -10, width+20, 92)];
    _header.backgroundColor = [UIColor colorWithRed:5/255.0 green:137/255.0 blue:255/255.0 alpha:1];
    
    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(6, 41-10, 44, 44)];
    [_backButton setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    
    [_header addSubview:_backButton];
    
    switch (step) {
        case firstStep:
            [self firstStepView];
            break;
            
        case secondStep:
            [self secondStepView];
            break;
        
        case thirdStep:
            [self thirdStepView];
            break;
            
        case fourthStep:
            [self fourthStepView];
            break;
        
        default:
            break;
    }
    [self addSubview:_header];
}



-(void) firstStepView{
    UIImageView *stepBackground = [[UIImageView alloc] initWithFrame:CGRectMake((width+5)/2-90, 41-12, 200, 24)];
    [stepBackground setImage:[UIImage imageNamed:@"step"]];
    [_header addSubview:stepBackground];
    
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake((width+5)/2-90-4, 41+5, 50, 30)];
    registerLabel.text = @"注册";
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.font =  [UIFont boldSystemFontOfSize:14.0f];
    [_header addSubview:registerLabel];
}

-(void) secondStepView{
    UIImageView *stepBackground = [[UIImageView alloc] initWithFrame:CGRectMake((width+5)/2-90, 41-2, 200, 24)];
    [stepBackground setImage:[UIImage imageNamed:@"step-08"]];
    [_header addSubview:stepBackground];
    
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake((width+5)/2-90-4+46, 41+15, 100, 30)];
    registerLabel.text = @"搜索设备";
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.font =  [UIFont boldSystemFontOfSize:14.0f];
    [_header addSubview:registerLabel];
}

-(void) thirdStepView{
    UIImageView *stepBackground = [[UIImageView alloc] initWithFrame:CGRectMake((width+5)/2-90, 41-2, 200, 24)];
    [stepBackground setImage:[UIImage imageNamed:@"step-13"]];
    [_header addSubview:stepBackground];
    
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake((width+5)/2-90-4+108, 41+15, 100, 30)];
    registerLabel.text = @"输入密码";
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.font =  [UIFont boldSystemFontOfSize:14.0f];
    [_header addSubview:registerLabel];
}

-(void) fourthStepView{
    UIImageView *stepBackground = [[UIImageView alloc] initWithFrame:CGRectMake((width+5)/2-90, 41-2, 200, 24)];
    [stepBackground setImage:[UIImage imageNamed:@"step-15"]];
    [_header addSubview:stepBackground];
    
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake((width+5)/2-90-4+180, 41+15, 50, 30)];
    registerLabel.text = @"配置";
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.font =  [UIFont boldSystemFontOfSize:14.0f];
    [_header addSubview:registerLabel];
}


-(void) backButtonAction:(id)target withSelector:(SEL)selector{
    [self.backButton addTarget:target action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
}

-(void)hideBackButton
{
    _backButton.hidden = YES;
}


@end
