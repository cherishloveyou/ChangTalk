//
//  CSCommentViewController.h
//  ChangTalk
//
//  Created by ctkj on 14-4-8.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface CSCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@end
