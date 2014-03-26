//
//  NewsTableViewCell.m
//  ChangTalk
//
//  Created by ctkj on 14-3-26.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _newsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 64, 54)];
        _newsImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_newsImageView];
        
        _newsTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 2, 200, 32)];
        _newsTitleLabel.font = [UIFont systemFontOfSize:24];
        _newsTitleLabel.textColor = [UIColor greenColor];
        [self.contentView addSubview:_newsTitleLabel];
        
        _newsCommentNum = [[UILabel alloc]initWithFrame:CGRectMake(600, 40, 200, 12)];
        _newsCommentNum.textColor = [UIColor greenColor];
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

- (void)configNewsCellWithContent
{
    _newsImageView.image = [UIImage imageNamed:@"Default.png"];
    _newsTitleLabel.text = @"新闻标题";
    _newsCommentNum.text = @"100";
}
@end
