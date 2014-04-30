//
//  MessageTableViewCell.m
//  ChangTalk
//
//  Created by ctkj on 14-3-31.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HtmlString.h"
#import "CSProfileViewController.h"
#import "AppDelegate.h"

//#define CELL_INFO_IMG_BTN_TAG 10000
//#define CELL_RES_IMG_BTN_TAG  2000000
//#define TWITTER_FONTSIZE_NAME  15
#define TWITTER_LEFTMARGIN  60
#define TWITTER_LEFTWIDTH 65
#define MAX_TEXT_LENGTH 140
#define TWITTER_FONTSIZE_INFO 15
#define TWITTER_FONTSIZE_TITLE 16
#define TWITTER_FONTSIZE_NAME 15
#define TWITTER_FONTSIZE_TIME 12
#define TWITTER_TEXTCOLOR_INFO [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]
#define TWITTER_TEXTCOLOR_TIME [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0]
#define SELECTED_COLOR [UIColor colorWithRed:27.0/255 green:116.0/255 blue:174.0/255 alpha:1.0f]//信息流tap切换选中的文字颜色


@implementation TweetTableViewCell

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

//
- (void)initCellView
{
    _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 40, 40)];
    _avatarView.layer.cornerRadius = CGRectGetWidth(_avatarView.frame)/2.0f;
    _avatarView.clipsToBounds = YES;
    _avatarView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
    [_avatarView addGestureRecognizer:tapAvatar];
    [self.contentView addSubview:_avatarView];

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TWITTER_LEFTMARGIN, 10, 200, 16)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView  addSubview:_nameLabel];

    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 100, 16)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.contentView addSubview:_timeLabel];
    
    _tweetView = [[TweetView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_tweetView];
    
    _sourceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:9.0f];
    _sourceLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_sourceLabel];
    
    _likeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _likeLabel.font = [UIFont systemFontOfSize:9.0f];
    _likeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_likeLabel];
    
    _commentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _commentLabel.font = [UIFont systemFontOfSize:9.0f];
    _commentLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_commentLabel];
    
    [self addBtnWithTitle:@"评论" iconNomal:@"icon_tweet_comment.png" iconHighlightedi:@"icon_tweet_comment_h.png" iconSelect:nil  index:1 addTarget:self action:@selector(clickBtnComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addBtnWithTitle:@"赞" iconNomal:@"icon_tweet_like.png" iconHighlightedi:@"icon_tweet_like_h.png" iconSelect:nil  index:2 addTarget:self action:@selector(clickBtnLike:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapAvatar:(UIGestureRecognizer*)gestureRecognizer
{
    debugLog(@"gesture click avatar");
    
    CSProfileViewController* profileController = [[CSProfileViewController alloc] init];
    profileController.userName = _tweetItem.authorName;
    //viewController.alloc
    //以下通过UIView响应者链获取所在链中的UIViewController
    //UINavigationController* chouti= [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:profileController ];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [delegate.commonNavController pushViewController:profileController animated:YES];
    
    //[self.viewController.navigationController pushViewController:viewController animated:YES];
}

- (void)addBtnWithTitle:(NSString *)titlie iconNomal:(NSString *)iconNomal iconHighlightedi:(NSString *)Highlighted iconSelect:(NSString *)select index:(int)index addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)event
{
    CGSize  size = self.frame.size;
    CGFloat btnWidth = size.width / 3;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:iconNomal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:select] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:select] forState:UIControlStateSelected];
    [btn setTitle:titlie forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [ UIFont systemFontOfSize:10];
    btn.frame = CGRectMake(index * btnWidth, 0, btnWidth, size.height);
    // 设置标题的间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 0, 0);
    btn.tag = 1000 + index; // 设置tag值
    [btn addTarget:target action:action forControlEvents:event];
    [self.contentView addSubview:btn];
}

- (void)clickBtnLike:(id)sender
{
    
}

- (void)clickBtnComment:(id)sender
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_avatarView setImageWithURL:[NSURL URLWithString:kAPI_GetUserHeadPic(_tweetItem.authorID)] placeholderImage:nil];
    
    _nameLabel.text = _tweetItem.authorName;
    _timeLabel.text = [self intervalSinceNow:_tweetItem.publishTime];
    
    //[NSString stringWithFormat:@"%f",_tweetItem.publishTime];
    
    //微博视图_weiboView
    _tweetView.tweetItem = _tweetItem;
    //获取微博视图的高度
    float h = [TweetView getTweetViewHeight:_tweetItem isRepost:NO];
    
    _tweetView.frame = CGRectMake(TWITTER_LEFTMARGIN-4, _nameLabel.frame.origin.y+_nameLabel.frame.size.height+8, 260, h);
    
    //让_tweetView重新布局，5.1版本错乱
    [_tweetView setNeedsLayout];
    
    _sourceLabel.frame = CGRectMake(TWITTER_LEFTMARGIN, _tweetView.frame.origin.y + _tweetView.frame.size.height, 100, 20);
    _sourceLabel.text = _tweetItem.souceType;
    
}

- (NSString *)intervalSinceNow: (NSTimeInterval)late
{
//    NSDateFormatter *date=[[NSDateFormatter alloc] init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *d=[date dateFromString:theDate];
//    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha = now-late;
    
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/172800<1)//(cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateStyle:NSDateFormatterMediumStyle];
        //[formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM月dd日 HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:late];
        //NSDate *date = [NSDate dateWithTimeIntervalSince1970:[singtime doubleValue]];
        //NSDate* date = [ormatter dateFromString:Datatime];
        timeString = [formatter stringFromDate:date];
        
//        //        timeString = [NSString stringWithFormat:@"%d-%"]
//        NSArray *array = [theDate componentsSeparatedByString:@" "];
//        //        return [array objectAtIndex:0];
//        timeString = [array objectAtIndex:0];
    }
    return timeString;
}

@end
