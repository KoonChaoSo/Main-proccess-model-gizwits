//
//  SURChartViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/10.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURChartViewController.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#include <stdlib.h>

CGFloat const gestureMinimumTranslation = 20.0 ;

typedef enum : NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection ;

@interface SURChartViewController ()
{
    CameraMoveDirection direction;
    
    NSArray *dateList;
    NSArray *dayList;
    NSArray *todayList;
    NSArray *totalWater;
    
    UIPanGestureRecognizer *recognizer1;
}

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;
@property (weak, nonatomic) IBOutlet UIView *pageView;

@property (weak, nonatomic) IBOutlet UILabel *labelSum;
@property (weak, nonatomic) IBOutlet UIView *charContentView;

@property (weak, nonatomic) IBOutlet UILabel *labelTodayTotalWater;
@property (weak, nonatomic) IBOutlet UILabel *labelMonthTotalWater;
@property (weak, nonatomic) IBOutlet UILabel *labelPreTotalWater;

@end

@implementation SURChartViewController
@synthesize tempColor = _tempColor;
@synthesize eFloatBox = _eFloatBox;
@synthesize eColumnChart = _eColumnChart;
@synthesize data = _data;
@synthesize eColumnSelected = _eColumnSelected;
@synthesize valueLabel = _valueLabel;

#pragma -mark- ViewController Life Circle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    temp = [@[] mutableCopy];
    for (int i = 1;i < 31;i++)
    {

        [temp addObject:@(i)];

    }
    dateList = [temp copy];
    temp = [@[] mutableCopy];
    for (int i = 0;i < 25;i++)
    {

        [temp addObject:@(i)];

    }
    dayList = [temp copy];
    temp = [@[] mutableCopy];
    for (int i = 1;i < 11;i++)
    {

        [temp addObject:@(i)];

    }
    todayList = [temp copy];
    
    totalWater = @[@"",@"88",@"88",@"88"];
    [self reloadDataForChart:todayList];
    [self configureTabBarTotalWater];
    [self configureTotalWater];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
 
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}



#pragma -mark- EColumnChartDataSource

- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return 7;
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
{
      NSLog(@"Finger did leave %f", eColumn.eColumnDataModel.value);
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
    /**The EFloatBox here, is just to show an example of
     taking adventage of the event handling system of the Echart.
     You can do even better effects here, according to your needs.*/
    
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidLeaveColumn:(EColumn *)eColumn
{
    NSLog(@"Finger did leave %d", eColumn.eColumnDataModel.index);
    
}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{

}

- ( void )handleSwipe:( UIPanGestureRecognizer *)gesture

{
    
    CGPoint translation = [gesture translationInView: self .view];
    
    if (gesture.state == UIGestureRecognizerStateBegan )
        
    {
        
        direction = kCameraMoveDirectionNone;
        
    }
    
    else if (gesture.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone)
        
    {
        
        direction = [ self determineCameraDirectionIfNeeded:translation];
        
        // ok, now initiate movement in the direction indicated by the user's gesture
        
        switch (direction) {
                
            case kCameraMoveDirectionDown:
                
                NSLog (@ "Start moving down" );
                
                break ;
                
            case kCameraMoveDirectionUp:
                
                NSLog (@ "Start moving up" );
                
                break ;
                
            case kCameraMoveDirectionRight:
                
                NSLog (@ "Start moving right" );

                
                [_eColumnChart moveLeft];
                break ;
                
            case kCameraMoveDirectionLeft:
                
                NSLog (@ "Start moving left" );
                [_eColumnChart moveRight];
                
                break ;
                
            default :
                
                break ;
                
        }
        
    }
    
    else if (gesture.state == UIGestureRecognizerStateEnded )
        
    {
        
        // now tell the camera to stop
        
        NSLog (@ "Stop" );
        
    }
    
}

// This method will determine whether the direction of the user's swipe

- (CameraMoveDirection )determineCameraDirectionIfNeeded:( CGPoint )translation

{
    
    if (direction != kCameraMoveDirectionNone)
        
        return direction;
    
    // determine if horizontal swipe only if you meet some minimum velocity
    
    if (fabs(translation.x) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0 )
            
            gestureHorizontal = YES;
        
        else
            
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        
        if (gestureHorizontal)
            
        {
            
            if (translation.x > 0.0 )
                
                return kCameraMoveDirectionRight;
            
            else
                
                return kCameraMoveDirectionLeft;
            
        }
        
    }
    
    // determine if vertical swipe only if you meet some minimum velocity
    
    else if (fabs(translation.y) > gestureMinimumTranslation)
        
    {
        
        BOOL gestureVertical = NO;
        
        if (translation.x == 0.0 )
            
            gestureVertical = YES;
        
        else
            
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        
        if (gestureVertical)
            
        {
            
            if (translation.y > 0.0 )
                
                return kCameraMoveDirectionDown;
            
            else
                
                return kCameraMoveDirectionUp;
            
        }
        
    }
    
    return direction;
    
}


-(void)configureRecognizer
{

    recognizer1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    [_eColumnChart addGestureRecognizer:recognizer1];
    
}
- (IBAction)onPreCleanWaterCapacity:(id)sender {
    [self reloadDataForChart:todayList];
    [self movePageView:1];
    
}

- (IBAction)onNowDayCleanWaterCapacity:(id)sender {
    [self reloadDataForChart:dayList];
    [self movePageView:2];
}

- (IBAction)onNowMonthCleanWaterCapacity:(id)sender {
    [self reloadDataForChart:dateList];
    [self movePageView:3];
}

-(void)reloadDataForChart:(NSArray *)list
{
    [self removeChart];
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < list.count; i++)
    {
        int value = [list[i] intValue];
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%02d", i+1] value:value index:i unit:@""];
        [temp addObject:eColumnDataModel];
    }
    _data = [NSArray arrayWithArray:temp];
    

    _eColumnChart = nil;
    
    [self configureEChart];
    [self configureRecognizer];
}
-(void)removeChart
{
    [_eColumnChart removeGestureRecognizer:recognizer1];
    [_eColumnChart removeChart];
    
    _eColumnChart = nil;
}

-(void)configureEChart
{
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 30, [UIScreen mainScreen].bounds.size.width-40, 200)];
    _eColumnChart.maxColumnColor = EDarkOceanBlue;
    _eColumnChart.minColumnColor = EOceanBlue;
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    [_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    [self.charContentView addSubview:_eColumnChart];
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)movePageView:(int)page
{
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //改变它的frame的x,y的值
    
    int moveWidth = kScreen_Width / 6;
    _pageView.center = CGPointMake(moveWidth * (2 * page - 1 ), 77);
    [UIView commitAnimations];
}

-(void)configureTotalWater
{
    self.labelSum.text = @"88";
}

-(void)configureTabBarTotalWater
{
    for (int page = 1;page <= 3 ; page ++)
    {
        NSString *waterCapacity = totalWater[page];
        NSString *result = [NSString stringWithFormat:@"%@L",waterCapacity];
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:result];
        
        [attriString addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:25.f]
                            range:NSMakeRange(0, [self getTotalDaysSize:waterCapacity.intValue])];
        
        if (page == 1)
        {
            self.labelPreTotalWater.attributedText = attriString;
        }
        else if (page == 2)
        {
            self.labelTodayTotalWater.attributedText = attriString;
        }
        else if (page == 3)
        {
            self.labelMonthTotalWater.attributedText = attriString;
        }
    }
}

-(int)getTotalDaysSize:(int)number
{
    int nNum = number;
    int i = 0;
    while(nNum > 1 || nNum < -1)
    {
        nNum  = nNum / 10;
        i++;
    }
    printf("%d", i+1);
    return i;
}
@end
