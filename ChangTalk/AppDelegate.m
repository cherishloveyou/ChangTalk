//
//  AppDelegate.m
//  ChangTalk
//
//  Created by ctkj on 14-3-18.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "AppDelegate.h"

#import "MMDrawerVisualState.h"
#import "CSDrawerVisualStateManager.h"
#import "CSHomeViewController.h"
#import "CSLeftViewController.h"
#import "CSNavigationController.h"
#import "NTSlidingViewController.h"
#import "CSNewsViewController.h"
#import "CSTweetViewController.h"
#import "CSIntrosViewController.h"
#import "CSLoginViewController.h"
#import <QuartzCore/QuartzCore.h>


#define kSlideMenuWidth                240.0f

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)startChangShuo
{
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;

    
    UIViewController *leftSideViewController = [[CSLeftViewController alloc] init];
    
    UIViewController *homeViewController = [[CSHomeViewController alloc] init];
    
    //UIViewController *rightSideDrawerViewController = [[RightSideDrawerViewController alloc] init];
    
    _commonNavController = [[CSNavigationController alloc] initWithRootViewController:homeViewController];
    
    [_commonNavController setRestorationIdentifier:@"CSNavigationControllerRestorationKey"];
    
//    CSNewsViewController* newsController = [[CSNewsViewController alloc]init];
//    CSTweetViewController* tweetController = [[CSTweetViewController alloc]init];
//
//    NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:@"今日有料" viewController:newsController];
//
//    [sliding addControllerWithTitle:@"大家在聊" viewController:tweetController];
//
//    NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitlesAndControllers:[NSDictionary dictionaryWithObjectsAndKeys:newsController,@"Test1",tweetController,@"Test2", nil]];
//    sliding.selectedLabelColor = [UIColor redColor];
//    sliding.unselectedLabelColor = [UIColor brownColor];
    
    if(OSVersionIsAtLeastiOS7){
        //UINavigationController *leftSideNavController = [[CSNavigationController alloc] initWithRootViewController:leftSideViewController];
		//[leftSideNavController setRestorationIdentifier:@"CSLeftControllerRestorationKey"];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:_commonNavController
                                 leftDrawerViewController:leftSideViewController
                                 rightDrawerViewController:nil];
        [self.drawerController setShowsShadow:NO];
    }else{
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:_commonNavController
                                 leftDrawerViewController:leftSideViewController
                                 rightDrawerViewController:nil];
    }
    
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setShowsShadow:YES];
    [self.drawerController setMaximumLeftDrawerWidth:kSlideMenuWidth];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[CSDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];

    if(OSVersionIsAtLeastiOS7){
        UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                              green:173.0/255.0
                                               blue:234.0/255.0
                                              alpha:1.0];
        [self.window setTintColor:tintColor];
    }
    //
    self.window.rootViewController = self.drawerController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //判断是否是第一次使用
    NSString* key = (NSString *)kCFBundleVersionKey;
    NSString* lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    NSString* currentVersion= [NSBundle mainBundle].infoDictionary[key];
    
    if ([lastVersion isEqualToString:currentVersion]) {
        
        [self startChangShuo];
        
    }else{
        // 保存当前版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        // 新特征界面介绍
//        CSIntrosViewController* introsVC =[[CSIntrosViewController alloc] init];
//        introsVC.startBlock = ^(){
//            [self startChangShuo];
//        };
//        self.window.backgroundColor = [UIColor whiteColor];
//        [self.window makeKeyAndVisible];
//        self.window.rootViewController = introsVC;
        CSLoginViewController* loginVC = [[CSLoginViewController alloc]init];
        self.window.rootViewController = loginVC;
    }

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
