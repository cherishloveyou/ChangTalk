//
//  CSNewsViewController.m
//  ChangTalk 今日有料
//
//  Created by ctkj on 14-3-25.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSNewsViewController.h"
#import "NewsTableViewCell.h"
#import "CycleScrollView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "EGORefreshTableHeaderView.h"
#import "NewsItem.h"

#define kAPI_SLIDE  @"http://mtalksvc.tc108.org:831/api/AHome/GetRecommendInfo?siteID=1"

#define kAPI_NEWS(index,size)  [NSString stringWithFormat:@"http://mtalksvc.tc108.org:831/API/ATalk/GetInfoRecommendList?siteID=1&pageIndex=%d&pageSize=%d",index,size]

//#define kAPI_NEWSPIC(site)  @"http://photoshow.tc108.org:814%@"

@interface CSNewsViewController ()
{
    EGORefreshTableHeaderView* _refreshHeaderView;
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
    
    _bannerData = [[NSMutableArray alloc]initWithCapacity:20];
    _newsData = [[NSMutableArray alloc] initWithCapacity:20];
    [self createRefreshHeaderView];

    _bannerView = [[CycleScrollView alloc] initWithFrame: CGRectMake(0, 0, 320, 124) animationDuration:4.0];
    _tableViewList.tableHeaderView = _bannerView;
    
    //
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kAPI_SLIDE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //debugLog(@"JSON: %@", responseObject);
        //NSArray* slidesArray = [responseObject objectForKey:@"Slides"];
        //[self.bannerData addObjectsFromArray:slidesArray];
        [_bannerData addObjectsFromArray:[responseObject objectForKey:@"Slides"]];
        debugLog(@"bannerViewData:%@",_bannerData);
        NSMutableArray *viewsArray = [@[] mutableCopy];
        for (int i = 0; i < [_bannerData count]; ++i) {
            UIImageView* tempView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 124)];
            [tempView setImageWithURL:[NSURL URLWithString:[_bannerData[i] objectForKey:@"ImgUrl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
            
            UILabel* tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(tempView.frame)-20, 320, 20)];
            tempLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
            tempLabel.text = [_bannerData[i] objectForKey:@"Title"];
            [tempView addSubview:tempLabel];
            
            [viewsArray addObject:tempView];
        }
        
        _bannerView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        _bannerView.totalPagesCount = ^NSInteger(void){
            return [viewsArray count];
        };
        _bannerView.TapActionBlock = ^(NSInteger pageIndex){
            debugLog(@"点击了第%d个",pageIndex);
        };
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        debugLog(@"Error: %@", error);
    }];
    
    [self refreshNewsData:YES];
    [self getPicSite];

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


- (void)refreshNewsData:(BOOL)isRefresh
{
    //如果有网络连接,刷新数据
    if (1) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:kAPI_NEWS(1,15) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            @try {
                if(isRefresh){
                    [_newsData removeAllObjects];
                }
                NSArray *array = [responseObject objectForKey:@"InfoList"];
                if (array) {
                    for (id dicItem in array) {
                        //NSDictionary *dicItem = [array objectAtIndex:i];
                        NewsItem *item = [[NewsItem alloc] initWithDictionary:dicItem];
                        [_newsData addObject:item];
                    }
                }
                //[_newsData addObjectsFromArray:[responseObject objectForKey:@"InfoList"]];
                [_tableViewList reloadData];
            }
            @catch (NSException *exception) {
                //[NdUncaughtExceptionHandler TakeException:exception];
            }
            @finally {
                //[self doneLoadingTableViewData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            //alert network error
        }];
    }else{
        //如果没有网络连接读取缓存
    }
}

- (void)createRefreshHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 60.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[_tableViewList addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_refreshHeaderView.loading = YES;
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    _refreshHeaderView.loading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableViewList];
	
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
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
    
    if ([_newsData count] > 0) {
        [((NewsTableViewCell *)cell) configNewsCellWithContent:[_newsData objectAtIndex:indexPath.row]];
        //if (_tableViewList.dragging == NO && _tableViewList.decelerating == NO)
            //[((NewsTableViewCell *)cell) startDownloadQiuShiImage];
    }
    return  cell;
}


@end
