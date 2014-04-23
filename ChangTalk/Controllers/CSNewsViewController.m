//
//  CSNewsViewController.m
//  ChangTalk 今日有料
//
//  Created by ctkj on 14-3-25.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSNewsViewController.h"
#import "CSNavigationController.h"
#import "NewsTableViewCell.h"
#import "CycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "EGORefreshTableHeaderView.h"
#import "CSContentViewController.h"
#import "MMDrawerController.h"
#import "NewsItem.h"

@interface CSNewsViewController ()
{
    EGORefreshTableHeaderView* _refreshHeaderView;
    EGORefreshTableFooterView* _refreshFooterView;
    BOOL _reloading;
    BOOL _isloadOver;
    NSInteger pageIndex;
}

@property (nonatomic, strong) CycleScrollView *bannerView;
@property (nonatomic, strong) NSMutableArray* bannerData;
@property (nonatomic, strong) NSMutableArray* newsData;

@end


@implementation CSNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"今日有料";
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableViewList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableViewList.delegate = self;
    _tableViewList.dataSource = self;
    [self.view addSubview:self.tableViewList];
    [self.tableViewList setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    pageIndex = 1;
    _bannerData = [[NSMutableArray alloc]initWithCapacity:20];
    _newsData = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self createRefreshHeaderView];
    
    _bannerView = [[CycleScrollView alloc] initWithFrame: CGRectMake(0, 0, 320, 144) animationDuration:4.0];
    _tableViewList.tableHeaderView = _bannerView;
    
    //
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kAPI_SLIDE(2) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //debugLog(@"slide JSON: %@", responseObject);
        //NSArray* slidesArray = [responseObject objectForKey:@"Slides"];
        //[self.bannerData addObjectsFromArray:slidesArray];
        [_bannerData addObjectsFromArray:[responseObject objectForKey:@"Slides"]];
        NSArray *array = [responseObject objectForKey:@"InfoList"];
        if (array) {
            for (id dicItem in array) {
                //NSDictionary *dicItem = [array objectAtIndex:i];
                NewsItem *item = [[NewsItem alloc] initWithDictionary:dicItem];
                [_newsData addObject:item];
            }
        }
        //debugLog(@"bannerViewData:%@",_bannerData);
        NSMutableArray *viewsArray = [@[] mutableCopy];
        for (int i = 0; i < [_bannerData count]; ++i) {
            UIImageView* tempView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 144)];
            [tempView setImageWithURL:[NSURL URLWithString:[_bannerData[i] objectForKey:@"ImgUrl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
            
            UILabel* tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(tempView.frame)-20, 320, 20)];
            tempLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
            tempLabel.text = [_bannerData[i] objectForKey:@"Title"];
            [tempView addSubview:tempLabel];
            
            [viewsArray addObject:tempView];
        }
        
        _bannerView.fetchContentViewAtIndex = ^UIView *(NSInteger curIndex){
            return viewsArray[curIndex];
        };
        _bannerView.totalPagesCount = ^NSInteger(void){
            return [viewsArray count];
        };
        _bannerView.TapActionBlock = ^(NSInteger curIndex){
            debugLog(@"点击了第%d个",curIndex);
        };
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        debugLog(@"Error: %@", error);
    }];
    //
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
    [_newsData removeAllObjects];
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
        [manager GET:kAPI_NEWS(pageIndex,0) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //debugLog(@"NewsJSON: %@", responseObject);
            //如果是刷新数据，那么久清空数据集
            if(!noRefresh){
                [self clearData];
            }
            @try {
                NSArray *array = [responseObject objectForKey:@"InfoList"];
                if (array) {
                    for (id dicItem in array) {
                        NewsItem *item = [[NewsItem alloc] initWithDictionary:dicItem];
                        [_newsData addObject:item];
                    }
                }
                //[_newsData addObjectsFromArray:[responseObject objectForKey:@"InfoList"]];
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
    return [_newsData count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NewsCellIdentifier";
    NewsTableViewCell *cell = (NewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        //cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil] lastObject];
        cell = [[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_newsData count] > 0) {
        [((NewsTableViewCell *)cell) configNewsCellWithContent:[_newsData objectAtIndex:indexPath.row]];
        //if (_tableViewList.dragging == NO && _tableViewList.decelerating == NO)
            //[((NewsTableViewCell *)cell) startDownloadQiuShiImage];
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSContentViewController *detailController = [[CSContentViewController alloc] init];
    NewsItem* item = [_newsData objectAtIndex:indexPath.row];
    detailController.articleID = item.newsID;
    
    MMDrawerController *parentController = (MMDrawerController *)self.view.window.rootViewController;
    CSNavigationController *nav = (CSNavigationController*)parentController.centerViewController;
    
    [nav pushViewController:detailController animated:YES];
}

@end
