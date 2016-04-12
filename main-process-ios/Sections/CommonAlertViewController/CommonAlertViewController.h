//
//  CommonAlertViewController.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/8.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>



@class CommonAlertViewController;
@protocol CommonAlertViewDelegate <NSObject>
@optional
-(void)commonAlertView:(CommonAlertViewController *)commonAlertView;
@end

@interface CommonAlertViewController : UIViewController
typedef void(^CommonAlertViewBlock) (CommonAlertViewController *commonAlertViewController, NSUInteger index);
@property (assign, nonatomic) id<CommonAlertViewDelegate>delegate;


#pragma alertView 控件
@property (weak, nonatomic) IBOutlet UIButton *buttonComfirm;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;


-(void)showWithContent:(NSString *)content
                 title:(NSString *)title
              delegate:(id)delegate;
-(void)hideAlertView;

@end


