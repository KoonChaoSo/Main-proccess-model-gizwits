//
//  SURMainViewController.h
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/29.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSlideMenuMainViewController.h"
#import "GIZBasicFlowViewController.h"
@interface SURMainViewController : GIZBasicFlowViewController <UITableViewDataSource,UITableViewDelegate>
{
    @public
    BOOL isNeedToLogin;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
