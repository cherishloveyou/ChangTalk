//
//  CSEditProfileViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-4-30.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSEditProfileViewController.h"

@interface CSEditProfileViewController ()

@property (nonatomic, strong) UIImageView* avatarView;
@property (nonatomic, strong) UISegmentedControl* genderSegment;

@end

@implementation CSEditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"编辑个人资料";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 80, 80)];
    _avatarView.backgroundColor = [UIColor redColor];
    _avatarView.layer.cornerRadius = CGRectGetWidth(_avatarView.frame)/2.0f;
    _avatarView.clipsToBounds = YES;
    [self.view addSubview:_avatarView];

    _genderSegment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"男",@"女",nil]];
    [self.view addSubview:_genderSegment];
    
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
