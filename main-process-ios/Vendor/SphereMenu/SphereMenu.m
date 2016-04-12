//
//  SphereMenu.m
//  SphereMenu
//
//  Created by Tu You on 14-8-24.
//  Copyright (c) 2014年 TU YOU. All rights reserved.
//

#import "SphereMenu.h"

static const int kItemInitTag = 1001;
static const CGFloat kAngleOffset = M_PI_4;
static const CGFloat kSphereLength = 80;
static const float kSphereDamping = 0.3;
static const SphereMenuType kType = SectorSphereMenuType;

@interface SphereMenu () <UICollisionBehaviorDelegate>

@property (nonatomic, assign) NSUInteger count ;
@property (nonatomic, strong) UIImage *startImage;
@property (nonatomic, strong) UIImage *endImage;
@property (nonatomic, copy) UIImageView *tempImageView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *positions;

// animator and behaviors
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) NSMutableArray *snaps;

@property (nonatomic, strong) UITapGestureRecognizer *tapOnStart;

@property (nonatomic, strong) id<UIDynamicItem> bumper;
@property (nonatomic, assign) BOOL expanded;

@end


@implementation SphereMenu
-(instancetype)initWithStartPoint:(CGPoint)startPoint startImage:(UIImage *)startImage endImage:(UIImage *)endImage submenuImages:(NSArray *)images{
    
    if (self = [super init]) {
        
        self.bounds = CGRectMake(0, 0, startImage.size.width, startImage.size.height);
        self.center = startPoint;
        
        _angle = kAngleOffset;
        _sphereLength = kSphereLength;
        _sphereDamping = kSphereDamping;
        _type = kType;
        
        _images = images;
        _count = self.images.count;
        _startImage = startImage;
        _endImage = endImage;
        
        _tempImageView = [[UIImageView alloc] initWithImage:startImage];
        _tempImageView.userInteractionEnabled = YES;
        
        _tapOnStart = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(startTapped:)];
        [_tempImageView addGestureRecognizer:_tapOnStart];
        [self addSubview:_tempImageView];
    }
    return self;
    
    
}

- (instancetype)initWithStartPoint:(CGPoint)startPoint startImage:(UIImage *)startImage submenuImages:(NSArray *)images
{
    if (self = [super init]) {
        
        self.bounds = CGRectMake(0, 0, startImage.size.width, startImage.size.height);
        self.center = startPoint;
        
        _angle = kAngleOffset;
        _sphereLength = kSphereLength;
        _sphereDamping = kSphereDamping;
        
        _images = images;
        _count = self.images.count;
        _startImage = startImage;
        _endImage = startImage;
        
        _tempImageView = [[UIImageView alloc] initWithImage:startImage];
        _tempImageView.userInteractionEnabled = YES;

        
        _tapOnStart = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(startTapped:)];
        [_tempImageView addGestureRecognizer:_tapOnStart];
        [self addSubview:_tempImageView];
    }
    return self;
}

- (void)commonSetup
{
    self.items = [NSMutableArray array];
    self.positions = [NSMutableArray array];
    self.snaps = [NSMutableArray array];

    // setup the items
    for (int i = 0; i < self.count; i++) {
        UIImageView *item = [[UIImageView alloc] initWithImage:self.images[i]];
        item.frame = CGRectMake(0, 0, 35, 35);
        item.tag = kItemInitTag + i;
        item.userInteractionEnabled = YES;
        [self.superview addSubview:item];
        
        CGPoint position = [self centerForSphereAtIndex2:i];
        item.center = self.center;
        [self.positions addObject:[NSValue valueWithCGPoint:position]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [item addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [item addGestureRecognizer:pan];
        
        [self.items addObject:item];
    }
    
    [self.superview bringSubviewToFront:self];
    
    // setup animator and behavior
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    
    self.collision = [[UICollisionBehavior alloc] initWithItems:self.items];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.collision.collisionDelegate = self;
    
    for (int i = 0; i < self.count; i++) {
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[i] snapToPoint:self.center];
        snap.damping = self.sphereDamping;
        [self.snaps addObject:snap];
    }
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.items];
    self.itemBehavior.allowsRotation = NO;
    self.itemBehavior.elasticity = 1.2;
    self.itemBehavior.density = 0.5;
    self.itemBehavior.angularResistance = 5;
    self.itemBehavior.resistance = 10;
    self.itemBehavior.elasticity = 0.8;
    self.itemBehavior.friction = 0.5;
}

- (void)didMoveToSuperview
{
    [self commonSetup];
}

- (void)removeFromSuperview
{
    for (int i = 0; i < self.count; i++) {
        [self.items[i] removeFromSuperview];
    }
    
    [super removeFromSuperview];
}


//扇形模式
- (CGPoint)centerForSphereAtIndex:(int)index
{
    CGFloat firstAngle = M_PI + (M_PI_2 - self.angle) + (index) * self.angle;
    CGPoint startPoint = self.center;
    CGFloat x = startPoint.x + cos(firstAngle) * self.sphereLength;
    CGFloat y = startPoint.y + sin(firstAngle) * self.sphereLength;
    CGPoint position = CGPointMake(x, y);
    return position;
}

//平行模式
- (CGPoint)centerForSphereAtIndex2:(int)index
{
    NSUInteger count = self.count;
//    int length = self.sphereLength;
    CGPoint startPoint = self.center;
    int indexCount = 0;
    int haveHalf = -1;
    if(count % 2 == 0 ){
        indexCount++;
        //双数
        if(index >= count/2)
        {
            haveHalf = 1;
            indexCount = 1;
        }
        CGFloat x = startPoint.x + (haveHalf * self.sphereLength * indexCount);
        CGFloat y = startPoint.y - self.sphereLength;
        return CGPointMake(x, y);
    }else{
        //单数
        if(index == 0)
        {
            CGFloat x = startPoint.x;
            CGFloat y = startPoint.y + 100;
            return CGPointMake(x, y);
        }
        else
        {
            if(index > count/2)
            {
                haveHalf = 1;
            }
            CGFloat x = startPoint.x + (haveHalf * self.sphereLength * (index + 1));
            CGFloat y = startPoint.y + 100;
            return CGPointMake(x, y);
        }
        
    }
    
//    CGFloat x = startPoint.x + cos(firstAngle) * self.sphereLength;
//    CGFloat y = startPoint.y + sin(firstAngle) * self.sphereLength;
//    CGPoint position = CGPointMake(x, y);
//    return position;
}

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(sphereDidSelected:)]) {
        int tag = (int)gesture.view.tag;
        tag -= kItemInitTag;
        [self.delegate sphereDidSelected:tag];
    }
    
    [self shrinkSubmenu];
}

- (void)startTapped:(UITapGestureRecognizer *)gesture
{
    
    
    [self.animator removeBehavior:self.collision];
    [self.animator removeBehavior:self.itemBehavior];
    [self removeSnapBehaviors];
    
    if (self.expanded) {
        self.tempImageView.image = _startImage;
        CGRect cg = CGRectMake(gesture.view.frame.origin.x, gesture.view.frame.origin.y, 35, 35);
        [self changeSizeWithCg:cg];
        [self shrinkSubmenu];
    } else {
        self.tempImageView.image = _endImage;
        CGRect cg = CGRectMake(self.tempImageView.frame.origin.x, self.tempImageView.frame.origin.y, 70, 70);
        [self changeSizeWithCg:cg];
        [self expandSubmenu];
    }
}

-(void)changeSizeWithCg:(CGRect)cgrect{
    for (int i =0 ; i< self.count;i++){
        UIImageView *imageView = (UIImageView *)[self.superview viewWithTag:kItemInitTag+i];
        imageView.frame = cgrect;
    }
}

- (void)expandSubmenu
{
    for (int i = 0; i < self.count; i++) {
        [self snapToPostionsWithIndex:i];
    }
    
    self.expanded = YES;
}

- (void)shrinkSubmenu
{
    [self.animator removeBehavior:self.collision];
    
    for (int i = 0; i < self.count; i++) {
        [self snapToStartWithIndex:i];
    }
    
    self.expanded = NO;
}

- (void)panned:(UIPanGestureRecognizer *)gesture
{
    UIView *touchedView = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.animator removeBehavior:self.itemBehavior];
        [self.animator removeBehavior:self.collision];
        [self removeSnapBehaviors];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        touchedView.center = [gesture locationInView:self.superview];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.bumper = touchedView;
        [self.animator addBehavior:self.collision];
        NSUInteger index = [self.items indexOfObject:touchedView];
        
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
    [self.animator addBehavior:self.itemBehavior];
    
    if (item1 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item1];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
    
    if (item2 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item2];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

- (void)snapToStartWithIndex:(NSUInteger)index
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:self.center];
    snap.damping = self.sphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

- (void)snapToPostionsWithIndex:(NSUInteger)index
{
    id positionValue = self.positions[index];
    CGPoint position = [positionValue CGPointValue];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:position];
    snap.damping = self.sphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

- (void)removeSnapBehaviors
{
    [self.snaps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.animator removeBehavior:obj];
    }];
}

@end
