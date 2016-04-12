//
//  SURExceptionDetailsViewController.m
//  sunrainapp_ios
//
//  Created by Cmb on 1/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURExceptionDetailsViewController.h"

@interface SURExceptionDetailsViewController ()

// 异常标题
@property (weak, nonatomic) IBOutlet UILabel *exceptionTitleLabel;
// 电话号码
@property (weak, nonatomic) IBOutlet UILabel *callNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentLabel;

@end

@implementation SURExceptionDetailsViewController

- (instancetype)initWithExceptionTitle:(NSString*)title{
    self = [super init];
    if (self) {
        _exceptionTitle = title;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title                     = @"故障报警";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exceptionTitleLabel.text = _exceptionTitle;
    
    if([_exceptionTitle isEqual:@"水泵异常"]){
        self.contentLabel.text = @"水泵异常!，检查后，重新连接";
    }else if([_exceptionTitle isEqual:@"流量计异常"]){
        self.contentLabel.text = @"请立即拔掉插头，检查后，重新连接";
    }else if([_exceptionTitle isEqual:@"温度传感器异常"]){
        self.contentLabel.text = @"请关闭电源，重新开机”，下方显示";
    }else if([_exceptionTitle isEqual:@"高压开关异常"]){
        self.contentLabel.text = @"请关闭电源，待水压下降后，重新开机";
    }else if([_exceptionTitle isEqual:@"高压开关异常"]){
        self.contentLabel.text = @"请关闭电源，高压开关异常，重新开机";
        
    }else if([_exceptionTitle isEqual:@"低压开关异常"]){
    self.contentLabel.text = @"请关闭电源，低压开关异常，重新开机";
    }
    else if([_exceptionTitle isEqual:@"漏水异常"]){
        self.contentLabel.text = @"请关闭电源，漏水异常，重新开机";
    }

    else if([_exceptionTitle isEqual:@"溢水异常"]){
        self.contentLabel.text = @"请关闭电源，溢水异常，重新开机";


    }
    else if([_exceptionTitle isEqual:@"水箱缺水异常"]){
    
        self.contentLabel.text = @"请关闭电源，水箱缺水异常，重新开机";


    }
    else if([_exceptionTitle isEqual:@"进水电磁阀故障"]){
        
        self.contentLabel.text = @"请关闭电源，进水电磁阀故障，重新开机";
        
        
    }
    else if([_exceptionTitle isEqual:@"冲洗电磁阀故障"]){
        
        
        self.contentLabel.text = @"请关闭电源，冲洗电磁阀故障，重新开机";
        
    }
    else if([_exceptionTitle isEqual:@"制冷异常"]){
        
        
        self.contentLabel.text = @"请关闭电源，制冷异常，重新开机";
        
    }
    else if([_exceptionTitle isEqual:@"制热异常"]){
        
        
        self.contentLabel.text = @"请关闭电源，制热异常，重新开机";
        
    }
}



// 拨打电话按钮响应
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
