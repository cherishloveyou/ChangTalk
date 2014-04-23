//
//  CSHomeViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-3-19.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSHomeViewController.h"
#import "CSPublishViewController.h"

@interface CSHomeViewController ()

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickEditView:)];

    _slideView = [[CSSlideSwitchView alloc]initWithFrame:self.view.bounds];
    
    self.slideView.slideDelegate = self;
    self.slideView.tabItemNormalColor = [CSSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideView.tabItemSelectedColor = [CSSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideView.shadowImage = [[UIImage imageNamed:@"tab_line_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    self.vc1 = [[CSNewsViewController alloc]init];
    //self.vc2 = [[CSListViewController alloc]init];
    self.vc2 = [[CSTweetViewController alloc]init];
    
    [self.view addSubview:self.slideView];
    
    [self.slideView buildUI];
}

- (void)clickEditView:(id)sender
{
    CSPublishViewController* postController = [[CSPublishViewController alloc]init];
    CSNavigationController* nav = [[CSNavigationController alloc]initWithRootViewController:postController];
    //[self.navigationController pushViewController:postController animated:YES];
    [self presentViewController:nav animated:YES completion:^{
        debugLog(@"edit tweet view!");
    }];
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(CSSlideSwitchView *)view
{
    return 2;
}

- (UIViewController *)slideSwitchView:(CSSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
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
