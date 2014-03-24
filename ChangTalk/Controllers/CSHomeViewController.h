//
//  CSHomeViewController.h
//  ChangTalk
//
//  Created by ctkj on 14-3-19.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSLoginViewController.h"
#import "CSRegisterViewController.h"
#import "SlideMenuItem/CSSlideSwitchView.h"

@interface CSHomeViewController : UIViewController<CSSlideSwitchViewDelegate>

@property (nonatomic, strong) CSSlideSwitchView* slideView;
@property (nonatomic, strong) CSLoginViewController* vc1;
@property (nonatomic, strong) CSRegisterViewController* vc2;

@end
