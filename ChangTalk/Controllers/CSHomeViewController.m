//
//  CSHomeViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-3-19.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSHomeViewController.h"

@interface CSHomeViewController ()

@end

@implementation CSHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
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

//    //选择自己喜欢的颜色
//    UIColor * color = [UIColor whiteColor];
//    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
//    self.navigationController.navigationBar.titleTextAttributes = dict;
    
//   self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:68/255.f green:178/255.f blue:39/255.f alpha:0];
    

    _slideView = [[CSSlideSwitchView alloc]initWithFrame:self.view.bounds];
    
    self.slideView.slideSwitchViewDelegate = self;
    
    self.slideView.tabItemNormalColor = [CSSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideView.tabItemSelectedColor = [CSSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideView.shadowImage = [[UIImage imageNamed:@"tab_line_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    self.vc1 = [[CSListViewController alloc] init];
    self.vc1.title = @"今日有料";
    
    self.vc2 = [[CSRegisterViewController alloc] init];
    self.vc2.title = @"大家在聊";
    
    //self.slideView.userInteractionEnabled = YES;

    [self.view addSubview:self.slideView];
    
    [self.slideView buildUI];
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
    //    SUNListViewController *vc = nil;
    //    if (number == 0) {
    //        vc = self.vc1;
    //    } else if (number == 1) {
    //        vc = self.vc2;
    //    } else if (number == 2) {
    //        vc = self.vc3;
    //    } else if (number == 3) {
    //        vc = self.vc4;
    //    } else if (number == 4) {
    //        vc = self.vc5;
    //    } else if (number == 5) {
    //        vc = self.vc6;
    //    }
    //    [vc viewDidCurrentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
