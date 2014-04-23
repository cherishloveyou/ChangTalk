//
//  CSSectionViewController.h
//  ChangTalk
//
//  Created by ctkj on 14-4-11.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSSectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@end
