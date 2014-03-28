//
//  NewsTableViewCell.m
//  ChangTalk
//
//  Created by ctkj on 14-3-26.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation NewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _newsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 72, 54)];
        _newsImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_newsImageView];
        
        _newsTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 2, 200, 48)];
        _newsTitleLabel.font = [UIFont systemFontOfSize:14];
        _newsTitleLabel.textColor = [UIColor blackColor];
        _newsTitleLabel.numberOfLines = 2;
        [self.contentView addSubview:_newsTitleLabel];
        
        _newsCommentNum = [[UILabel alloc]initWithFrame:CGRectMake(280, 48, 40, 12)];
        _newsCommentNum.font = [UIFont systemFontOfSize:10];
        _newsCommentNum.textAlignment = NSTextAlignmentRight;
        _newsCommentNum.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_newsCommentNum];
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

- (void)startDownloadNewsImage
{
    //if (_newsImageView)
    //    [_avatarImageView setImageWithURL:[NSURL URLWithString:_authorImageURL] placeholderImage:[UIImage imageNamed:@"thumb_avatar.png"]];
    //if (_imageURL)
    //    [_pictureImageView setImageWithURL:[NSURL URLWithString:_imageURL] placeholderImage:[UIImage imageNamed:@"thumb_pic.png"]];
    //[self downloadImageFromURL:[NSURL URLWithString:_imageURL] withPlaceHolderImage:[UIImage imageNamed:@"thumb_pic.png"] ForImageView:_pictureImageView];
}


- (void)configNewsCellWithContent:(NewsItem*)item
{

    _newsTitleLabel.text = item.newsTitle;
    _newsCommentNum.text = [NSString stringWithFormat:@"%d评论",item.commentCount];
    //图片
    if (item.newsImageUrl) {
        [_newsImageView setImageWithURL:[NSURL URLWithString:item.newsImageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
    }
}
@end
