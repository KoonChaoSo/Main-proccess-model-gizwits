//
//  SURHeaterSettingMainTableViewCell.h
//  sunrainapp_ios
//
//  Created by Cmb on 9/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SURHeaterSettingMainCellSettingTimingTitle,
    SURHeaterSettingMainCellSettingTimingContent,
    SURHeaterSettingMainCellInfraredDetectionTitle,
    SURHeaterSettingMainCellInfraredDetectionContent,
}SURHeaterSettingMainCellType;

@protocol SURHeaterSettingMainTableViewCellDelegate <NSObject>

@optional
// 开关按钮返回
-(void)selectedButtonReturn:(UISwitch *)onOff identificationName:(NSString*)identificationName;
// 开关按钮返回
-(void)selectedButtonReturnInfraredDetection:(UISwitch *)onOff identificationName:(NSString*)identificationName;

@end

@interface SURHeaterSettingMainTableViewCell : UITableViewCell

///////////////////////////////// 设置温度标题 //////////////////////////////
// 视图
@property (strong, nonatomic) IBOutlet UIView *SURSettingTimingTitleView;
// 标题
@property (strong, nonatomic) IBOutlet UILabel *SURSettingTimingTitleViewTitle;


///////////////////////////////// 设置温度内容 //////////////////////////////
// 视图
@property (strong, nonatomic) IBOutlet UIView *SURSettingTimingContentView;
// 温度
@property (strong, nonatomic) IBOutlet UILabel *SURSettingTimingContentViewTemperature;
// 时间
@property (strong, nonatomic) IBOutlet UILabel *SURSettingTimingContentViewTime;
// 开关
@property (strong, nonatomic) IBOutlet UISwitch *SURSettingTimingContentViewSwitch;

///////////////////////////////// 红外检测标题 //////////////////////////////
// 视图
@property (strong, nonatomic) IBOutlet UIView *SURInfraredDetectionTitleView;
// 标题
@property (strong, nonatomic) IBOutlet UILabel *SURInfraredDetectionTitleViewTitle;
// 内容
@property (strong, nonatomic) IBOutlet UILabel *SURInfraredDetectionTitleViewContent;
@property (strong, nonatomic) IBOutlet UIImageView *SURInfraredDetectionTitleViewAddImageView;


///////////////////////////////// 红外检测内容 //////////////////////////////
// 视图
@property (strong, nonatomic) IBOutlet UIView *SURInfraredDetectionContentView;
// 温度
@property (strong, nonatomic) IBOutlet UILabel *SURInfraredDetectionContentViewTemperature;
// 开关
@property (strong, nonatomic) IBOutlet UISwitch *SURInfraredDetectionContentViewSwitch;


@property (strong,nonatomic)  NSString *identificationName;

@property (assign, nonatomic) id<SURHeaterSettingMainTableViewCellDelegate> delegate;

-(void)changeCellMode:(SURHeaterSettingMainCellType)mode;

@end
