//
//  CSNavigationController.m
//  ChangTalk
//
//  Created by ctkj on 14-3-19.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSNavigationController.h"
#import "UIViewController+MMDrawerController.h"

@interface CSNavigationController ()

@end

@implementation CSNavigationController

#pragma mark 一个类只会调用一次
//+ (void)initialize
//{
//    // 1.取出设置主题的对象
//    UINavigationBar *navigationBar = [UINavigationBar appearance];
//    
////    // 2.设置导航栏的背景图片
////    NSString *navBarBg = nil;
////    if (OSVersionIsAtLeastiOS7) { // iOS7
////        navBarBg = @"NavBar64";
////        navigationBar.tintColor = [UIColor whiteColor];
////    } else { // 非iOS7
////        navBarBg = @"NavBar";
////        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
////    }
////    [navigationBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
//    
//    // 3.标题
//    [navigationBar setTitleTextAttributes:@{
//                                     NSForegroundColorAttributeName : [UIColor whiteColor]
//                                     }];
//    if ([navigationBar respondsToSelector:@selector(setBarTintColor:)])
//        [navigationBar setBarTintColor:[UIColor greenColor]];
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.navigationBar respondsToSelector:@selector(setTranslucent:)]) {
        self.navigationBar.translucent = NO;
        if (OSVersionIsAtLeastiOS7) {
            self.navigationBar.barTintColor = [UIColor colorWithRed:120/255.0f green:180/255.0f blue:0/255.0f alpha:1.0f];
        }
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18.0]};
        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (UIStatusBarStyle)preferredStatusBarStyle{
//    if(OSVersionIsAtLeastiOS7){
//        return UIStatusBarStyleLightContent;
//    }
//    else {
//        return UIStatusBarStyleDefault;
//    }
//}
@end
