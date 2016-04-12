//
//  SURChartViewController.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/10.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"

@interface SURChartViewController : UIViewController <EColumnChartDelegate, EColumnChartDataSource>

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIView *touchSwipeView;

@end
