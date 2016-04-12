//
//  VWWWaterView.h
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterWaveView : UIView

@property(strong, nonatomic) UIColor *currentWaterColor;

- (id)initWithFrame:(CGRect)frame withPeak:(NSInteger)peak withSpeed:(float)speed withColor:(UIColor*)color withOffset:(float)offset;

@end
