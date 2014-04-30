//
//  MenuCategoryCell.m
//  ChangTalk
//
//  Created by ctkj on 14-4-25.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "MenuCategoryCell.h"

@implementation MenuCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _categoryThumb = [[UIImageView alloc]initWithFrame:CGRectMake(16, 18, 24, 24)];
        //_categoryThumb.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_categoryThumb];
        
        _categoryName = [[UILabel alloc]initWithFrame:CGRectMake(54, 22, 64, 20)];
        _categoryName.font = [UIFont systemFontOfSize:18.0f];
        //_categoryName.backgroundColor = [UIColor yellowColor];
        _categoryName.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f];
        _categoryName.highlightedTextColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_categoryName];
        
        UIView* view = [[UIView alloc]initWithFrame:self.frame];
        view.backgroundColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
        self.selectedBackgroundView = view;

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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];

    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}
@end
