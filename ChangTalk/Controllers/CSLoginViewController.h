//
//  CSLoginViewController.h
//  ChangTalk
//
//  Created by ctkj on 14-3-24.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSLoginViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *usernameView;
@property (strong, nonatomic) UIView *passwordView;
@property (strong, nonatomic) UIView *sendButtonView;

@property (nonatomic,strong)NSDictionary* userDict;

@end
