//
//  PhotoBrowseView.m
//  ChangShuo
//
//  Created by ctkj on 14-4-14.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "PhotoBrowseView.h"
#import "UIScrollView+ZoomToPoint.h"
#import "UIImageView+WebCache.h"

#define PROGRESS_VIEW_WIDTH 60.f
#define BUTTON_SIDE_MARGIN 20.f
#define PREVIEW_ANIMATION_DURATION 0.3f

@interface PhotoBrowseView ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGRect fromRect;
//@property (nonatomic, strong) MBRoundProgressView* progressIndicator;
@property (nonatomic, strong) UIButton* saveBtn;
@property (nonatomic, assign) BOOL isOriginPhotoLoaded;
@end

@implementation PhotoBrowseView

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UI

- (id)initWithUrlPath:(NSString *)urlPath thumbnail:(UIImage*)thumbnail fromRect:(CGRect)rect
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if (self) {
        
        self.fromRect = rect;
        self.thumbnail = thumbnail;
        self.urlPath = urlPath;
        [self initAllViews];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(removeFromSuperviewAnimation)];
        [self addGestureRecognizer:singleTap];
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(scaleImageView:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        // enable double tap
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        self.imageView.image = self.thumbnail;
        self.isOriginPhotoLoaded = NO;
        self.saveBtn.enabled = NO;
        [self showImageViewAnimation];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////
- (void)initAllViews
{
    self.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.zoomScale = 1.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0f;
    _scrollView.backgroundColor = [UIColor redColor];
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView  alloc] initWithFrame:_scrollView.bounds];
    _imageView.backgroundColor = [UIColor greenColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_imageView];
    
    //_progressIndicator = [[MBRoundProgressView alloc] initWithFrame:CGRectMake(0.f, 0.f,PROGRESS_VIEW_WIDTH,PROGRESS_VIEW_WIDTH)];
    //_progressIndicator.backgroundTintColor = RGBACOLOR(0.f, 0.f, 0.f, 0.6f);
    
    //UIImage* backgroundImage = [UIImage nimbusImageNamed:@"preview_button.png"];
    //UIImage* saveImage = [UIImage nimbusImageNamed:@"preview_save_icon.png"];
    //_saveBtn = [[UIButton alloc] initWithFrame:
    //            CGRectMake(0.f, 0.f, backgroundImage.size.width, backgroundImage.size.height)];
    //[_saveBtn setImage:saveImage forState:UIControlStateNormal];
    //[_saveBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    //[_saveBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:_saveBtn];
    
    //self.progressIndicator.center = CGPointMake(self.size.width / 2, self.size.height / 2);
    //self.saveBtn.left = BUTTON_SIDE_MARGIN;
    //self.saveBtn.bottom = self.height - BUTTON_SIDE_MARGIN;
}

////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (NSString*)getOrignImagePath:(NSString*)path
{
    //\d+,([^,|]+),\d+/g
    debugLog(@"string:%@",path);
    NSArray *result = [path componentsSeparatedByString:@","];
    
    NSString* url = [result[1] stringByReplacingOccurrencesOfString:@"thumb." withString:@""];
    
    return kAPI_GetInfoPic(url);
}

////////////////////////////////////////////////////////////////////////////////////
- (void)showImageViewAnimation
{
    self.imageView.frame = self.fromRect;
    
    if (self.thumbnail) {
        self.alpha = 0.f;
        
        // calculate scaled frame
        CGRect finalFrame = [self calculateScaledFinalFrame];
        if (finalFrame.size.height > self.frame.size.height) {
            self.scrollView.contentSize = CGSizeMake(self.frame.size.width, finalFrame.size.height);
        }
        // animation frame
        [UIView animateWithDuration:PREVIEW_ANIMATION_DURATION animations:^{
            self.imageView.frame = finalFrame;
            self.alpha = 1.f;
        } completion:^(BOOL finished) {
            if (self.urlPath) {
                NSString* path = [self getOrignImagePath:self.urlPath];
               [_imageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:self.thumbnail];
            }
        }];
    }
    else {
        self.imageView.frame = self.bounds;
        self.alpha = 0.f;
        
        // animation frame
        [UIView animateWithDuration:PREVIEW_ANIMATION_DURATION animations:^{
            self.alpha = 1.f;
        } completion:^(BOOL finished) {
            if (self.urlPath) {
                //[self.imageView setPathToNetworkImage:self.urlPath contentMode:UIViewContentModeScaleAspectFit];
            }
        }];
    }
}

///////////////////////////////////////////////////////////////////////////
- (void)removeFromSuperviewAnimation
{
    // consider scroll offset
    CGRect newFromRect = self.fromRect;
    newFromRect.origin = CGPointMake(self.fromRect.origin.x + self.scrollView.contentOffset.x,
                                     self.fromRect.origin.y + self.scrollView.contentOffset.y);
    [UIView animateWithDuration:PREVIEW_ANIMATION_DURATION animations:^{
        self.imageView.frame = newFromRect;
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/////////////////////////////////////////////////////////////////////////////
- (void)scaleImageView:(UITapGestureRecognizer*)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:self.scrollView];
    if (self.scrollView.zoomScale > 1.f) {
        //[self.scrollView setZoomScale:1.f animated:YES];
        [self.scrollView zoomToPoint:tapPoint withScale:1.f animated:YES];
    }
    else {
        //[self.scrollView setZoomScale:2.f animated:YES];
        [self.scrollView zoomToPoint:tapPoint withScale:2.f animated:YES];
    }
}

////////////////////////////////////////////////////////////////////////////
- (void)savePhoto
{
	if (self.isOriginPhotoLoaded && self.imageView.image) {
//        __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//        hud.labelText = @"保存中...";
        self.saveBtn.enabled = NO;
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
	}
    else {
//        [SMGlobalConfig showHUDMessage:@"图片未下载完成，无法保存" addedToView:self];
    }
}

/////////////////////////////////////////////////////////////////////////////
- (CGRect)calculateScaledFinalFrame
{
    CGSize thumbSize = self.thumbnail.size;
    CGFloat finalHeight = self.frame.size.width * (thumbSize.height / thumbSize.width);
    CGFloat top = 0.f;
    if (finalHeight < self.frame.size.height) {
        top = (self.frame.size.height - finalHeight) / 2.f;
    }
    return CGRectMake(0.f, top, self.frame.size.width, finalHeight);
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark - SavedPhotosAlbum CallBack

/////////////////////////////////////////////////////////////////////////////
- (void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        //[SMGlobalConfig showHUDMessage:@"保存失败" addedToView:self];
    }
    else {
//        [MBProgressHUD hideHUDForView:self animated:YES];
//        
//        __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//        hud.customView = [[UIImageView alloc] initWithImage:[UIImage nimbusImageNamed:@"37x-Checkmark.png"]];
//        hud.mode = MBProgressHUDModeCustomView;
//        hud.labelText = @"保存成功";
//        [hud hide:YES afterDelay:1.5f];
        
        self.saveBtn.enabled = YES;
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrolViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

/////////////////////////////////////////////////////////////////////////
// code from so:
// http://stackoverflow.com/questions/1316451/center-content-of-uiscrollview-when-smaller
-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5f : 0.f;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5f : 0.f;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5f + offsetX,
                                 scrollView.contentSize.height * 0.5f + offsetY);
}

/////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NINetworkImageViewDelegate

//- (void)networkImageViewDidStartLoad:(NINetworkImageView *)imageView
//{
//    [self addSubview:self.progressIndicator];
//}

////////////////////////////////////////////////////////////////////////////////////////////
//- (void)networkImageView:(NINetworkImageView *)imageView didLoadImage:(UIImage *)image
//{
//    [self.progressIndicator removeFromSuperview];
//    self.isOriginPhotoLoaded = YES;
//    self.saveBtn.enabled = YES;
//}

////////////////////////////////////////////////////////////////////////////////////////////
//- (void)networkImageView:(NINetworkImageView *)imageView didFailWithError:(NSError *)error
//{
//    [SMGlobalConfig showHUDMessage:@"原始大图加载失败！" addedToView:self];
//}

////////////////////////////////////////////////////////////////////////////////////////////
//- (void)networkImageView:(NINetworkImageView *)imageView readBytes:(long long)readBytes totalBytes:(long long)totalBytes
//{
//    CGFloat progress = (float)readBytes / (float)totalBytes;
//    self.progressIndicator.progress = progress;
//}

@end
