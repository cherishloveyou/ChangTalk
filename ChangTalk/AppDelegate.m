//
//  AppDelegate.m
//  ChangTalk
//
//  Created by ctkj on 14-3-18.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "AppDelegate.h"

#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "CSDrawerVisualStateManager.h"

#import "CSHomeViewController.h"
#import "CSLeftViewController.h"
#import "CSNavigationController.h"

#import <QuartzCore/QuartzCore.h>


#define kSlideMenuWidth                200.0f


@interface AppDelegate ()
@property (nonatomic,strong) MMDrawerController * drawerController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController * leftSideViewController = [[CSLeftViewController alloc] init];
    
    UIViewController * centerViewController = [[CSHomeViewController alloc] init];
    
    //UIViewController * rightSideDrawerViewController = [[RightSideDrawerViewController alloc] init];
    
    UINavigationController * navigationController = [[CSNavigationController alloc] initWithRootViewController:centerViewController];
    
    if ([navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        [navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
    
    [navigationController setRestorationIdentifier:@"CSNavigationControllerRestorationKey"];
    
    if(OSVersionIsAtLeastiOS7){

        //UINavigationController * leftSideNavController = [[CSNavigationController alloc] initWithRootViewController:leftSideViewController];
		//[leftSideNavController setRestorationIdentifier:@"CSLeftControllerRestorationKey"];
        
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:navigationController
                                 leftDrawerViewController:leftSideViewController
                                 rightDrawerViewController:nil];
        [self.drawerController setShowsShadow:NO];
    }
    else{
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:centerViewController
                                 leftDrawerViewController:leftSideViewController
                                 rightDrawerViewController:nil];
    }
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    
    [self.drawerController setMaximumLeftDrawerWidth:kSlideMenuWidth];
    [self.drawerController setShowsShadow:YES];
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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(OSVersionIsAtLeastiOS7){
        UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                              green:173.0/255.0
                                               blue:234.0/255.0
                                              alpha:1.0];
        [self.window setTintColor:tintColor];
    }
    [self.window setRootViewController:self.drawerController];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [application setStatusBarStyle:UIStatusBarStyleLightContent];//黑体白字
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
