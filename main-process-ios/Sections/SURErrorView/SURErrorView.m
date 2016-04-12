//
//  SURErrorView.m
//  sunrainapp_ios
//
//  Created by ChaoSo on 15/10/8.
//  Copyright © 2015年 Sunrain. All rights reserved.
//

#import "SURErrorView.h"


@interface SURErrorView()<ImagesCircleViewDelegate>
{
    
}
@property (strong, nonatomic) NSArray *totalWarning;
@property (strong, nonatomic) ImagesCircleView *circleView;
@end

@implementation SURErrorView

- (instancetype)initWithNibName:(NSString *)nibName owner:(id)owner
{
    if (nibName)
    {
        return [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil].lastObject;
    }
    return (SURErrorView *)[UIView new];
}

-(void)onTotalWarningList
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [list addObjectsFromArray:self.errorArray];
    [list addObjectsFromArray:self.alertArray];
    self.totalWarning = [list copy];
    
    _errorImageView.image = [UIImage imageNamed:self.errorImageName];
}


-(void)configurePreButtonAndNextButton:(NSInteger)buttonIndex
{
    _preButton.hidden = NO;
    _nextButton.hidden = NO;
    if (buttonIndex == 0)
    {
        _preButton.hidden = YES;
    }
    if (buttonIndex == self.totalWarning.count - 1 || self.totalWarning.count == 1)
    {
        _nextButton.hidden = YES;
    }
}

//-(void)configureTitle:(NSString *)title
//{
//    _errorName.text = title;
//}

-(void)onPreButton
{
    [self onTotalWarningList];
    if (_index <= 0)
    {
        _index = 0;
    }else
    {
        _index --;
    }
    NSString *title = self.totalWarning[_index];
    [self configurePreButtonAndNextButton:_index];
//    [self configureTitle:title];
}

- (void)onNextButton
{
    [self onTotalWarningList];

    
    if (_index >= self.totalWarning.count - 1)
    {
        _index = self.totalWarning.count - 1;
    }
    else
    {
        _index ++;
    }
    NSString *title = self.totalWarning[_index];
    [self configurePreButtonAndNextButton:_index];
//    [self configureTitle:title];
}

- (void)onLabelTitle
{
    NSString *title = self.totalWarning[_index];
    if ([_delegate respondsToSelector:@selector(clickErrorList:name:)])
    {
        [_delegate clickErrorList:self name:title];
    }
}

-(void)showList
{
    _index = 0;
    [self onTotalWarningList];
    if (self.errorArray.count > 0 || self.alertArray.count > 0)
    {
        [self configurePreButtonAndNextButton:_index];
        
        NSString *title = self.totalWarning[_index];
        
//        [self configureTitle:title];
    }
    _errorView.imageInfos = _totalWarning;
}

-(void)setAlertArray:(NSArray *)alertArray
{
    NSMutableArray *alertList = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in alertArray) {
        NSArray *allKeys = dic.allKeys;
        for (NSString *str in allKeys)
        {
            NSInteger result = [[dic objectForKey:str] integerValue];
            if (result)
            {
                [alertList addObject:str];
            }
        }
    }
    
    _alertArray = [alertList copy];
}


-(void)setErrorArray:(NSArray *)errorArray
{
    NSMutableArray *errorList = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in errorArray) {
        NSArray *allKeys = dic.allKeys;
        for (NSString *str in allKeys)
        {
            NSInteger result = [[dic objectForKey:str] integerValue];
            if (result)
            {
                [errorList addObject:str];
            }
        }
    }
    _errorArray = [errorList copy];
}


#pragma dataSource
- (void)scrollImagesFromView:(UIView *)view info:(id)info {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 120, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = info;
    label.textColor = self.colorForError;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
}
#pragma mark - delegate
#pragma mark - did Tap
- (void)scrollImagesDidSelectItemInfo:(id)info {
    NSString *title = info;
    if ([_delegate respondsToSelector:@selector(clickErrorList:name:)])
    {
        [_delegate clickErrorList:self name:title];
    }

}

@end
