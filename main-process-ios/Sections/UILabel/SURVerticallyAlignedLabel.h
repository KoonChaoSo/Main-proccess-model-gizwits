//
//  GIZVerticallyAlignedLabel.h
//  GizOpenAppV2-HeatingApparatus
//
//  Created by ChaoSo on 15/8/4.
//  Copyright (c) 2015年 ChaoSo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} SURVerticalAlignment;

@interface SURVerticallyAlignedLabel : UILabel {
@private
    SURVerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) SURVerticalAlignment verticalAlignment;
- (id)initWithFrame:(CGRect)frame;
- (void)setVerticalAlignment:(SURVerticalAlignment)verticalAlignment;
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines;
@end
