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

#define CELL_INFO_IMG_BTN_TAG 10000
#define CELL_RES_IMG_BTN_TAG  2000000
#define TWITTER_FONTSIZE_NAME  15

#define TWITTER_LEFTWIDTH 62
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
    self.avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 4, 36, 36)];
    //self.avatarView.image = [UIImage imageNamed:@"default_avatar@2x.png"];
    self.avatarView.layer.cornerRadius = 18.0f;
    self.avatarView.clipsToBounds = YES;
    self.avatarView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
    [self.avatarView addGestureRecognizer:tapAvatar];
    [self.contentView addSubview:self.avatarView];

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TWITTER_LEFTWIDTH, 4, 200, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [self.contentView  addSubview:_nameLabel];

    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 4, 100, 20)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = TWITTER_TEXTCOLOR_TIME;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    [self  addSubview:_timeLabel];
    
    _tweetView = [[TweetView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_tweetView];
    
}

- (void)tapAvatar:(UIGestureRecognizer*)gestureRecognizer
{
    debugLog(@"gesture");
    
    CSProfileViewController* viewController = [[CSProfileViewController alloc] init];
    //viewController.alloc
    //以下通过UIView响应者链获取所在链中的UIViewController
    [self.viewController.navigationController pushViewController:viewController animated:YES];
}

//设置内容
- (void)configTweetCellContent:(NSDictionary*)dict
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
    
    _tweetView.frame = CGRectMake(50, _nameLabel.frame.origin.y+_nameLabel.frame.size.height, 320, h);
    
    //让_tweetView重新布局，5.1版本错乱
    [_tweetView setNeedsLayout];
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
