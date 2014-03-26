//
//  CSHomeViewController.h
//  ChangTalk
//
//  Created by ctkj on 14-3-19.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSNewsViewController.h"
#import "CSListViewController.h"
#import "SlideMenuItem/CSSlideSwitchView.h"

@interface CSHomeViewController : UIViewController<CSSlideSwitchViewDelegate>

@property (nonatomic, strong) CSSlideSwitchView* slideView;
@property (nonatomic, strong) CSNewsViewController* vc1;
@property (nonatomic, strong) CSListViewController* vc2;

@end
