//
//  AppDelegate.h
//  ChangTalk
//
//  Created by ctkj on 14-3-18.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "CSNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MMDrawerController * drawerController;
@property (nonatomic, strong) CSNavigationController* commonNavController;

@end
