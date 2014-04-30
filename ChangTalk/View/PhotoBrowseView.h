//
//  PhotoBrowseView.h
//  ChangShuo
//
//  Created by ctkj on 14-4-14.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

@interface PhotoBrowseView : UIView

@property (nonatomic, copy) NSString* urlPath;
@property (nonatomic, strong) UIImage* thumbnail;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIImageView* imageView;

- (id)initWithUrlPath:(NSString *)urlPath thumbnail:(UIImage*)thumbnail fromRect:(CGRect)rect;

@end
