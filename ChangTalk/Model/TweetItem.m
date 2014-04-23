//
//  TweetItem.m
//  ChangTalk
//
//  Created by ctkj on 14-4-14.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "TweetItem.h"

@implementation TweetItem


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        self.tweetID = [[dictionary objectForKey:@"ID"] integerValue];
        self.authorID = [[dictionary objectForKey:@"TitularID"]integerValue];
        self.authorName = [dictionary objectForKey:@"TitularName"];
        self.tweetTitle = [dictionary objectForKey:@"Title"];
        self.tweetText = [dictionary objectForKey:@"Content"];
        self.tweetImage = [dictionary objectForKey:@"ImagesField"];
        self.souceType = [dictionary objectForKey:@"OperatingSystem"];
        self.publishTime = [[dictionary objectForKey:@"PublishUnixTime"] doubleValue];
        self.likeCount = [[dictionary objectForKey:@"TopCount"] integerValue];
        self.commentCount = [[dictionary objectForKey:@"CommentCount"] integerValue];
        
        if (![[dictionary objectForKey:@"ForwardingSource"] isEqual:[NSNull null]]) {
            TweetItem *retweetedItem = [[TweetItem alloc] initWithDictionary:[dictionary objectForKey:@"ForwardingSource"]];
            [retweetedItem setValue:@"标题" forKey:@"tweetTitle"];
            self.reTweetItem = retweetedItem;
        }
    }
    return self;
}


@end
