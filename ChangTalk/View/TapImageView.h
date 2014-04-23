//
//  BaseImageView.h
//  WeiboDemo1
//
//  Created by leo.zhu on 14-1-22.
//  Copyright (c) 2014年 3k. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ImageViewOnTap) (void);  //返回类型void,  参数列表(void)

@interface TapImageView : UIImageView

@property (nonatomic, copy) ImageViewOnTap tapBlock;

@end
