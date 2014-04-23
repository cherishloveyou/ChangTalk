//
//  TweetItem.h
//  ChangTalk
//
//  Created by ctkj on 14-4-14.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

//"$id" = 3;
//Browser = "";
//CommentCount = 0;
//Content = sdf;
//ForumsCode = "001003            ";
//ForwardingCount = 0;
//ForwardingSource = "<null>";
//ForwardingSourceID = 0;
//ID = 9586;
//ImagesField = "12117,/user/2014/0408/201404081001068088750.thumb.jpg,0";
//IsContentCutOut = 0;
//OperatingSystem = "";
//PublishUnixTime = 1396951230;
//Title = sdfsdf;
//TitularID = 0;
//TitularName = "";
//TitularType = 0;
//TopCount = 0;

#import <Foundation/Foundation.h>

@interface TweetItem : NSObject

@property (nonatomic, assign)NSInteger tweetID;          //推文ID
@property (nonatomic, assign)NSInteger authorID;         //作者ID
@property (nonatomic, strong)NSString* authorName;       //作者名
@property (nonatomic, strong)NSString* tweetTitle;       //标题
@property (nonatomic, strong)NSString* tweetText;        //正文
@property (nonatomic, strong)NSString* tweetImage;       //图片
@property (nonatomic, strong)NSString* souceType;        //类型
@property (nonatomic, strong)TweetItem *reTweetItem;     //被转发的原微博
@property (nonatomic, assign)CGFloat publishTime;        //时间
@property (nonatomic, assign)NSInteger likeCount;        //赞数
@property (nonatomic, assign)NSInteger commentCount;     //评论数

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
