//
//  CSTweetViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-3-31.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSTweetViewController.h"
#import "TweetTableViewCell.h"
#import "AFNetworking.h"
#import "CSContentViewController.h"
#import "MMDrawerController.h"
#import "CSNavigationController.h"

@interface CSTweetViewController ()
{
    EGORefreshTableHeaderView* _refreshHeaderView;
    EGORefreshTableFooterView* _refreshFooterView;
    BOOL _reloading;
    BOOL _isloadOver;
    NSInteger pageIndex;
}

@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong)NSMutableArray *msgData;

@end

@implementation CSTweetViewController

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
    
    _msgData = [[NSMutableArray alloc] initWithCapacity:20];
    
    _tableViewList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableViewList.delegate = self;
    _tableViewList.dataSource = self;
    [self.view addSubview:_tableViewList];
    [self.tableViewList setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    //下拉刷新
    [self createRefreshHeaderView];

    [self reLoadNewsData:YES];
}

- (void)getPicSite
{
    //\d+,([^,|]+),\d+/g
    NSString* str = @"11874,/user/2014/0325/201403250105070676250.thumb.jpg,0|22444,/user/2014/0325/201403250105070676250.thumb.jpg,1";
    
    NSLog(@"string:%@",str);
    NSArray *array = [str componentsSeparatedByString:@"|"];
    NSArray *result = [array [0] componentsSeparatedByString:@","];
    NSLog(@"result:%@", result[1]);
    
    //regexTest
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+,([^,|]+),\\d+" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *arrayTest = nil;
    arrayTest = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    NSString *str1 = nil;
    for (NSTextCheckingResult* b in arrayTest)
    {
        str1 = [str substringWithRange:b.range];
        NSLog(@" str 1 is %@",str1);
    }
}
//初始化数据
- (void)clearData
{
    pageIndex = 1;
    [_msgData removeAllObjects];
}

- (void)refreshNewsData
{
    if (1) {
        [self reLoadNewsData:NO];
    }   //无网络连接则读取缓存
    else {
    }
}

- (void)reLoadNewsData:(BOOL)noRefresh
{
    //如果有网络连接,刷新数据
    if (1) {
        //如果加载完毕
        if (_isloadOver) {
            return;
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:kAPI_GetAggregatedMessage(2,1,30) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            debugLog(@"TweetJSON: %@", responseObject);
            //如果是刷新数据，那么久清空数据集
            if(!noRefresh){
                [self clearData];
            }
            @try {
                
                NSArray *array = [responseObject objectForKey:@"InfoList"];
                if (array) {
                    for (id dicItem in array) {
                        TweetItem *item = [[TweetItem alloc] initWithDictionary:dicItem];
                        [_msgData addObject:item];
                    }
                }
                
                [_tableViewList reloadData];
                [self doneLoadingTableViewData];
            }
            @catch (NSException *exception) {
                //[NdUncaughtExceptionHandler TakeException:exception];
            }
            @finally {
                [self doneLoadingTableViewData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            //alert network error
            [self doneLoadingTableViewData];
        }];
    }else{
        //如果没有网络连接读取缓存
    }
}

- (void)createRefreshHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, -CGRectGetHeight(_tableViewList.bounds), CGRectGetWidth(self.view.frame), CGRectGetHeight(_tableViewList.bounds))];
    _refreshHeaderView.delegate = self;
    
	[_tableViewList addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)createRefreshFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    CGFloat height = MAX(_tableViewList.contentSize.height, _tableViewList.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              CGRectGetWidth(self.view.frame),
                                              self.view.bounds.size.height);
    }else{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,CGRectGetWidth(self.view.frame), self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_tableViewList addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

- (void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    [self finishReloadingData];
    [self createRefreshFooterView];
}

- (void)beginToReloadData:(EGORefreshType)aRefreshType{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshType == EGORefreshHeader)
	{
        // pull down to refresh data
        [self refreshNewsData];
    }else if(aRefreshType == EGORefreshFooter){
        // pull up to load more data
        pageIndex++;
        //[self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
        [self reLoadNewsData:YES];
    }
	// overide, the actual loading data operation is done in the subclass
}

- (void)finishReloadingData
{
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableViewList];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableViewList];
        [self createRefreshFooterView];
    }
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark - EGORefreshTable Delegate
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading;
}

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshType)aRefreshType
{
    [self beginToReloadData:aRefreshType];
}

#pragma mark - UIScrollView Delegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_msgData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetItem *weibo = [self.msgData objectAtIndex:indexPath.row];
    float height = [TweetView getTweetViewHeight:weibo isRepost:NO];
    
    height += 58;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString* cellIdentifier = [NSString stringWithFormat:@"TweetCellIdentifier%d,%d",indexPath.section,indexPath.row];
    static NSString* cellIdentifier = @"TweetCellIdentifier";
    
    TweetTableViewCell *cell = (TweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TweetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_msgData count]>0) {
        TweetItem *weibo = [self.msgData objectAtIndex:indexPath.row];
        cell.tweetItem = weibo;
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetItem *weibo = [self.msgData objectAtIndex:indexPath.row];
    [_delegate slidePushDetailViewController:weibo.tweetID];
    
//    CSContentViewController *detailController = [[CSContentViewController alloc] init];
//    detailController.articleID = weibo.tweetID;
//    
//    MMDrawerController *parentController = (MMDrawerController *)self.view.window.rootViewController;
//    CSNavigationController *nav = (CSNavigationController*)parentController.centerViewController;
//    
//    [nav pushViewController:detailController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
