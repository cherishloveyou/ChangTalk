//
//  CSKeyboardPressedCellPopupView.m
//  ChangShuo
//
//  Created by ctkj on 14-4-14.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSKeyboardPressedCellPopupView.h"

@interface CSKeyboardPressedCellPopupView ()
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UILabel  *textLabel;
@end

@implementation CSKeyboardPressedCellPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *popupBackground = [UIImage imageNamed:@"keyboard_popup"];
        UIImageView *popupBackgroundView = [[UIImageView alloc] initWithImage:popupBackground];
        [self addSubview:popupBackgroundView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        self.imageView = imageView;

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:11];
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(25, 9, 32, 32);
    self.textLabel.frame = CGRectMake(10, 41, 63, 18);
}

- (void)setKeyItem:(WUEmoticonsKeyboardKeyItem *)keyItem {
    _keyItem = keyItem;
    self.textLabel.text = keyItem.textToInput;
    self.imageView.image = keyItem.image;
}

@end
