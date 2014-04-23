//
//  BaseImageView.m
//  WeiboDemo1
//
//  Created by leo.zhu on 14-1-22.
//  Copyright (c) 2014年 3k. All rights reserved.
//

#import "TapImageView.h"

@implementation TapImageView

//xib创建本类会调用这个方法
- (void)awakeFromNib {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer*)gesture {
    if (self.tapBlock != nil) {
        NSLog(@"tap block");
        _tapBlock(); //调用block
        //block调用完毕之后,一般需要进行release操作 Block_release(_tapBlock), 但是这里因为要多次调用,因此不能释放;
    }else{
        NSLog(@"block is nil");
    }
}

- (void)dealloc
{
    
}

@end
