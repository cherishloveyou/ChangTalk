//
//  twitterView.m
//  ChangTalk
//
//  Created by ctkj on 14-4-14.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "TweetView.h"
#import "HtmlString.h"
#import "UIImageView+WebCache.h"
#import "CSTweetViewController.h"
#import "PhotoBrowseView.h"
#import "CSProfileViewController.h"
#import "CSNavigationController.h"
#import "MMDrawerController.h"
#import "NSString+UrlEncode.h"

#define TWITTER_LEFTMARGIN  60
#define TWITTER_FONTSIZE    16
#define TWITTER_LISTWIDTH   (320-64) //列表中的宽度


@implementation TweetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initTweetView];
        _parseText = [[NSMutableString alloc]init];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

//重写weiboModel的serter方法，因为不能直接创建转发微博视图，会有死循环
-(void)setTweetItem:(TweetItem *)item
{
    //_tweetItem = item;
    if (_tweetItem != item) {
        _tweetItem = item;
    }
    
    
    if (_retweetedView == nil) {
        _retweetedView = [[TweetView alloc]initWithFrame:CGRectZero];
        _retweetedView.isRetweeted = YES;
        [self addSubview:_retweetedView];
    }
    
    [self parseLink];
}

- (void)initTweetView
{
    _tweetLabel = [[RCLabel alloc]initWithFrame:CGRectZero];
    _tweetLabel.delegate = self;
    [self addSubview:_tweetLabel];
    
    _tweetThumb = [[UIImageView alloc]initWithFrame:CGRectZero];
    _tweetThumb.backgroundColor = [UIColor redColor];
    _tweetThumb.image = [UIImage imageNamed:@"tweet_image_loading.png"];
    _tweetThumb.contentMode = UIViewContentModeScaleAspectFit;
    _tweetThumb.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageScaleUpAction:)];
    [_tweetThumb addGestureRecognizer:tap];
    [self addSubview:_tweetThumb];
    
    //转发背景
    UIImage* retweetedImageView = [UIImage imageNamed:@"tweet_timeline_border.png"];
    _repostBackView = [[UIImageView alloc]initWithImage: [retweetedImageView stretchableImageWithLeftCapWidth:26 topCapHeight:10]];
    _repostBackView.backgroundColor = [UIColor clearColor];
    [self insertSubview:_repostBackView atIndex:0];
}

- (void)imageScaleUpAction:(UITapGestureRecognizer*)recongnizer
{
    //
    debugLog(@"full imageview!");
    
//    if (self.viewController) {
//        if ([self.viewController isKindOfClass:[CSTweetViewController class]]) {
//            UITableView* tableView = ((CSTweetViewController*)self.viewController).tableViewList;
//            UIWindow* window = [UIApplication sharedApplication].keyWindow;
//            
//            // convert rect to self(cell)
//            CGRect rectInCell = [self convertRect:_tweetThumb.frame toView:self];
//            
//            // convert rect to tableview
//            CGRect rectInTableView = [self convertRect:rectInCell toView:tableView];//self.superview
//            
//            // convert rect to window
//            CGRect rectInWindow = [tableView convertRect:rectInTableView toView:window];
//            
//            // show photo full screen
//            UIImage* image = _tweetThumb.image;
//            
//            if (image) {
//                rectInWindow = CGRectMake(rectInWindow.origin.x + (rectInWindow.size.width - image.size.width) / 2.f,
//                                          rectInWindow.origin.y + (rectInWindow.size.height - image.size.height) / 2.f,
//                                          image.size.width, image.size.height);
//            }
//            PhotoBrowseView* browseView =
//            [[PhotoBrowseView alloc] initWithUrlPath:self.tweetItem.tweetImage
//                                                       thumbnail:_tweetThumb.image
//                                                        fromRect:rectInWindow];
//            [window addSubview:browseView];
//        }
//    }
    
}

-(void)parseLink
{
    //cell复用的话就清空原来的数据
    [_parseText setString:@""];
    
    //转发不转标题
    if (_isRetweeted) {
        NSString* retweetedStr = [HtmlString transformString:[NSString stringWithFormat:@"@%@:",_tweetItem.authorName]];
        [_parseText appendString:retweetedStr];
    }
    
    if ([_tweetItem.tweetTitle length]>0) {
        [_parseText appendString:[NSString stringWithFormat:@"【%@】 ",_tweetItem.tweetTitle]];
    }

    [_parseText appendString:[HtmlString transformString:_tweetItem.tweetText]];
}

//layout subview
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int height = 0;
    
    RCLabelComponentsStructure* componentsDS = [RCLabel extractTextStyle:_parseText];
    
    _tweetLabel.componentsAndPlainText = componentsDS;
    
    RCLabel* tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, height, TWITTER_LISTWIDTH,40)];
    tempLabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [tempLabel optimumSize:YES];
    
    //CGSize optimalSize = [_tweetTextView optimumSize:YES];

    _tweetLabel.frame = CGRectMake(0, height, TWITTER_LISTWIDTH, optimalSize.height);
    
    if (_isRetweeted) {
        _tweetLabel.frame = CGRectMake(0, 6, TWITTER_LISTWIDTH, optimalSize.height);
    }
    
    height += optimalSize.height;
    
    //--------------------计算文字的高度------------------------
    TweetItem *reItem = _tweetItem.reTweetItem;
    if (reItem != nil) {
        _retweetedView.tweetItem = reItem;
        //计算转发微博视图的高度
        float retweetedHeight = [TweetView getTweetViewHeight:reItem isRepost:YES];
        //微调转发view的大小 这里相当于怎么了转发高度加了，因为背景图占位置。
        _retweetedView.frame = CGRectMake(4, _tweetLabel.frame.origin.y + _tweetLabel.frame.size.height+6, TWITTER_LISTWIDTH, retweetedHeight);
        //微调转发文字的位置
        //_tweetLabel.frame = CGRectMake(0, 2, TWITTER_LISTWIDTH, optimalSize.height);
        
        _retweetedView.hidden=  NO;

    }else{
        _retweetedView.hidden = YES;
    }
    
    //图片
    {
        height += 4;   //图片间距4
        NSString * imagePath = _tweetItem.tweetImage;
        
        if (imagePath !=nil && ![@"" isEqualToString:imagePath]) {
            
            //_tweetImageView.image = [UIImage imageNamed:imagePath];
            NSString* cellPath = [self getTweetImage:imagePath];
            
            _tweetThumb.hidden = NO;
            
            _tweetThumb.frame = CGRectMake(4, _tweetLabel.frame.origin.y+height, 80, 80);
            
            [_tweetThumb setImageWithURL:[NSURL URLWithString:cellPath]];
            
            //_tweetThumb.backgroundColor = [UIColor yellowColor];
        }else{
            _tweetThumb.hidden=YES;
        }
    }
    
    //----------------转发的背景View---------------
    if (self.isRetweeted) {
        _repostBackView.frame = self.bounds;
        _repostBackView.hidden = NO;
    } else {
        _repostBackView.hidden = YES;
    }
}

- (NSString*)getTweetImage:(NSString*)imageField
{
    //\d+,([^,|]+),\d+/g
    NSLog(@"string:%@",imageField);
    NSArray *array = [imageField componentsSeparatedByString:@"|"];
    NSArray *result = [array [0] componentsSeparatedByString:@","];
    
    return kAPI_GetInfoPic(result[1]);
}

//计数微博视图的高度
+ (CGFloat)getTweetViewHeight:(TweetItem *)item
                     isRepost:(BOOL)isRepost
{
    /**
     *   实现思路：计算每个子视图的高度，然后相加。
     **/
    float height = 8;
    //--------------------计算微博内容text的高度------------------------
    
    NSString* contentStr = item.tweetText;
    
    if ([item.tweetTitle length]>0) {
        contentStr = [NSString stringWithFormat:@"【%@】%@",item.tweetTitle,contentStr];
    }
    //转发文字合成
    if (isRepost) {
        contentStr = [NSString stringWithFormat:@"@%@:%@",item.reTweetItem.authorName,contentStr];
    }
    
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:contentStr];
    RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(TWITTER_LEFTMARGIN, height, TWITTER_LISTWIDTH,100)];
    tempLabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [tempLabel optimumSize:YES];
    height += optimalSize.height;

    //NSLog(@"textLabel--height%f",textLabel.optimumSize.height);
    
    //--------------------计算微博图片的高度------------------------
    NSString *thumbImage = item.tweetImage;
    if (thumbImage != nil && ![@"" isEqualToString:thumbImage]) {
        if (isRepost) {
            height += (80+10); // 转发补偿图片距离多一些 设计排版拉伸
        }else{
            height += (80+4);
        }
    }
    
    //--------------------计算转发微博视图的高度------------------------
    //转发的微博
    TweetItem *reItem = item.reTweetItem;
    
    if (reItem != nil) {
        //转发微博视图的高度
        float repostHeight = [TweetView getTweetViewHeight:reItem isRepost:YES];
        height += (repostHeight);
    }

    //--------------------计算转发微博视图的高度------------------------

    return height;
}

- (void)RCLabel:(id)RCLabel didSelectLinkWithURL:(NSString *)url
{
    NSString* urlString = [url urlDecode];
    debugLog(@"click link=%@",[url urlDecode]);
    if ([urlString hasPrefix:@"@"]) { //查看用户信息
        NSRange range = NSMakeRange(1, urlString.length-1);
        NSString* user = [urlString substringWithRange:range];
        CSProfileViewController* profileController  = [[CSProfileViewController alloc]init];
        profileController.userName = user;
        
        MMDrawerController *parentController = (MMDrawerController *)self.superview.window.rootViewController;
        CSNavigationController *nav = (CSNavigationController*)parentController.centerViewController;
        
        [nav pushViewController:profileController animated:YES];
        
    }else if([urlString hasPrefix:@"#"]&&[urlString hasSuffix:@"#"]){
        NSRange range = NSMakeRange(1, urlString.length-2);
        NSString* topic = [urlString substringWithRange:range];
        
    }else if([urlString hasPrefix:@"http"]){
        
    }
}

@end
