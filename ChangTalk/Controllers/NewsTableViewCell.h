//
//  NewsTableViewCell.h
//  ChangTalk
//
//  Created by ctkj on 14-3-26.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *newsImageView;
@property (nonatomic, strong)UILabel *newsTitleLabel;
@property (nonatomic, strong)UILabel *newsCommentNum;

- (void)configNewsCellWithContent;

@end
