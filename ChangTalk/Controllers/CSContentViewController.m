//
//  CSListViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-3-25.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//


#import "CSContentViewController.h"
#import "WebViewJsBridge.h"
#import "UIImageView+WebCache.h"
#import "CommentTableViewCell.h"
#import "RDRStickyKeyboardView.h"
#import "PhotoBrowseView.h"
#import "AFNetworking.h"



@interface CSContentViewController ()

@property (nonatomic, strong)UITableView *tableViewList;
@property (nonatomic, strong)UIView* contentView;
@property (nonatomic, strong)UIImageView* headView;    //头像
@property (nonatomic, strong)UILabel* contentName;     //名字
@property (nonatomic, strong)UILabel* contentTime;     //时间
@property (nonatomic, strong)UILabel* sourceType;      //来源
@property (nonatomic, strong)UIWebView* webView;       //内容


@property (nonatomic, strong)NSMutableArray* commentData;
@property (nonatomic, strong)NSDictionary* contentDict;  //

@property (nonatomic, strong)WebViewJsBridge* bridge;

@property (nonatomic, strong)UIView* loadingView;
@property (nonatomic, strong)UIActivityIndicatorView* activityView;

@property (nonatomic, strong)RDRStickyKeyboardView* inputView;


@end

@implementation CSContentViewController

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
    _tableViewList.delegate = self;
    _tableViewList.dataSource = self;
    [_tableViewList setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.tableViewList];
    
    _inputView = [[RDRStickyKeyboardView alloc] initWithScrollView:_tableViewList];
    _inputView.frame = self.view.bounds;
    _inputView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_inputView];
    
    _commentData = [[NSMutableArray alloc]initWithCapacity:15];
    _contentDict = [[NSDictionary alloc]init];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 36, 36)];
    _headView.layer.cornerRadius = _headView.frame.size.width/2;
    _headView.clipsToBounds = YES;
    [_contentView addSubview:_headView];
    
    _contentName = [[UILabel alloc]initWithFrame:CGRectMake(50, 2, 80, 16)];
    _contentName.font = [UIFont boldSystemFontOfSize:12.0f];
    [_contentView addSubview:_contentName];
    
    _contentTime = [[UILabel alloc]initWithFrame:CGRectMake(240, 2, 80, 16)];
    _contentTime.font = [UIFont systemFontOfSize:10.0f];
    _contentTime.textColor = [UIColor grayColor];
    //_contentTime.backgroundColor = [UIColor redColor];
    _contentTime.textAlignment = NSTextAlignmentRight;
    [_contentView addSubview:_contentTime];
    
    _sourceType = [[UILabel alloc]initWithFrame:CGRectMake(50, 16, 64, 16)];
    _sourceType.font = [UIFont systemFontOfSize:10.0f];
    _sourceType.textColor = [UIColor grayColor];
    [_contentView addSubview:_sourceType];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 40, 320, 10)];
    _webView.backgroundColor = [UIColor greenColor];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [_contentView addSubview:_webView];
    [self addTapOnWebView];

    _bridge = [WebViewJsBridge bridgeForWebView:_webView webViewDelegate:self];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:kAPI_INFO(_articleID) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"info Success: %@", responseObject);
        //
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:kAPI_MOBILE]]];
        
        _contentDict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"Result"]];
        
        _contentName.text = [_contentDict objectForKey:@"TitularName"];
        _contentTime.text = [self intervalSinceNow:[[_contentDict objectForKey:@"PublishUnixTime"] doubleValue]];
        _sourceType.text = [_contentDict objectForKey:@"OperatingSystem"];
        
        [_headView setImageWithURL:[NSURL URLWithString: kAPI_GetUserHeadPic([[_contentDict objectForKey:@"TitularID"]integerValue])]];
        
        [manager GET:kAPI_GetInfoComment(_articleID,1,15) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //
            debugLog(@"commentList: %@", responseObject);
            [_commentData addObjectsFromArray:[responseObject objectForKey:@"CommentInfoList"]];
            [_tableViewList reloadData];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)intervalSinceNow: (NSTimeInterval)late
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha = now-late;
    
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/172800<1)//(cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM月dd日 HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:late];
        timeString = [formatter stringFromDate:date];
    }
    return timeString;
}

-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_webView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

- (void)showLoadingView
{
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(-20, -20, 340, 500)];
    [_loadingView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_loadingView];
    
    UILabel *loadingText = [UILabel new];
    loadingText.text = @"载入中...";
    loadingText.frame = CGRectMake((320-80)/2 + 48, (480 -30)/2-10, 80, 30);
    [loadingText setBackgroundColor:[UIColor clearColor]];
    [_loadingView addSubview:loadingText];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityView setCenter:self.loadingView.center];
    [_loadingView addSubview:_activityView];
    
    [_activityView startAnimating];
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:_webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [_webView stringByEvaluatingJavaScriptFromString:imgURL];
    NSLog(@"image url=%@", urlToSave);
    if (urlToSave.length > 0) {
        //[self showImageURL:urlToSave point:pt];
        //PhotoBrowseView * browse = [[PhotoBrowseView alloc]initWithUrlPath:<#(NSString *)#> thumbnail:nil fromRect:<#(CGRect)#>];
        
    }
}

- (void)onAllImageLoaded:(NSArray *)args {
    int primaryKey = [[args objectAtIndex:0] intValue];
    NSLog(@"height%i", primaryKey);
    _webView.frame = CGRectMake(0, 40, 320, primaryKey);
    _contentView.frame = CGRectMake(0, 0, 320, 40+primaryKey);
    _tableViewList.tableHeaderView = _contentView;
}

- (void)renderWebViewWithData:(NSDictionary*)dict
{
    NSString* Title = [dict objectForKey:@"Title"];

    NSString* Content = [dict objectForKey:@"Content"];

    NSString* ImagesField = [dict objectForKey:@"ImagesField"];

    NSString* formatContent = [Content stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];

    NSString* renderJSScript = [NSString stringWithFormat:@"render(\"%@\",\"%@\",\"%d\",\"%@\")",formatContent,ImagesField,20,Title];

    [_webView stringByEvaluatingJavaScriptFromString:renderJSScript];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[self showLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self renderWebViewWithData:_contentDict];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSString *requestString = [[request URL] absoluteString];
    if ([requestString hasPrefix:kCustomProtocolScheme]) {
        NSArray *components = [[url absoluteString] componentsSeparatedByString:@":"];
        
        NSString *function = (NSString*)[components objectAtIndex:1];
        NSString *argsAsString = [(NSString*)[components objectAtIndex:2]
                                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *argsData = [argsAsString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *argsDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:argsData options:kNilOptions error:NULL];
        //将js的数组转换成objc的数组
        NSMutableArray *args = [NSMutableArray array];
        for (int i=0; i<[argsDic count]; i++) {
            [args addObject:[argsDic objectForKey:[NSString stringWithFormat:@"%d", i]]];
        }
        //调用oc方法，忽略警告
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SEL selector = NSSelectorFromString([function stringByAppendingString:@":"]);
        NSLog(@"sel:%@, args:%@", function, args);
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector withObject:args];
        }
    }
    NSLog(@"%@",request.URL.relativeString);
    //判断结束的字符串，来完成不同的事情
    if ([request.URL.relativeString hasSuffix:@"=a"] || [request.URL.relativeString hasSuffix:@"=b"] ) {

    }
    return YES;
}



#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_commentData objectAtIndex:indexPath.row];
    CGFloat cellHeight = [CommentTableViewCell getCellheight:dict];
    
    return cellHeight;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 
    return @"Comment number";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    return 60.0;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,40)];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    headerView.backgroundColor = [UIColor redColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"infoCommentListCell";
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = [_commentData objectAtIndex:indexPath.row];
    [cell setCommentCellContent:dict];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
