//
//  CSHomeViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-3-19.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSHomeViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "CSPublishViewController.h"
#import "CSContentViewController.h"

@interface CSHomeViewController ()<SidePushViewControllerDelegate>

@end

@implementation CSHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"108社区";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

    MMDrawerBarButtonItem *button = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(clickMenuView:)];
    self.navigationItem.leftBarButtonItem  = button;
    
//    //开始自定义返回按钮
//    UIButton* listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //listBtn.frame = CGRectMake(0, 0, 44, 44);
//    [listBtn setBackgroundImage:[UIImage imageNamed:@"icon_menu_list@2x.png"] forState:UIControlStateNormal];
//    [listBtn addTarget:self action:@selector(clickMenuView:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:listBtn];
    
    UIButton* eidtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eidtBtn.frame = CGRectMake(0, 0, 44, 44);
    [eidtBtn setBackgroundImage:[UIImage imageNamed:@"icon_menu_edit@2x.png"] forState:UIControlStateNormal];
    [eidtBtn addTarget:self action:@selector(clickEditView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:eidtBtn];
    


    _slideView = [[CSSlideSwitchView alloc]initWithFrame:self.view.bounds];
    
    self.slideView.slideDelegate = self;
    self.slideView.tabItemNormalColor = [CSSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideView.tabItemSelectedColor = [CSSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideView.shadowImage = [[UIImage imageNamed:@"tab_line_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    _newsVC = [[CSNewsViewController alloc]init];
    _newsVC.delegate = self;
    
    _tweetVC = [[CSTweetViewController alloc]init];
    _tweetVC.delegate = self;
    
    [self.view addSubview:self.slideView];
    
    [self.slideView buildUI];
}

- (void)clickMenuView:(id)sender
{
    
}

- (void)clickEditView:(id)sender
{
    CSPublishViewController* postController = [[CSPublishViewController alloc]init];
    CSNavigationController* nav = [[CSNavigationController alloc]initWithRootViewController:postController];
    //[self.navigationController pushViewController:postController animated:YES];
//    CSNavigationController* nav = [[CSNavigationController alloc]initWithRootViewController:[[CSPublishViewController alloc]init]];
    //postController.navigationController.navigationBar.hidden = YES;
    
    [self.view.window.rootViewController presentViewController:nav animated:YES completion:^{
        debugLog(@"edit tweet view!");
    }];
//    [self presentViewController:nav animated:YES completion:^{
//        debugLog(@"edit tweet view!");
//    }];
}

#pragma -mark TopTenTopicsDelegate
- (void)slidePushDetailViewController:(NSInteger)articleID
{
    CSContentViewController *contentVC = [[CSContentViewController alloc]init];
    contentVC.articleID = articleID;
    [self.navigationController pushViewController:contentVC animated:YES];
    contentVC = nil;
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(CSSlideSwitchView *)view
{
    return 2;
}

- (UIViewController *)slideSwitchView:(CSSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.newsVC;
    } else if (number == 1) {
        return self.tweetVC;
    }else{
        return nil;
    }
}

- (void)slideSwitchView:(CSSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
//    SUNViewController *drawerController = (CSSlideSwitchView *)self.navigationController.mm_drawerController;
//    [drawerController panGestureCallback:panParam];
}

- (void)slideSwitchView:(CSSlideSwitchView *)view didselectTab:(NSUInteger)number
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
