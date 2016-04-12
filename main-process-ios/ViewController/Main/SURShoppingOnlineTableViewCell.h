//
//  SURShoppingOnlineTableViewCell.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/2.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SURShoppingOnlineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;


-(void)updateCellWithImage:(UIImage *)image title:(NSString *)title;
@end
