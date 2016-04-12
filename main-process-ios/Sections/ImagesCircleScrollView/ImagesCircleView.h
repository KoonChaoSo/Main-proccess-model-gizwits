//
//  ImagesCircleView.h
//  PageScrollView
//
//  Created by Benster on 15/9/25.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagesCircleViewDelegate <NSObject>

@optional

- (void)scrollImagesDidSelectItemInfo:(id)info;
- (void)scrollCount:(int)count;
@required
- (void)scrollImagesFromView:(UIView *)imageView info:(id)info;

@end

@interface ImagesCircleView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *defaultImage;

@property (nonatomic, assign) id<ImagesCircleViewDelegate> imagesCircleDelegate;

@property (nonatomic, strong) NSArray *imageInfos;

@property (nonatomic, assign) NSTimeInterval duration;

- (void)removeTimer;

/**
 *  将图片滑到正常的位置
 */
- (void)scrollImageToPagePlace;

@end
