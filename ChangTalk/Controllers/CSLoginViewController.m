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


@interface CSLoginViewController ()

@end

@implementation CSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登陆";
    self.view.backgroundColor = [UIColor redColor];
    
    //test login api
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"ct408", @"username",@"qwerty",@"password",nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //@{@"username": @"password"};
    [manager POST:kAPI_LOGINID parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
