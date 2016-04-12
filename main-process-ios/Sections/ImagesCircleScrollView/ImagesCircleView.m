//
//  ImagesCircleView.h
//  PageScrollView
//
//  Created by Benster on 15/9/25.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import "ImagesCircleView.h"

@interface ImagesCircleView()
{
    NSMutableArray *_arrayShowInfos;
}

@property (nonatomic, strong) NSTimer *timerImage;

@end

@implementation ImagesCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled=YES;
        self.backgroundColor=[UIColor clearColor];
        self.delegate = self;
    }
    return self;
}

- (void)setImageInfos:(NSArray *)imageInfos {
    _imageInfos = imageInfos;
    _arrayShowInfos = [NSMutableArray arrayWithArray:imageInfos];
    if (imageInfos.count >= 2) {
        [_arrayShowInfos addObject:[imageInfos firstObject]];
        [_arrayShowInfos insertObject:[imageInfos lastObject] atIndex:0];
    }
    
    for (UIView* itemView in self.subviews) {
        [itemView removeFromSuperview];
    }
    
    BOOL nullImage = NO;
    if (imageInfos.count == 0 &&
        _arrayShowInfos.count == 0 &&
        _defaultImage) {
        nullImage = YES;
        _arrayShowInfos = [NSMutableArray arrayWithObject:_defaultImage];
    }
    
    for (int i = 0; i < _arrayShowInfos.count; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
//        imageView.autoresizingMask =
//        UIViewAutoresizingFlexibleLeftMargin |
//        UIViewAutoresizingFlexibleRightMargin |
//        UIViewAutoresizingFlexibleTopMargin |
//        UIViewAutoresizingFlexibleBottomMargin |
//        UIViewAutoresizingFlexibleHeight |
//        UIViewAutoresizingFlexibleWidth;
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.clipsToBounds = YES;
        
        view.autoresizingMask =
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        
        if (nullImage) {
//            imageView.image = _defaultImage;
        }else {
            if (_imagesCircleDelegate && [_imagesCircleDelegate respondsToSelector:@selector(scrollImagesFromView:info:)]) {
                [_imagesCircleDelegate scrollImagesFromView:view info:_arrayShowInfos[i]];
            }
            view.userInteractionEnabled = YES;
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)]];
        }
        
        [self addSubview:view];
    }
    self.contentSize = CGSizeMake(self.frame.size.width*_arrayShowInfos.count, 0);
    if (_arrayShowInfos.count >= 2) {
        [self scrollToItemIndex:1 animated:NO];
    }
    if (imageInfos.count < 2) {
        [self removeTimerImage];
        return;
    }else {
        self.duration = _duration;
    }
}

- (void)scrollToItemIndex:(NSInteger)index animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.frame.size.width*index, 0) animated:animated];
}


- (void)imageViewClick:(UITapGestureRecognizer *)_gesture {
    UIView *imageView = _gesture.view;
    int numCount = CGRectGetMidX(imageView.frame)/self.frame.size.width;
    if (_imageInfos.count == 0) {
        return;
    }
    if (_imagesCircleDelegate && [_imagesCircleDelegate respondsToSelector:@selector(scrollImagesDidSelectItemInfo:)]) {
        [_imagesCircleDelegate scrollImagesDidSelectItemInfo:_arrayShowInfos[numCount]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_arrayShowInfos.count >= 2) {
        float targetX = scrollView.contentOffset.x;
        int numCount = targetX/scrollView.frame.size.width;
        if (numCount == 0 || numCount == _arrayShowInfos.count-1) {
            NSInteger num = (numCount == 0) ? _arrayShowInfos.count-2 : 1;
            
            [self scrollToItemIndex:num animated:NO];
        }
    }
}

-(void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    
    if (_duration <= 0) {
        [self removeTimerImage];
        return;
    }
    [self removeTimerImage];
    //.2*2  .2是最小间隔 在下面scrollImageTime 定义.2
    _duration = MAX(.4, _duration);
    
    _timerImage = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(scrollImageTime) userInfo:nil repeats:YES];
}

- (void)scrollImageTime {
    if (_arrayShowInfos.count >= 2) {
        float targetX = self.contentOffset.x;
        int numCount = targetX/self.frame.size.width;
        numCount++;
        NSInteger numNext = numCount;
        if (numCount == 0 || numCount == _arrayShowInfos.count-1) {
            [self scrollToItemIndex:numCount animated:YES];
            numNext = (numCount == 0) ? _arrayShowInfos.count-2 : 1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self scrollToItemIndex:numNext animated:NO];
//                if (_imagesCircleDelegate && [_imagesCircleDelegate respondsToSelector:@selector(scrollCount:)]) {
//                    [_imagesCircleDelegate scrollCount:numCount];
//                }
            });
            
            
        }else {
            [self scrollToItemIndex:numNext animated:YES];
//            if (_imagesCircleDelegate && [_imagesCircleDelegate respondsToSelector:@selector(scrollCount:)]) {
//                [_imagesCircleDelegate scrollCount:numCount];
//            }
        }
    }
}

- (void)removeTimerImage {
    if (_timerImage) {
        [_timerImage invalidate];
        _timerImage = nil;
    }
}

- (void)removeTimer {
    [self removeTimerImage];
}

/**
 *  将图片滑到正常的位置
 */
- (void)scrollImageToPagePlace {
    if (_imageInfos.count > 0) {
        float targetX = self.contentOffset.x;
        int numCount = targetX/self.frame.size.width;
        [self scrollToItemIndex:numCount animated:NO];
    }
}

- (void)dealloc {
    [self removeTimerImage];
    
}

@end
