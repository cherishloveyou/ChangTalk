//
//  CSHomeViewController.h
//  ChangTalk
//
//  Created by ctkj on 14-3-19.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSNavigationController.h"
#import "CSNewsViewController.h"
#import "CSListViewController.h"
#import "CSSlideSwitchView.h"
#import "CSTweetViewController.h"

@interface CSHomeViewController : UIViewController<CSSlideSwitchViewDelegate>

@property (nonatomic, strong) CSSlideSwitchView *slideView;
@property (nonatomic, strong) CSNewsViewController *newsVC;
@property (nonatomic, strong) CSTweetViewController *tweetVC;

@end
