//
//  SURHeaterSettingMainTableViewCell.m
//  sunrainapp_ios
//
//  Created by Cmb on 9/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURHeaterSettingMainTableViewCell.h"

@implementation SURHeaterSettingMainTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/* 转换模式 */
-(void)changeCellMode:(SURHeaterSettingMainCellType)mode{
    switch (mode) {
        case SURHeaterSettingMainCellSettingTimingTitle:
            [self.SURSettingTimingTitleView setHidden:NO];
            [self.SURSettingTimingContentView setHidden:YES];
            [self.SURInfraredDetectionTitleView setHidden:YES];
            [self.SURInfraredDetectionContentView setHidden:YES];
            break;
        case SURHeaterSettingMainCellSettingTimingContent:
            [self.SURSettingTimingTitleView setHidden:YES];
            [self.SURSettingTimingContentView setHidden:NO];
            [self.SURInfraredDetectionTitleView setHidden:YES];
            [self.SURInfraredDetectionContentView setHidden:YES];
            break;
        case SURHeaterSettingMainCellInfraredDetectionTitle:
            [self.SURSettingTimingTitleView setHidden:YES];
            [self.SURSettingTimingContentView setHidden:YES];
            [self.SURInfraredDetectionTitleView setHidden:NO];
            [self.SURInfraredDetectionContentView setHidden:YES];
            break;
        case SURHeaterSettingMainCellInfraredDetectionContent:
            [self.SURSettingTimingTitleView setHidden:YES];
            [self.SURSettingTimingContentView setHidden:YES];
            [self.SURInfraredDetectionTitleView setHidden:YES];
            [self.SURInfraredDetectionContentView setHidden:NO];
            break;
        default:
            break;
    }
}
- (IBAction)switchButtonAction_2:(id)sender {
    UISwitch *onOff = (UISwitch *)sender;
    if ([_delegate respondsToSelector:@selector(selectedButtonReturn:identificationName:)])
    {
        [_delegate selectedButtonReturn:sender identificationName:self.identificationName];
        
    }
}

- (IBAction)switchButtonAction:(id)sender {
    UISwitch *onOff = (UISwitch *)sender;
    
    if ([_delegate respondsToSelector:@selector(selectedButtonReturnInfraredDetection:identificationName:)])
    {
       [_delegate selectedButtonReturnInfraredDetection:sender identificationName:self.identificationName];
    }
}

@end
