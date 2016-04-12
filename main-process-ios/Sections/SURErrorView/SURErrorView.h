//
//  SURErrorView.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/8.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesCircleView.h"

@class SURErrorView;
@protocol SURErrorViewDelegate <NSObject>
@optional
-(void)clickErrorList:(SURErrorView *)view name:(NSString *)name;
@end
@interface SURErrorView : UIView

@property (strong, nonatomic) UIImageView *errorImageView;
@property (strong, nonatomic) ImagesCircleView *errorView;

@property (strong, nonatomic) UIButton *preButton;
@property (strong, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) NSArray *errorArray;
@property (strong, nonatomic) NSArray *alertArray;

@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) NSString *errorImageName;
@property (assign , nonatomic) id <SURErrorViewDelegate> delegate;
@property (strong , nonatomic) UIColor *colorForError;

-(void)showList;

- (instancetype)initWithNibName:(NSString *)nibName owner:(id)owner;
@end
