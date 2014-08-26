//
//  CSLeftViewController.m
//  ChangTalk
//
//  Created by ctkj on 14-3-19.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSLeftViewController.h"
#import "MenuCategoryCell.h"
#import "UIViewController+MMDrawerController.h"
#import "CSNavigationController.h"
#import "CSLoginViewController.h"
#import "CSListViewController.h"
#import "CSNewsViewController.h"
#import "CSTweetViewController.h"
#import "CSProfileViewController.h"
#import "CSSettingViewController.h"
#import "CSContentViewController.h"
#import "CSCommentViewController.h"
#import "CSSectionViewController.h"
#import "CSPublishViewController.h"


@interface CSLeftViewController ()

@end

@implementation CSLeftViewController

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
    
    //self.view.backgroundColor = [UIColor colorWithRed:61/255.0f green:61/255.0f blue:61/255.0f alpha:1.0f];
    //self.view
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:61/255.0f green:61/255.0f blue:61/255.0f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    [self.view addSubview:self.tableView];
    
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 110.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 34, 64, 64)];
        //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"userHead.jpg"];
        //imageView.backgroundColor = [UIColor redColor];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 32.0f;
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, 120, 20)];
        label.text = @"登陆/注册";
        //label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor whiteColor];
        //label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        //[label sizeToFit];
        //label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"App setting";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    //label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0 && indexPath.row == 0) {

        CSLoginViewController *loginController = [[CSLoginViewController alloc] init];
        
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:loginController];
        
        [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
        
    } else if (indexPath.section == 0 && indexPath.row == 1){
        CSTweetViewController* listController = [[CSTweetViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:listController];
        [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
    }else if (indexPath.section == 0 && indexPath.row == 2){
        CSNewsViewController *listController = [[CSNewsViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:listController];
        [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        CSProfileViewController* listController = [[CSProfileViewController alloc]init];
        CSNavigationController *navigationController = [[CSNavigationController alloc]initWithRootViewController:listController];
        [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        //CSSettingViewController* listController = [[CSSettingViewController alloc]init];
        CSCommentViewController* listController = [[CSCommentViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:listController];
        [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        //CSCommentViewController* listController = [[CSCommentViewController alloc]init];
        CSSectionViewController* listController = [[CSSectionViewController alloc]init];
        CSNavigationController *navigationController = [[CSNavigationController alloc]initWithRootViewController:listController];
        [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:nil];
    }else{
        
    }
}

#pragma mark - UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"menuCategoryCell";
    
    MenuCategoryCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[MenuCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    if (indexPath.section == 0) {
        NSArray *titles = @[@"主页", @"评论", @"版块"];
        cell.categoryName.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"设置", @"搜索", @"活动"];
        cell.categoryName.text = titles[indexPath.row];
    }
    cell.categoryThumb.image = [UIImage imageNamed:@"icon_menu_home"];
    
//    if ([cell.categoryName.text isEqualToString:@"主页"])
//    {
//        //设置默认选中
//        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    }
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
