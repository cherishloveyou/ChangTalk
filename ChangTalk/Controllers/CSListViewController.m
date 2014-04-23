//
//  CSListViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-3-25.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSListViewController.h"
#import "CSHomeViewController.h"
#import "CSNavigationController.h"
#import "CSContentViewController.h"
#import "CSNewsDetailViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface CSListViewController ()

@end

@implementation CSListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"大家在聊";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableViewList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableViewList.delegate = self;
    self.tableViewList.dataSource = self;
    [self.view addSubview:self.tableViewList];
    [self.tableViewList setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSString *ListViewCellId = @"ListViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 第 %d 行",self.title,row];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CSContentViewController *detailController = [[CSContentViewController alloc] init];
//    detailController.newsid = 8877 + indexPath.row;
//    
//    MMDrawerController *parentController = (MMDrawerController *)self.view.window.rootViewController;
//    CSNavigationController *nav = (CSNavigationController*)parentController.centerViewController;
//    
//    [nav pushViewController:detailController animated:YES];
}
@end
