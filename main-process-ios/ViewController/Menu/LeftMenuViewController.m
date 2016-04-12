//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"

@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	
	return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
	self.tableView.backgroundView = imageView;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];

	switch (indexPath.row)
	{
        
		case 0:
        {
            cell.textLabel.text = @"    帐号管理";
            UIImage *icon = [UIImage imageNamed:@"menu_icon_user"];
            [self configureCellImage:icon cell:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
			
		case 1:
        {
			cell.textLabel.text = @"    设备管理";
            UIImage *icon = [UIImage imageNamed:@"menu_icon_device"];
            [self configureCellImage:icon cell:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
        }
			
		case 2:
        {
			cell.textLabel.text = @"    推送消息设置";
            UIImage *icon = [UIImage imageNamed:@"menu_icon_message"];
            [self configureCellImage:icon cell:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
        }
			
		case 3:
        {
			cell.textLabel.text = @"    检测更新";
            UIImage *icon = [UIImage imageNamed:@"menu_icon_edition"];
            [self configureCellImage:icon cell:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
        }
	}
	cell.backgroundColor = [UIColor clearColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:240/255.f green:240/255.f blue:240/255.f alpha:1];
    [cell addSubview:line];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"SURSystemSetting"
															 bundle: nil];
	
	UIViewController *vc ;
	
	switch (indexPath.row)
	{
		case 0:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"SURUserManagerViewController"];
			break;
			
		case 1:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"SURDevicesTableViewController"];
			break;
			
		case 2:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"messageConfiguration"];
			break;
			
		case 3:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"versionManager"];
			break;
	}
	
    [self pushToViewController:vc];
}


- (void)pushToViewController:(UIViewController *) controller
{
    SlideNavigationController *navCtrl = [SlideNavigationController sharedInstance];
    [navCtrl closeMenuWithCompletion:^{
        
    }];
    [navCtrl pushViewController:controller animated:YES];
}

-(void)configureCellImage:(UIImage *)icon cell:(UITableViewCell *)cell
{
    CGSize itemSize = CGSizeMake(25, 20);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
