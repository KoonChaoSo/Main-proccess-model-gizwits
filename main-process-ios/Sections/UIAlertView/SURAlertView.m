//
//  SunRAlertView.m
//  sunrainapp_ios
//
//  Created by Lau on 22/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURAlertView.h"
#import "UIView+SURUIViewExtension.h"


#define VIEW_WIDTH     self.frame.size.width
#define VIEW_HEIGHT    self.frame.size.height
#define VIEW_X 20
#define VIEW_Y 40

static float MARGIN_Y = 130;
static float MARGIN_X = 20;
static float MAIN_BOARD_HEIGHT = 133;
static float OPTIONAL_VIEW_HEIGHT = 35;

@implementation SURAlertView
@synthesize delegate = _delegate;

-(instancetype)initWithAll:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self insertMainBoardView:CGRectMake(MARGIN_X, MARGIN_Y, self.frame.size.width - 2 * MARGIN_X, MAIN_BOARD_HEIGHT)];
        [self insertUperView:CGRectMake(MARGIN_X, MARGIN_Y + MAIN_BOARD_HEIGHT + 10, self.frame.size.width - 2 * MARGIN_X, OPTIONAL_VIEW_HEIGHT)];
        [self insertBackgroundView];
        [self insertBottomView:CGRectMake(MARGIN_X, MARGIN_Y + MAIN_BOARD_HEIGHT + 5 + 10 + OPTIONAL_VIEW_HEIGHT, self.frame.size.width - 2 * MARGIN_X, OPTIONAL_VIEW_HEIGHT)];
        _alertsAndFaultsView.hidden = YES;
        _labelDescription.hidden = NO;
    }
    return self;
}

-(instancetype)initWithAlerts:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self insertMainBoardView:CGRectMake(MARGIN_X, MARGIN_Y, self.frame.size.width - 2 * MARGIN_X, MAIN_BOARD_HEIGHT)];
        [self insertUperView:CGRectMake(MARGIN_X, MARGIN_Y + MAIN_BOARD_HEIGHT + 10, self.frame.size.width - 2 * MARGIN_X, OPTIONAL_VIEW_HEIGHT)];
        [self insertBackgroundView];
        [self insertBottomView:CGRectMake(MARGIN_X, MARGIN_Y + MAIN_BOARD_HEIGHT + 5 + 10 + OPTIONAL_VIEW_HEIGHT, self.frame.size.width - 2 * MARGIN_X, OPTIONAL_VIEW_HEIGHT)];
        _alertsAndFaultsView.hidden = YES;
        _labelDescription.hidden = NO;
    }
    return self;
}

-(instancetype)initWithUperView:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self insertMainBoardView:CGRectMake(MARGIN_X, MARGIN_Y, self.frame.size.width - 2 * MARGIN_X, MAIN_BOARD_HEIGHT)];
        [self insertUperView:CGRectMake(MARGIN_X, MARGIN_Y + MAIN_BOARD_HEIGHT + 10, self.frame.size.width - 2 * MARGIN_X, OPTIONAL_VIEW_HEIGHT)];
        [self insertBackgroundView];
        _alertsAndFaultsView.hidden = YES;
        _labelDescription.hidden = NO;
    }
    return self;
}

-(void)insertBackgroundView{
    UIView *backgroudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [backgroudView setBackgroundColor:[UIColor blackColor]];
    [backgroudView setAlpha:0.8];
    [self insertSubview:backgroudView belowSubview:self.mainBoardView];
}
-(void)insertBottomView:(CGRect)frame{
    self.bottomButton = [[UIButton alloc]initWithFrame:frame];
    [self.bottomButton setRoundCornerWithRadius:3.0f];
    [self.bottomButton setBackgroundColor:[UIColor grayColor]];
    [self.bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bottomButton.tag = 2;
    [self addSubview:self.bottomButton];
}
-(void)insertUperView:(CGRect)frame{
    self.uperButton = [[UIButton alloc]initWithFrame:frame];
    [self.uperButton setRoundCornerWithRadius:3.0f];
    [self.uperButton setBackgroundColor:[UIColor colorWithRed:247/255.f green:189/255.f blue:96/255.f alpha:1.0f]];
    [self.uperButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.uperButton.tag = 1;
    [self addSubview:self.uperButton];
}

-(void)insertMainBoardView:(CGRect)frame{
    self.mainBoardView = [[UIView alloc] initWithFrame:frame];
    [self.mainBoardView setBackgroundColor:[UIColor whiteColor]];
    [self.mainBoardView setRoundCornerWithRadius:3.0f];
    
    self.hideButton = [[UIButton alloc] initWithFrame:CGRectMake(self.mainBoardView.frame.size.width -24, 0, 24, 24)];
    [self.hideButton setBackgroundImage:[UIImage imageNamed:@"cancel_icon"] forState:UIControlStateNormal];
    [self.hideButton addTarget:self action:@selector(hideAlertView:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mainBoardView.frame.size.width,50)];
    [self.labelTitle setTextAlignment:NSTextAlignmentCenter];
    
    self.labelDescription = [[SURVerticallyAlignedLabel alloc] initWithFrame:CGRectMake(15, 50, self.mainBoardView.frame.size.width - 30, 83)];
    self.labelDescription.font = [UIFont systemFontOfSize:15];
    [self.labelDescription setVerticalAlignment:VerticalAlignmentMiddle];
    [self.labelDescription setTextAlignment:NSTextAlignmentCenter];
    [self.labelDescription setNumberOfLines:0];
    
    self.alertsAndFaultsView = [self designAlertsAndFaultsView:frame];
    
    UIImageView *backgroudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
    [backgroudImageView setImage:[UIImage imageNamed:@"alertbackgroud"]];
    [backgroudImageView setRoundCornerWithRadius:3.0f];
    
    [self addSubview:self.mainBoardView];
    [self.mainBoardView addSubview:backgroudImageView];
    [self.mainBoardView addSubview:self.labelTitle];
    [self.mainBoardView addSubview:self.labelDescription];
    [self.mainBoardView addSubview:self.alertsAndFaultsView];
    [self.mainBoardView addSubview:self.hideButton];
}

-(UIView*)designAlertsAndFaultsView:(CGRect)frame{
    SURVerticallyAlignedLabel *labelUperDescription;
    SURVerticallyAlignedLabel *labelBottomDescription;
    
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    labelUperDescription = [[SURVerticallyAlignedLabel alloc] initWithFrame:CGRectMake(15, 68, self.mainBoardView.frame.size.width - 30, 33)];
    labelUperDescription.font = [UIFont systemFontOfSize:15];
    [labelUperDescription setVerticalAlignment:VerticalAlignmentMiddle];
    [labelUperDescription setTextAlignment:NSTextAlignmentCenter];
    [labelUperDescription setNumberOfLines:0];
    //    if(type == YES){
    //        labelUperDescription.text = @"设备发生了报警";
    //    }else{
    //        labelUperDescription.text = @"设备发生了故障";
    //    }
    labelUperDescription.text = @"设备发生了故障";
    [bigView addSubview:labelUperDescription];
    
    labelBottomDescription = [[SURVerticallyAlignedLabel alloc]initWithFrame:CGRectMake(15, 85, 120, 24)];
    [labelBottomDescription setVerticalAlignment:VerticalAlignmentMiddle];
    [labelBottomDescription setTextAlignment:NSTextAlignmentCenter];
    [labelBottomDescription setNumberOfLines:0];
    //[bottomView setBackgroundColor:[UIColor blackColor]];
    
    UILabel *left = [[UILabel alloc]initWithFrame:CGRectMake((self.mainBoardView.frame.size.width - 30-8)/2-80, 0, 80, 24)];
    left.font = [UIFont systemFontOfSize:15];
    [left setTextAlignment:NSTextAlignmentCenter];
    left.text = @"点击左上方";
    
    UIImageView *middle = [[UIImageView alloc]initWithFrame:CGRectMake((self.mainBoardView.frame.size.width - 30-8)/2, 4, 16, 16)];
    [middle setImage:[UIImage imageNamed:@"error_icon"]];
    
    UILabel *right = [[UILabel alloc]initWithFrame:CGRectMake((self.mainBoardView.frame.size.width - 30-8)/2+11, 0, 90, 24)];
    right.font = [UIFont systemFontOfSize:15];
    [right setTextAlignment:NSTextAlignmentCenter];
    right.text = @"可查看详情";
    
    [labelBottomDescription addSubview:left];
    [labelBottomDescription addSubview:middle];
    [labelBottomDescription addSubview:right];
    
    
    [bigView addSubview:labelBottomDescription];
    
    return bigView;
}

-(void)setBottomLabelText:(NSString *)title{
    
    if(!self){
        NSLog(@"self is nil");
    }
    if(self.bottomButton){
        [self.bottomButton setTitle:title forState:UIControlStateNormal];
    }
}
-(void)addGestureToBottomWithSEL:(SEL)sel WithTarget:(id)target{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    singleTap.numberOfTapsRequired = 1;
    [self.bottomButton addGestureRecognizer:singleTap];
}
-(void)addGestureToUperWithSEL:(SEL)sel WithTarget:(id)target{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    singleTap.numberOfTapsRequired = 1;
    [self.uperButton addGestureRecognizer:singleTap];
}
-(void)addGestureToHideWithSEL:(SEL)sel WithTarget:(id)target{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    singleTap.numberOfTapsRequired = 1;
    [self.hideButton addGestureRecognizer:singleTap];
}
-(void)setUperLabelText:(NSString *)title {
    if(!self){
        NSLog(@"self is nil");
    }
    if(self.uperButton){
        [self.uperButton setTitle:title forState:UIControlStateNormal];
    }
}
-(void)setTitle:(NSString *)title{
    
    if(!self){
        NSLog(@"self is nil");
    }
    if(self.labelTitle){
        self.labelTitle.text = title;
    }
    
}
-(void)setDescription:(NSString *)desc{
    if(!self){
        NSLog(@"self is nil");
    }
    if(self.labelDescription)
    {
        self.labelDescription.text = desc;
    }
}

-(void)hideAlertView:(id)sender{
    if([self.delegate respondsToSelector:@selector(alertViewForGIZ: didDismissWithButtonIndex:)]){
        __weak __typeof(self)weakSelf = self;
        [self.delegate alertViewForSUR:weakSelf didDismissWithButtonIndex:(NSInteger)((UIButton *)sender).tag];
    }
    [self removeFromSuperview];
}

+(instancetype)UIAlertViewWithTitle:(NSString *)title message:(NSString *)message uperButtonTitle:(NSString *)uperButtonTitle bottomButtonTitles:(NSString *)bottomButtonTitle{
    
    UIScreen *screen = [UIScreen mainScreen];
    SURAlertView *view;
    if(bottomButtonTitle == nil){
        view = [[SURAlertView alloc] initWithUperView:screen.bounds];
    }
    else
    {
        view = [[SURAlertView alloc] initWithAll:screen.bounds];
        [view setBottomLabelText:bottomButtonTitle];
    }
    [view setTitle:title];
    [view setDescription:message];
    [view setUperLabelText:uperButtonTitle];
    return view;
}

+(instancetype)UIAlertViewOnlyWithTitle:(NSString *)title uperButtonTitle:(NSString *)uperButtonTitle bottomButtonTitles:(NSString *)bottomButtonTitle{
    
    UIScreen *screen = [UIScreen mainScreen];
    SURAlertView *view;
    if(bottomButtonTitle == nil){
        view = [[SURAlertView alloc] initWithUperView:screen.bounds];
    }
    else
    {
        view = [[SURAlertView alloc] initWithAll:screen.bounds];
        [view setBottomLabelText:bottomButtonTitle];
    }
    [view displayAlters];
    [view setTitle:title];
    [view setUperLabelText:uperButtonTitle];
    return view;
}

+(instancetype)UIAlertViewWithTitle:(NSString *)title uperButtonTitle:(NSString *)uperButtonTitle bottomButtonTitles:(NSString *)bottomButtonTitle{
    
    UIScreen *screen = [UIScreen mainScreen];
    SURAlertView *view;
    if(bottomButtonTitle == nil){
        view = [[SURAlertView alloc] initWithUperView:screen.bounds];
    }
    else
    {
        view = [[SURAlertView alloc] initWithAll:screen.bounds];
        [view setBottomLabelText:bottomButtonTitle];
    }
    [view setTitle:title];
    [view setUperLabelText:uperButtonTitle];
    return view;
}

-(void)displayAlters{
    self.alertsAndFaultsView.hidden = NO;
    self.labelDescription.hidden = YES;
}

-(void)setButtonToHideView:(SURAlertViewButtonToHide)style{
    if(self.uperButton){
        switch (style) {
            case AlertViewUperButtonToHide:
            {
                if([self.uperButton respondsToSelector:@selector(addTarget:action:forControlEvents:)]){
                    [self.uperButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
            }
            case AlertViewBottomButtonToHide:
            {
                if([self.bottomButton respondsToSelector:@selector(addTarget:action:forControlEvents:)]){
                    [self.bottomButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
            }
            case AlertViewAllButtonToHide:
            {
                if([self.bottomButton respondsToSelector:@selector(addTarget:action:forControlEvents:)]){
                    [self.bottomButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
                }
                if([self.uperButton respondsToSelector:@selector(addTarget:action:forControlEvents:)]){
                    [self.uperButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
                break;
            default:
                break;
        }
    }
}
@end

