//
//  VWWWaterView.m
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import "WaterWaveView.h"

@interface WaterWaveView ()
{
    
    float _currentLinePointY;
    
    float a;
    float b;
    BOOL jia;

}
@property (assign, nonatomic) int peak;

@end


@implementation WaterWaveView


- (id)initWithFrame:(CGRect)frame withPeak:(NSInteger)peak withSpeed:(float)speed withColor:(UIColor*)color withOffset:(float)offset
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.peak = peak;
        
        a = self.peak;
        b = 0;
        jia = NO;
        
        _currentWaterColor = color;
        _currentLinePointY = offset;
        
        [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        
    }
    return self;
}

-(void)animateWave
{
    if (jia) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    
    if (a<=1) {
        jia = YES;
    }
    
    if (a>=self.peak) {
        jia = NO;
    }
    
    b+=0.1;
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    
    float y=_currentLinePointY;
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=0;x<=rect.size.height;x++){
        y= a * sin( x/(rect.size.height/6)*M_PI + 4*b/M_PI ) * 5 + _currentLinePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, rect.size.height, rect.size.width);
    CGPathAddLineToPoint(path, nil, 0,   rect.size.width);
    CGPathAddLineToPoint(path, nil, 0,   _currentLinePointY);

    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}




@end
