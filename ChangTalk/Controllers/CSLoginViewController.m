//
//  CSLoginViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-3-24.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSLoginViewController.h"
#import "AFNetworking.h"


//@param username  password
#define kAPI_LOGINID  @"http://login.tc108.org:807/login/mobile.aspx"
#define kAPI_PUBLISH  @"http://mtalksvc.tc108.org:831/API/ATalk/PostInfo"
#define kUserDefaultsCookie @"kUserDefaultsCookie"

@interface CSLoginViewController ()

@end

@implementation CSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"登陆";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //test login api
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"ct408", @"username",@"qwerty",@"password",nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //@{@"username": @"password"};
    [manager POST:kAPI_LOGINID parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.userDict = (NSDictionary*)responseObject;
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:kAPI_LOGINID]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefaultsCookie];
    

    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [button setTitle:NSLocalizedString(@"Publish Message", @"Press Me Button Normal Text") forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"Press Down", @"Pressing Me Button Highlighted Text") forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(publishMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (NSString*)getCurrentDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}



- (void)publishMessageAction:(id)sender
{
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    NSString* loginCookie = [NSString stringWithFormat:@"TC108INFO=UINFO=%@;TC108Client=ui=%@",[self.userDict objectForKey:@"access_token"],[self.userDict objectForKey:@"uid"]];
    NSLog(@"cookie = %@",loginCookie);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer.HTTPRequestHeaders.
    //manager.requestSerializer.HTTPRequestHeaders =[setValue:loginCookie forHTTPHeaderField:@"cookie"];
    [manager.requestSerializer setValue:loginCookie forHTTPHeaderField:@"cookie"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString* content = [NSString stringWithFormat:@"ios测试接口%@",[self getCurrentDate]];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"",@"ForumsCode",@"0",@"IsPrivate",@"0",@"ForwardingID",@"1",@"SiteID",@"ios",@"OperatingSystem",@"Apple",@"Browser",@"Apple&Iphone5C&7.0",@"BrowserVersion",@"",@"ImagesField",@"Apple测试接口",@"Title",content,@"Content",nil];
    
    [manager POST:kAPI_PUBLISH parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.userDict = (NSDictionary*)responseObject;
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
