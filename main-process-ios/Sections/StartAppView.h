//
//  StartAppView.h
//  CCBShop
//
//  Created by zyy_pro on 14-8-20.
//  Copyright (c) 2014年 CCB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartAppDelegate<NSObject>
@optional
- (void)introDidFinish;
@end

@interface StartAppView : UIView<UIScrollViewDelegate>{
    id<StartAppDelegate> delegate;
}

@property (strong, nonatomic) UIScrollView * introScrollView;
@property (strong, nonatomic) UIPageControl * introPageControl;
@property (strong, nonatomic) NSArray * introImageNamesArray;

- (id)initWithFrame:(CGRect)frame Delegate:(id<StartAppDelegate>)theDelegate;

@end
