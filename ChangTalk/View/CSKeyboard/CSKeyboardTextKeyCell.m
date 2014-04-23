//
//  WPEmoticonsKeyboardTextKeyCell.m
//  ChangShuo
//
//  Created by ctkj on 14-4-14.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSKeyboardTextKeyCell.h"

@implementation CSKeyboardTextKeyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyButton.bounds = self.bounds;
        self.keyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.keyButton setTitleColor:[UIColor colorWithWhite:41/255.0 alpha:1] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.backgroundColor = nil;
    }
}

@end
