//
//  SURSelectProductionTypeViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 24/9/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "GIZDeviceListViewController.h"
#import "SURBindTableViewCell.h"
#import "GIZUtils.h"
#import "SURSearchingConfigurationEquipmentViewController.h"
#import "StepFrameView.h"

@interface GIZDeviceListViewController ()

@property (weak, nonatomic) IBOutlet UIView *disconnectView;
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (strong, nonatomic) NSArray *deviceTypeList;
@property (weak, nonatomic) IBOutlet UIView *stepFrameView;

@end

@implementation GIZDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 虚拟数据导入，后面删除
    NSArray *array = [[NSArray alloc] initWithObjects:
                                    @{@"净水器"      : GIZWaterPurifierProductKey},
                                    @{@"太阳能热水器" : GIZWaterHeaterProductKey},

                                    nil];
    self.deviceTypeList = array;
    
    StepFrameView *sf = [[StepFrameView alloc] initFourStep:secondStep];
    [sf.backButton addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    [self.stepFrameView addSubview:sf];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)dealloc
{
//    [sf.backButton addTarget:self action:];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onCancel:(id)sender {
    [self.disconnectView setHidden:YES];
    [self.selectTableView setUserInteractionEnabled:YES];
}

#pragma mark TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

/*tableView显示个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.deviceTypeList count];
}

/*生成row*/
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *customCellIdentifier = @"selectedDeviceType";
    static NSString *nibIdentifier        = @"SURBindTableViewCell";
    
    
    SURBindTableViewCell *cell = (SURBindTableViewCell *)[tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    
    NSUInteger row = [indexPath row];
    
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:nibIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:customCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    }
    
    NSString *labelNameContent = ((NSDictionary *)[self.deviceTypeList objectAtIndex:row]).allKeys[0];
    NSString *selectedTypeProductKey = ((NSDictionary *)[self.deviceTypeList objectAtIndex:row]).allValues[0];
    
    cell.cellLabel.text = labelNameContent;
    if ([selectedTypeProductKey isEqualToString:GIZWaterHeaterProductKey])
    {
        cell.cellImageView.image = [UIImage imageNamed:@"search_device_heater_ps"];
        cell.cellLabel.textColor = SUNRAIN_OCEAN_BLUE;
    }
    else if ([selectedTypeProductKey isEqualToString:GIZWaterPurifierProductKey ])
    {
        cell.cellImageView.image = [UIImage imageNamed:@"search_device_water_ps"];
        cell.cellLabel.textColor = SUNRAIN_BLUE;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger index = indexPath.row;
    NSString* senderValue = [[self.deviceTypeList objectAtIndex:index] objectForKey:((NSDictionary *)[self.deviceTypeList objectAtIndex:index]).allKeys[0]];
    [self performSegueWithIdentifier:@"toConfigure" sender:senderValue];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *viewController = segue.destinationViewController;
    [viewController setValue:(NSString*)sender forKey:@"productKey"];
}


-(void)backToFront
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
