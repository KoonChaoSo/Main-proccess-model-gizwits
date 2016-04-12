//
//  StartAppView.m
//  CCBShop
//
//  Created by zyy_pro on 14-8-20.
//  Copyright (c) 2014年 CCB. All rights reserved.
//

#import "StartAppView.h"

@implementation StartAppView

- (id)initWithFrame:(CGRect)frame Delegate:(id<StartAppDelegate>)theDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        delegate = theDelegate;
        
        self.userInteractionEnabled = YES;
        
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
                self.introImageNamesArray = [NSArray arrayWithObjects:@"welcomePage",@"guide_1", nil];
            else
                self.introImageNamesArray = [NSArray arrayWithObjects:@"welcomePage",@"guide_1", nil];
        }
        
        [self addScrollView];
        [self addScrollImages];
        [self addPageControl];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)addScrollView
{
    self.introScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.introScrollView.showsHorizontalScrollIndicator = NO;
    self.introScrollView.showsVerticalScrollIndicator = NO;
    self.introScrollView.bounces = NO;
    self.introScrollView.contentSize = CGSizeMake(self.introScrollView.frame.size.width * (self.introImageNamesArray.count + .0) + .5, 0);
    self.introScrollView.pagingEnabled = YES;
    self.introScrollView.delegate = self;
    [self addSubview:self.introScrollView];
}

- (void)addGesture:(UIView *)view
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [view addGestureRecognizer:swipe];
}

- (void)closeView:(UISwipeGestureRecognizer *)sender{
    NSLog(@"closeView:%d",sender.direction);
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self onStartButton];
    }
}

- (void)addScrollImages
{
    CGSize size = self.bounds.size;
    
    for (int i = 0; i < self.introImageNamesArray.count; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width, size.height)];
        imageView.image = [UIImage imageNamed:self.introImageNamesArray[i]];
        
        if (i == self.introImageNamesArray.count - 1) {
            UIButton * startButton = [[UIButton alloc] initWithFrame:imageView.frame];
            [startButton setTitle:@"text" forState:UIControlStateNormal];
            [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            startButton.backgroundColor = [UIColor clearColor];
            startButton.userInteractionEnabled = YES;
            //            startButton.center = CGPointMake(size.width * 0.5, size.height * 0.8);
            [startButton addTarget:self action:@selector(onStartButton) forControlEvents:UIControlEventTouchUpInside];
            [self.introScrollView addSubview:startButton];
            
//            [self addGesture:imageView];
//            imageView.userInteractionEnabled = YES;
        }
        [self.introScrollView addSubview:imageView];
    }
}

- (void)addPageControl
{
    self.introPageControl = [[UIPageControl alloc] init];
    self.introPageControl.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.95);
    self.introPageControl.alpha = 0.4;
    self.introPageControl.numberOfPages = self.introImageNamesArray.count;
    self.introPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.introPageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:self.introPageControl];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    self.introPageControl.currentPage = self.introScrollView.contentOffset.x / self.introScrollView.frame.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     NSLog(@"%s",__func__);
//    float currentIndex = self.introScrollView.contentOffset.x / self.introScrollView.frame.size.width;
//    
//    if (currentIndex > self.introImageNamesArray.count - 1)
//        [self onStartButton];
    if (self.introScrollView.contentOffset.x > self.introScrollView.frame.size.width) {
        [self onStartButton];
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s",__func__);
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"%s",__func__);
}
#pragma mark - Button action

- (void)onStartButton
{
    
    if ([delegate respondsToSelector:@selector(introDidFinish)]) {
        [delegate introDidFinish];
    }
}


@end
