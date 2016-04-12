//
//  SURHeaterExceptionDetailsViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 8/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURHeaterExceptionDetailsViewController.h"

@interface SURHeaterExceptionDetailsViewController ()

// 异常标题
@property (weak, nonatomic) IBOutlet UILabel *exceptionTitleLabel;
// 电话号码
@property (weak, nonatomic) IBOutlet UILabel *callNumberLabel;
// 异常内容
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation SURHeaterExceptionDetailsViewController

- (instancetype)initWithExceptionTitle:(NSString*)title{
    self = [super init];
    if (self) {
        self.exceptionTitleLabel.text = title;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title                = @"故障报警";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.exceptionTitleLabel.text = _exceptionTitle;
    
    if([_exceptionTitle isEqual:@"红外入侵"]){
        self.contentLabel.text = @"警报！有不明访客入侵";
    }else if([_exceptionTitle isEqual:@"漏电"]){
        self.contentLabel.text = @"请立即拔掉插头，检查后，重新连接";
    }else if([_exceptionTitle isEqual:@"传感器故障"]){
        self.contentLabel.text = @"请关闭电源，重新开机”，下方显示";
    }else if([_exceptionTitle isEqual:@"超高温"]){
        self.contentLabel.text = @"请关闭电源，待水温下降后，重新开机";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callButtonAction:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4008603366"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
