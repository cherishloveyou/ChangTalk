//
//  NewFeatherViewController.m
//  WeiBo
//
//  Created by ctkj on 3/22/14.
//  Copyright (c) 2014 ctkj All rights reserved.
//

#define kCount 4
#import "CSIntrosViewController.h"

@interface CSIntrosViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain) UIPageControl *pageControl;

@end

@implementation CSIntrosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 自定义孔子器
- (void)loadView
{
    [super loadView];
    
    UIImageView* bgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.image = [UIImage imageNamed:@"new_feature_background.png"];
    bgView.userInteractionEnabled = YES;
    self.view = bgView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIScrollView *scrollerView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    //    self.scrollerView.userInteractionEnabled = YES;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.pagingEnabled = YES;
    scrollerView.contentSize = CGSizeMake(kCount *scrollerView.bounds.size.width, 0);
    scrollerView.delegate = self;
    // 添加图片
    for (int i = 0 ; i<kCount; i++) {
        [self addImageViewAtIndex:i  inView:scrollerView];
    }
      [self.view addSubview:scrollerView];
    // UIPageController
    //    CGRect pageFarme = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    UIPageControl *page = [[UIPageControl alloc]init];
    page.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height*0.95);
    page.bounds = CGRectMake(0, 0, 100, 36);
    page.numberOfPages = kCount;
    page.userInteractionEnabled = NO;
    page.pageIndicatorTintColor = [UIColor darkGrayColor];
    page.currentPageIndicatorTintColor = [UIColor greenColor];
    self.pageControl = page;
    [self.view addSubview:self.pageControl];
}

-(void)addImageViewAtIndex:(int)index inView:(UIView *)view
{
    CGSize viewSize = view.frame.size;
    
    // 创建imageView
    UIImageView  *imgView = [[UIImageView alloc] init];
    // 在这儿错过 忘了设置宽度了
    imgView.frame = CGRectMake(index*viewSize.width, 0, viewSize.width, viewSize.height);
    // 设置推按
    NSString *name = [NSString stringWithFormat:@"new_feature_%d.png",index + 1];
    imgView.image = [UIImage imageNamed:name];
    
    // 添加视图
    [view addSubview:imgView];
    
    // 如果是最后一张 添加按钮 分享、开始
    if (index == kCount - 1) {
        [self addBtnInView:imgView];
    }
}

#pragma mark -- 添加按钮 分享、开始
-(void)addBtnInView:(UIView *)view
{
    // 开始按钮
    view.userInteractionEnabled = YES;
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:start];
    // 正常图片
    UIImage *startNormal = [UIImage imageNamed:@"new_feature_finish_button"];
    UIImage *startHighted = [UIImage imageNamed:@"new_feature_finish_button_highlighted"];
    [start setBackgroundImage:startNormal forState:UIControlStateNormal];
    [start setBackgroundImage:startHighted forState:UIControlStateHighlighted];
    [start addTarget:self action:@selector(clickStartApp:) forControlEvents:UIControlEventTouchUpInside];
    // 设置变宽
    start.center = CGPointMake(view.bounds.size.width* 0.5, view.bounds.size.height * 0.85);
    start.bounds = (CGRect){CGPointZero,startNormal.size};
}

#pragma mark -- 开始按钮
- (void)clickStartApp:(id)sender
{
    if (_startBlock) {
        _startBlock();
    }
}

#pragma mark -- 滚动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //实现pageControl换位
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end















