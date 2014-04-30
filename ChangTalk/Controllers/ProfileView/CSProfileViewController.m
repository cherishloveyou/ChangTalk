//
//  CSProfileViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-3-31.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSProfileViewController.h"
#import "CSHeadCoverView.h"
#import "AFNetworking.h"
#import "CSNewsDetailViewController.h"
#import "TweetTableViewCell.h"
#import "TweetItem.h"

#define kAPI_GetUserMsgList(uid) [NSString stringWithFormat:@"http://mtalksvc.tc108.org:831/API/ATalk/GetInfoList?userID=%d&forumsCode=&keyword=&siteID=0&removeForwardingInfo=0&isContainUserName=0&orderBy=0&pageIndex=1&pageSize=1",uid]


@interface CSProfileViewController ()
@property (nonatomic, strong) CSHeadCoverView *coverView;
@property (nonatomic, strong) NSMutableArray *tweetData;
@end

@implementation CSProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"个人主页";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    _tweetData = [NSMutableArray arrayWithCapacity:15];
    
    _coverView = [[CSHeadCoverView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 160)];
    [_coverView setBackgroundImage:[UIImage imageNamed:@"profile.jpg"]];

    self.tableView.tableHeaderView = self.coverView;
    
    //
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];

    [manager POST:kAPI_GetUserProfile(self.userName) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        debugLog(@"profile Json: %@", responseObject);
        if ([responseObject objectForKey:@"UserID"]>0) {
            //
            int uid = [[responseObject objectForKey:@"UserID"]intValue];
            [manager GET:kAPI_GetUserMessage(uid,1,40) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                debugLog(@"ProfileJSON: %@", responseObject);
                //如果是刷新数据，那么久清空数据集
  
                NSArray *array = [responseObject objectForKey:@"InfoList"];
                if (array) {
                    for (id dicItem in array) {
                        TweetItem *item = [[TweetItem alloc] initWithDictionary:dicItem];
                        [_tweetData addObject:item];
                    }
                }
                [self.tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                //alert network error

            }];
        }else{
            //
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        debugLog(@"Error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_coverView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_coverView scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_coverView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_coverView scrollViewWillBeginDragging:scrollView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tweetData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetItem *weibo = [_tweetData objectAtIndex:indexPath.row];
    float height = [TweetView getTweetViewHeight:weibo isRepost:NO];
    
    height += 58;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"profileCellIdentifier";
    
    TweetTableViewCell *cell = (TweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TweetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_tweetData count]>0) {
        TweetItem *weibo = [_tweetData objectAtIndex:indexPath.row];
        cell.tweetItem = weibo;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSNewsDetailViewController *detailController = [[CSNewsDetailViewController alloc] init];
    detailController.newsid = 100;
    [self.navigationController pushViewController:detailController animated:YES];
}

@end
