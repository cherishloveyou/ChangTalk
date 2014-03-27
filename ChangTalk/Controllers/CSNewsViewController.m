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



#define kAPI_SLIDE  @"http://mtalksvc.tc108.org:831/api/AHome/GetRecommendInfo?siteID=1"

@interface CSNewsViewController ()

@property (nonatomic, strong) CycleScrollView *bannerView;
@property (nonatomic, strong) NSMutableArray* bannerData;

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

    
    _bannerView = [[CycleScrollView alloc] initWithFrame: CGRectMake(0, 0, 320, 124) animationDuration:4.0];
    _tableViewList.tableHeaderView = _bannerView;
    
    //
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kAPI_SLIDE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.bannerData = [responseObject objectForKey:@"Slides"];
        
        NSMutableArray *viewsArray = [@[] mutableCopy];
        for (int i = 0; i < [_bannerData count]; ++i) {
            UIImageView* tempView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 124)];
            [tempView setImageWithURL:[NSURL URLWithString:[_bannerData[i] objectForKey:@"ImgUrl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
            
            UILabel* tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(tempView.frame)-20, 320, 20)];
            tempLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6];
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
    return 20;
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
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil] lastObject];
    }
    [cell configNewsCellWithContent];
    return  cell;
}


@end
