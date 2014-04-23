//
//  CommentTableViewCell.h
//  ChangTalk
//
//  Created by ctkj on 14-4-9.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView* headView;      //用户头像
@property (nonatomic, strong) UILabel* commentName;       //用户名字
@property (nonatomic, strong) UILabel* commentTime;       //评论时间
@property (nonatomic, strong) UILabel* commentContent;    //评论内容

@property (nonatomic, strong) UIImageView* orginTipView;  //原始提示
@property (nonatomic, strong) UILabel* orginContent;      //原始内容
@property (nonatomic, strong) UILabel* commentType;       //评论标识 ios android 网页
@property (nonatomic, strong) UIImageView* replyView;     //回复评论


//设置内容
- (void)setCommentCellContent:(NSDictionary*)dict;
- (void)setMyCommentCellContent:(NSDictionary*)dict;
//算出其高度
+ (CGFloat)getCellheight:(NSDictionary*)dict;

@end
