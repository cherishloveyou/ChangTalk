//
//  CSHeadCoverView.h
//  ChangTalk
//
//  Created by ctkj on 14-3-31.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSHeadCoverView : UIView

@property (nonatomic, strong) UIView *bannerView;

@property (nonatomic, strong) UIView *showView;

@property (nonatomic, assign) CGFloat showUserInfoViewOffsetHeight;

// parallax background
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, strong) UIImageView *headImageView;
// user info
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *userNameLabel;

//scrollView call back
@property (nonatomic) BOOL touching;
@property (nonatomic) CGFloat offsetY;

// parallax background origin Y for parallaxHeight
@property (nonatomic, assign) CGFloat parallaxHeight; // default is 170， this height was not self heigth.

@property (nonatomic, assign) BOOL isZoomingEffect; // default is NO， if isZoomingEffect is YES, will be dissmiss parallax effect
@property (nonatomic, assign) BOOL isLightEffect; // default is YES
@property (nonatomic, assign) CGFloat lightEffectPadding; // default is 80
@property (nonatomic, assign) CGFloat lightEffectAlpha; // default is 1.12 (between 1 - 2)

@property (nonatomic, copy) void(^handleRefreshEvent)(void);


// background image
- (void)setBackgroundImage:(UIImage *)backgroundImage;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
