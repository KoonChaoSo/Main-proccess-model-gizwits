//
//  SURNoSetTableViewCell.m
//  sunrainapp_ios
//
//  Created by Cmb on 24/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURBindTableViewCell.h"

@implementation SURBindTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)updateCellWithMac:(NSString *)mac
//{
//    if(nil != mac)
//    {
//        NSString *macResult = [mac substringWithRange: NSMakeRange(mac.length -4,4)];
//        NSString *remarkName = [NSString stringWithFormat:@"智能电暖气%@",macResult];
//        self.textRemark.text = remarkName;
//    }
//    self.imageViewStatus.image = [UIImage imageNamed:@"Device online_icon@2x.png"];
//    self.textStatus.text = @"点击绑定";
//    self.textStatus.textColor = [UIColor orangeColor];
//}

-(void)updateCellWithIsOnline:(BOOL)isOnline
                    WithisLan:(BOOL)isLan
                   WithRemark:(NSString *)name
                      WithMac:(NSString *)mac{
    
    
    if(!isOnline)
    {
        self.cellStatus.text = @"离线";
        self.cellImageView.image = [UIImage imageNamed:@"Device is not online_icon"];
        self.cellLabel.textColor = [UIColor grayColor];
    }
    else
    {
        if(isLan){
            self.cellStatus.text = @"局域网在线";
            self.cellImageView.image = [UIImage imageNamed:@"Device online_icon@2x.png"];
        }
        else{
            self.cellStatus.text = @"远程在线";
            self.cellImageView.image = [UIImage imageNamed:@"Device online_icon@2x.png"];
        }
    }
    if(nil != mac){
        NSString *macResult = [mac substringFromIndex:(mac.length-5)];
#warning todo 设备名称暂时不知道 以后作修改
        NSString *remarkName = [NSString stringWithFormat:@"%@",macResult];
        self.cellLabel.text = remarkName;
    }
    if(![name isEqualToString:@""]){
        self.cellLabel.text = name;
    }
    
}

@end
