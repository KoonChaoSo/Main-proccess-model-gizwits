//
//  SURShoppingOnlineTableViewCell.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/2.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURShoppingOnlineTableViewCell.h"

@implementation SURShoppingOnlineTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCellWithImage:(UIImage *)image title:(NSString *)title
{
    self.leftImageView.image = image;
    self.labelTitle.text = title;
}

- (IBAction)onOfficialWebView:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sunrain.com"]];
}
- (IBAction)onHotSellShop:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.taobao.com"]];
}

@end
