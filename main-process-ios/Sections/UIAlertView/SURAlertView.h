//
//  SunRAlertView.h
//  sunrainapp_ios
//
//  Created by Lau on 22/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SURVerticallyAlignedLabel.h"

typedef enum {
    AlertViewUperButtonToHide = 0,
    AlertViewBottomButtonToHide,
    AlertViewAllButtonToHide
}SURAlertViewButtonToHide;

@interface SURAlertView : UIAlertView

@property (strong, nonatomic) UIView *mainBoardView;
@property (strong, nonatomic) SURVerticallyAlignedLabel *labelDescription;
@property (strong, nonatomic) UIView *alertsAndFaultsView;
@property (strong, nonatomic) UIImageView *deleteImageView;
@property (strong, nonatomic) UILabel *labelTitle;
@property (strong, nonatomic) UIButton *uperButton;
@property (strong, nonatomic) UIButton *bottomButton;
@property (strong, nonatomic) UIButton *hideButton;

@property(nonatomic,assign) id /*<UIAlertViewDelegate>*/ delegate;

+(instancetype)UIAlertViewWithTitle:(NSString *)title message:(NSString *)message uperButtonTitle:(NSString *)uperButtonTitle bottomButtonTitles:(NSString *)bottomButtonTitle;
+(instancetype)UIAlertViewOnlyWithTitle:(NSString *)title uperButtonTitle:(NSString *)uperButtonTitle bottomButtonTitles:(NSString *)bottomButtonTitle;
-(instancetype)initWithAll:(CGRect)frame;
-(instancetype)initWithUperView:(CGRect)frame;
-(void)setTitle:(NSString *)title;
-(void)setDescription:(NSString *)desc;
-(void)setBottomLabelText:(NSString *)title;
-(void)setUperLabelText:(NSString *)title;
-(void)addGestureToBottomWithSEL:(SEL)sel WithTarget:(id)target;
-(void)addGestureToUperWithSEL:(SEL)sel WithTarget:(id)target;
-(void)addGestureToHideWithSEL:(SEL)sel WithTarget:(id)target;
-(void)hideAlertView:(id)sender;
-(void)setButtonToHideView:(SURAlertViewButtonToHide)style;
@end

@protocol SURAlertViewDelegate<NSObject>
@optional
- (void)alertViewForSUR:(SURAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end