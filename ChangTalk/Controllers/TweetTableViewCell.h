//
//  TwitterTableViewCell.h
//  ChangTalk
//
//  Created by ctkj on 14-3-31.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetView.h"


@interface TweetTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;    //头像
@property (nonatomic, strong) UILabel *nameLabel;         //用户昵称
@property (nonatomic, strong) UILabel *timeLabel;         //发布时间

@property (nonatomic, strong) TweetItem *tweetItem;
@property (nonatomic, strong) TweetView *tweetView;

@property (nonatomic, strong) UILabel *sourceLabel;       //来源日期
@property (nonatomic, strong) UILabel *commentLabel;      //评论
@property (nonatomic, strong) UILabel *likeLabel;         //点赞数

@end
