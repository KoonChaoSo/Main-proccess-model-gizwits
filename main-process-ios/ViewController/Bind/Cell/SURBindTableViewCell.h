//
//  SURNoSetTableViewCell.h
//  sunrainapp_ios
//
//  Created by Cmb on 24/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SURBindTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellStatus;

-(void)updateCellWithIsOnline:(BOOL)isOnline
                    WithisLan:(BOOL)isLan
                   WithRemark:(NSString *)name
                      WithMac:(NSString *)mac;

//-(void)updateCellWithMac:(NSString *)mac;

@end
