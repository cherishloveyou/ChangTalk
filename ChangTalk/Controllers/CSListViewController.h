//
//  CSListViewController.h
//  ChangTalk
//
//  Created by ctkj on 14-3-25.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableViewList;

- (void)viewDidCurrentView;

@end
