//
//  CSHeadCoverView.m
//  ChangTalk
//
//  Created by ctkj on 14-3-31.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSHeadCoverView.h"
#import "UIImage+BlurEffects.h"

#define kCoverViewHeight    170

@implementation CSHeadCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.parallaxHeight = 120;
    self.isLightEffect = YES;
    self.lightEffectPadding = 80;
    self.lightEffectAlpha = 1.15;

    _bannerView = [[UIView alloc] initWithFrame:self.bounds];
    _bannerView.clipsToBounds = YES;
    
    _bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -self.parallaxHeight, CGRectGetWidth(_bannerView.frame), CGRectGetHeight(_bannerView.frame) + self.parallaxHeight * 2)];
    _bannerImageView.contentMode = UIViewContentModeScaleToFill;
    [_bannerView addSubview:self.bannerImageView];
    
    _blurImageView = [[UIImageView alloc] initWithFrame:_bannerImageView.frame];
    _blurImageView.alpha = 0.;
    [_bannerView addSubview:self.blurImageView];
    
    [self addSubview:self.bannerView];
    
    
    _headImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _headImageView.image = [UIImage imageNamed:@"userHead.jpg"];
    _headImageView.backgroundColor = [UIColor redColor];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 40.0f;
    _headImageView.layer.borderWidth = 2.0f;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    //imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _headImageView.layer.shouldRasterize = YES;
    _headImageView.clipsToBounds = YES;
    _headImageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, -40);

    
    CGFloat avatarButtonHeight = 66;
    self.showUserInfoViewOffsetHeight = CGRectGetHeight(self.frame) - 30 / 3 - avatarButtonHeight;
    _showView = [[UIView alloc] initWithFrame:CGRectMake(0, self.showUserInfoViewOffsetHeight, CGRectGetWidth(self.bounds),30)];
    _showView.backgroundColor = [UIColor clearColor];
    
    _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, avatarButtonHeight, avatarButtonHeight)];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(93, 0, 207, 34)];
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.shadowColor = [UIColor blackColor];
    _userNameLabel.shadowOffset = CGSizeMake(0, 2);
    _userNameLabel.font = [UIFont boldSystemFontOfSize:28.0f];
    _userNameLabel.text = @"HelloWorld";
    
    [_showView addSubview:self.avatarButton];
    [_showView addSubview:self.userNameLabel];
    [_showView addSubview:self.headImageView];
    _showView.backgroundColor = [UIColor redColor];
    
    [self addSubview:self.showView];
}

// background
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (backgroundImage) {
        _bannerImageView.image = backgroundImage;
        _blurImageView.image = [backgroundImage applyLightEffect];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.touching = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.offsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate == NO) {
        self.touching = NO;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.touching = NO;
}

- (void)setOffsetY:(CGFloat)y {
    CGFloat fixAdaptorPadding = 0;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        fixAdaptorPadding = 64;
    }
    y += fixAdaptorPadding;
    _offsetY = y;
    CGRect frame = _showView.frame;
    if(y < 0) {
            frame.origin.y = self.showUserInfoViewOffsetHeight + y;
            _showView.frame = frame;
    } else {
        if(frame.origin.y != self.showUserInfoViewOffsetHeight) {
            frame.origin.y = self.showUserInfoViewOffsetHeight;
            _showView.frame = frame;
        }
    }
    
    UIView *bannerSuper = _bannerImageView.superview;
    CGRect bframe = bannerSuper.frame;
    if(y < 0) {
        bframe.origin.y = y;
        bframe.size.height = -y + bannerSuper.superview.frame.size.height;
        bannerSuper.frame = bframe;
        
        CGPoint center =  _bannerImageView.center;
        center.y = bannerSuper.frame.size.height / 2;
        _bannerImageView.center = center;
        
        if (self.isZoomingEffect) {
            _bannerImageView.center = center;
            CGFloat scale = fabsf(y) / self.parallaxHeight;
            _bannerImageView.transform = CGAffineTransformMakeScale(1+scale, 1+scale);
        }
    } else {
        if(bframe.origin.y != 0) {
            bframe.origin.y = 0;
            bframe.size.height = bannerSuper.superview.frame.size.height;
            bannerSuper.frame = bframe;
        }
        if(y < bframe.size.height) {
            CGPoint center =  _bannerImageView.center;
            center.y = bannerSuper.frame.size.height/2 + 0.5 * y;
            _bannerImageView.center = center;
        }
    }
    
    if (self.isLightEffect) {
        if(y < 0 && y >= -self.lightEffectPadding) {
            float percent = (-y / (self.lightEffectPadding * self.lightEffectAlpha));
            self.blurImageView.alpha = percent;
            
        } else if (y <= -self.lightEffectPadding) {
            self.blurImageView.alpha = self.lightEffectPadding / (self.lightEffectPadding * self.lightEffectAlpha);
        } else if (y > self.lightEffectPadding) {
            self.blurImageView.alpha = 0;
        }
    }
}

@end
