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
+ (void)initialize
{
    // 1.取出设置主题的对象
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
//    // 2.设置导航栏的背景图片
//    NSString *navBarBg = nil;
//    if (OSVersionIsAtLeastiOS7) { // iOS7
//        navBarBg = @"NavBar64";
//        navigationBar.tintColor = [UIColor whiteColor];
//    } else { // 非iOS7
//        navBarBg = @"NavBar";
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
//    }
//    [navigationBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
    
    // 3.标题
    [navigationBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     }];
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
