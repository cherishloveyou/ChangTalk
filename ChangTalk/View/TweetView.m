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

#define TWITTER_LEFTWIDTH 60
#define CELL_INFO_IMG_BTN_TAG 10000
#define CELL_RES_IMG_BTN_TAG 2000000
#define TWITTER_FONTSIZE_NAME 15

#define kWeibo_Width_List  (320-40) //微博在列表中的宽度
#define kWeibo_Width_Detail 300     //微博在详情页面的宽度

@implementation TweetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initTweetView];
        _parseText = [[NSMutableString alloc]init];
    }
    return self;
}

//重写weiboModel的serter方法，因为不能直接创建转发微博视图，会有死循环
-(void)setTweetItem:(TweetItem *)item
{
    _tweetItem = item;
    
    if (_retweetedView == nil) {
        _retweetedView = [[TweetView alloc]initWithFrame:CGRectZero];
        _retweetedView.isRetweeted = YES;
        [self addSubview:_retweetedView];
    }
    
    [self parseLink];
}

- (void)initTweetView
{
    _tweetTextView = [[RCLabel alloc]initWithFrame:CGRectZero];
    _tweetTextView.delegate = self;
    [self addSubview:_tweetTextView];
    
    _tweetImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _tweetImageView.backgroundColor = [UIColor clearColor];
    _tweetImageView.image = [UIImage imageNamed:@"tweet_image_loading.png"];
    _tweetImageView.contentMode = UIViewContentModeScaleAspectFit;
    _tweetImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageScaleUpAction:)];
    [_tweetImageView addGestureRecognizer:tap];
    [self addSubview:_tweetImageView];
    
    _repostBackView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tweet_timeline_border.png"]];
    UIImage *image = [_repostBackView.image stretchableImageWithLeftCapWidth:40 topCapHeight:20];
    _repostBackView.image = image;
    _repostBackView.backgroundColor = [UIColor clearColor];
    [self insertSubview:_repostBackView atIndex:0];
}

- (void)imageScaleUpAction:(UITapGestureRecognizer*)recongnizer
{
    //
}
-(void)parseLink
{
    //cell复用的话就清空原来的数据
    [_parseText setString:@""];
    
    if (_isRetweeted) {
        
        NSString* retweetedStr = [HtmlString transformString:[NSString stringWithFormat:@"@%@:",_tweetItem.authorName]];
        [_parseText appendString:retweetedStr];
    }
    if ([_tweetItem.tweetTitle length]>0) {
        [_parseText appendString:[NSString stringWithFormat:@"【%@】 ",_tweetItem.tweetTitle]];
    }

    [_parseText appendString:[HtmlString transformString:_tweetItem.tweetText]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int height = 4;
    
//    NSString *transformStr = [HtmlString transformString:_tweetItem.tweetText];
//    debugLog(@" repost =%d transStr=%@",_isRetweeted,transformStr);
    
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:_parseText];
    
    _tweetTextView.componentsAndPlainText = componentsDS;
    
    RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(0, height, 260,100)];
    
    tempLabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [tempLabel optimumSize:YES];

    _tweetTextView.frame = CGRectMake(0, height, 260, optimalSize.height);
    
    height += optimalSize.height;
    
    if (_isRetweeted) {
        _tweetTextView.frame = CGRectMake(0, 10, 260, optimalSize.height);
        //_tweetTextView.backgroundColor = [UIColor greenColor];
    }else{
        //_tweetTextView.backgroundColor = [UIColor redColor];
    }
    
    TweetItem *reItem = _tweetItem.reTweetItem;
    if (reItem != nil) {
        _retweetedView.tweetItem = reItem;
        //计算转发微博视图的高度
        float tweetedHeight = [TweetView getTweetViewHeight:reItem isRepost:YES];
        
        _retweetedView.frame = CGRectMake(0, _tweetTextView.frame.origin.y + _tweetTextView.frame.size.height, 260, tweetedHeight+16);

        _retweetedView.hidden=  NO;

    }else{
        _retweetedView.hidden = YES;
    }
    
    //微博图片
    {
        
        NSString * imagePath = _tweetItem.tweetImage;
        
        if (imagePath !=nil && ![@"" isEqualToString:imagePath]) {
            
            //_tweetImageView.image = [UIImage imageNamed:imagePath];
            NSString* cellPath = [self getTweetImage:imagePath];
            
            _tweetImageView.hidden = NO;
            
            _tweetImageView.frame = CGRectMake(10, _retweetedView.frame.size.height+height+16, 70, 80);
            
            [_tweetImageView setImageWithURL:[NSURL URLWithString:cellPath]];
        }else{
            _tweetImageView.hidden=YES;
        }
    }
    
    //----------------转发的微博视图背景_repostBackView---------------
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
    float height = 4;
    //--------------------计算微博内容text的高度------------------------
    
    NSString* contentStr = [NSString stringWithFormat:@"%@,%@",item.tweetTitle,item.tweetText];
    
//    //转发文字合成
//    if (isRepost) {
//        contentStr = [NSString stringWithFormat:@"@%@:%@",item.reTweetItem.authorName,contentStr];
//    }
    
    RCLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:contentStr];
    RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(TWITTER_LEFTWIDTH, height, kWeibo_Width_List,100)];
    tempLabel.componentsAndPlainText = componentsDS;
    CGSize optimalSize = [tempLabel optimumSize:YES];
    height += optimalSize.height;

    //NSLog(@"textLabel--height%f",textLabel.optimumSize.height);
    
    //--------------------计算微博图片的高度------------------------
    {
        NSString *thumbnailImage = item.tweetImage;
        if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
            height += 80;
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
    
    if (isRepost == YES) {
        height += 40;
    }
    
    return height;
}

- (void)RCLabel:(id)RCLabel didSelectLinkWithURL:(NSString *)url
{
    //
}

@end
