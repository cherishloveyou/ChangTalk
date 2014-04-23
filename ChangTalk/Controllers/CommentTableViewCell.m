//
//  CommentTableViewCell.m
//  ChangTalk
//
//  Created by ctkj on 14-4-9.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initCellView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCellView
{
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 24, 24)];
    _headView.layer.cornerRadius = 12.0f;
    _headView.clipsToBounds = YES;
    
    [self.contentView addSubview:_headView];
    
    _commentName = [[UILabel alloc]initWithFrame:CGRectMake(30, 2, 100, 16)];
    _commentName.font = [UIFont boldSystemFontOfSize:12.0f];
    [self.contentView addSubview:_commentName];
    
    _commentTime = [[UILabel alloc]initWithFrame:CGRectMake(240, 2, 72, 16)];
    _commentTime.font = [UIFont systemFontOfSize:10.0f];
    _commentTime.textColor = [UIColor grayColor];
    _commentTime.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_commentTime];
    
    _commentContent = [[UILabel alloc]initWithFrame:CGRectMake(30, 40, 250, 16)];
    _commentContent.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_commentContent];
    
    _orginTipView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.contentView addSubview:_orginTipView];
    
    _orginContent = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, 250, 12)];
    _orginContent.font = [UIFont systemFontOfSize:10.0f];
    _orginContent.textColor = [UIColor grayColor];
    [self.contentView addSubview:_orginContent];
    
    _commentType = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, 250, 16)];
    _commentType.font = [UIFont systemFontOfSize:8.0f];
    _commentType.textColor = [UIColor grayColor];
    [self.contentView addSubview:_commentType];
    
    _replyView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.contentView addSubview:_replyView];
}

- (void)setMyCommentCellContent:(NSMutableDictionary*)dict
{
    int cellHeight = 20;
    
    NSString* commentStr = [dict objectForKey:@"CommentContent"];
    
    NSString* orginStr = ([[[dict objectForKey:@"ComTopicInfo"]objectForKey:@"DelStatus"]integerValue]==1)?@"原信息被删除":[NSString stringWithFormat:@"@%@:%@",[dict objectForKey:@"TopicUserName"],[[dict objectForKey:@"ComTopicInfo"]objectForKey:@"InfoMemo"]];
    
    [_headView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"UserHeadUrl"]] placeholderImage:nil];
    
    _commentName.text = [dict objectForKey:@"UserName"];
    _commentTime.text = [dict objectForKey:@"CreateTime"];
    

    CGSize commentSize = [commentStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 20) lineBreakMode:NSLineBreakByCharWrapping];
    _commentContent.frame = CGRectMake(30, cellHeight, commentSize.width, 20);
    _commentContent.text = commentStr;
    cellHeight += 24;
    
    CGSize orginSize = [orginStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 16) lineBreakMode:NSLineBreakByCharWrapping];
    _orginContent.frame = CGRectMake(30, cellHeight, orginSize.width, 20);
    _orginContent.text = orginStr;
    
    _commentType.text = [dict objectForKey:@"Source"];
}

- (void)setCommentCellContent:(NSDictionary*)dict
{
    int cellHeight = 20;
    
    NSString* commentStr = [dict objectForKey:@"CommentContent"];
    
    NSString* orginStr = nil;
    
    if (![[dict objectForKey:@"PreCommentInfo"] isEqual:[NSNull null]])
    {
        NSDictionary *item = [dict objectForKey:@"PreCommentInfo"];

        orginStr = [NSString stringWithFormat:@"@%@:%@",[item objectForKey:@"UserName"],[item objectForKey:@"CommentContent"]];
    }
    
    [_headView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"UserHeadUrl"]] placeholderImage:nil];
    
    _commentName.text = [dict objectForKey:@"UserName"];
    _commentTime.text = [dict objectForKey:@"CreateTime"];
    
    
    CGSize commentSize = [commentStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 20) lineBreakMode:NSLineBreakByCharWrapping];
    _commentContent.frame = CGRectMake(30, cellHeight, commentSize.width, 20);
    _commentContent.text = commentStr;
    cellHeight += 24;
    
    CGSize orginSize = [orginStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 16) lineBreakMode:NSLineBreakByCharWrapping];
    _orginContent.frame = CGRectMake(30, cellHeight, orginSize.width, 20);
    _orginContent.text = orginStr;
    
    _commentType.text = [dict objectForKey:@"Source"];
}

+ (CGFloat)getCellheight:(NSDictionary*)dict
{
    return 80;
}
    
@end
