#import "SURPasswordField.h"

@interface SURPasswordField()

@property (nonatomic, strong) UIButton *btnSwitch;
@property (nonatomic, strong) UIButton *btnClear;
@end

@implementation SURPasswordField


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    CGFloat viewHeight = self.frame.size.height;
    //按钮
    self.btnSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSwitch setImage:[UIImage imageNamed:@"eye_icon"] forState:UIControlStateNormal];
    [self.btnSwitch setImage:[UIImage imageNamed:@"eye_icon"] forState:UIControlStateSelected];
    [self.btnSwitch addTarget:self action:@selector(onSwitch) forControlEvents:UIControlEventTouchUpInside];
    self.btnSwitch.frame = CGRectMake(0, 0, viewHeight, viewHeight - 10);
    
    self.btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnClear setImage:[UIImage imageNamed:@"cancel__Input box_icon"] forState:UIControlStateNormal];
    [self.btnClear addTarget:self action:@selector(onDelete) forControlEvents:UIControlEventTouchUpInside];
    self.btnClear.frame = CGRectMake(viewHeight + 10,-1,viewHeight,viewHeight - 10);
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewHeight * 2 + 10, 20)];
    [self.rightView addSubview:self.btnSwitch];
    [self.rightView addSubview:self.btnClear];
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)onSwitch
{
    self.btnSwitch.selected = !self.btnSwitch.selected;
    self.secureTextEntry = !self.btnSwitch.selected;
    [self becomeFirstResponder];
}

-(void)onDelete{
    
    self.text = @"";
    
}

@end
