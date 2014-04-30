//
//  TweetView.h
//  ChangTalk
//
//  Created by ctkj on 14-4-14.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"
#import "TweetItem.h"

@interface TweetView : UIView<RCLabelDelegate,UIGestureRecognizerDelegate>
{
    RCLabel* _tweetLabel;
    UIImageView* _tweetThumb;
    TweetView* _retweetedView;       //转发的微博视图
    UIImageView* _repostBackView;    //转发背景图
    NSMutableString * _parseText;    //转换成链接的文本
}

@property (nonatomic, assign) BOOL isRetweeted;
@property (nonatomic, strong) TweetItem* tweetItem;

+ (CGFloat)getTweetViewHeight:(TweetItem *)item
                     isRepost:(BOOL)isRepost;
@end
