//
//  CSSettingViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-4-1.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSSettingViewController.h"

@interface CSSettingViewController ()
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UISwitch* pushSwitch;
@property (nonatomic, strong)UIButton* loginButton;
@end

@implementation CSSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _pushSwitch = [[UISwitch alloc]init];
    [_pushSwitch addTarget:self action:@selector(pushEventChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self createTableFooter];
}

- (void)createTableFooter
{
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 44.0f)];
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 44)];
    [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_loginButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor redColor]];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [tableFooterView addSubview:_loginButton];
    
    _tableView.tableFooterView = _loginButton;
}

- (void)pushEventChanged:(id)sender
{
    //
    debugLog(@"switch changed");
}

- (void)loginButtonClicked:(id)sender
{
    //
    debugLog(@"button click");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSInteger rows = 0;
    switch (sectionIndex) {
        case 0:
            rows = 3;
            break;
        case 1:
            rows = 2;
            break;
        default:
            break;
    }
    
    return rows;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        return 0;
//    }
//    return 24;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString *settingTitle = @"";
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    settingTitle = @"修改资料";
                    //cell.accessoryView = _modelSwitch;
                }
                    break;
                case 1:
                    settingTitle = @"切换城市";
                    break;
                case 2:
                {
                    settingTitle = @"消息推送";
                    cell.accessoryView = _pushSwitch;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    settingTitle = @"清除缓存";
                    break;
                case 1:
                    settingTitle = @"关于108社区";
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    cell.textLabel.text = settingTitle;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    //cell.textLabel.textColor = [UIColor brownColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    debugLog(@"section =%d rows=%d",indexPath.section,indexPath.row);
}
@end
