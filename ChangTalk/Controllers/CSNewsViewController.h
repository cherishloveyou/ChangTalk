//
//  CSNewsViewController.h
//  ChangTalk
//
//  Created by ctkj on 14-3-25.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface CSNewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>

@property (nonatomic, strong) UITableView *tableViewList;

@end
