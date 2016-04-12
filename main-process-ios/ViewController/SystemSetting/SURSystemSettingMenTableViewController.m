//
//  SURSystemSettingMenTableViewController.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/9/26.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURSystemSettingMenTableViewController.h"
#import "SURDeviceTypeTableViewCell.h"

@interface SURSystemSettingMenTableViewController ()
{
    NSArray *menuList;
}

@end

@implementation SURSystemSettingMenTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    menuList = @[@"用户管理",@"设备管理",@"消息推送设置",@"检测更新"];
    self.tableView.allowsSelection = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [self performSegueWithIdentifier:@"toAccountManager" sender:self];
            break;
        }
        case 1:
        {
            [self performSegueWithIdentifier:@"toDeviceManager" sender:self];
            break;
        }
        case 2:
        {
            [self performSegueWithIdentifier:@"toPushMessageManager" sender:self];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *customCellIdentifier = @"DeviceTypeCell";
    static NSString *nibIdentifier        = @"SURDeviceTypeTableViewCell";
    
    
    SURDeviceTypeTableViewCell *cell = (SURDeviceTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    
    
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:nibIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:customCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    }
    
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row < menuList.count)
    {
        cell.cellNameLabel.text = menuList[indexPath.row];
    }
    
    return cell;
}

@end
