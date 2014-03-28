//
//  NewsItem.m
//  ChangTalk
//
//  Created by ctkj on 14-3-28.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "NewsItem.h"

#define kAPI_NEWSPIC(site) [NSString stringWithFormat:@"http://photoshow.tc108.org:814%@",site]


@implementation NewsItem

- (id)initWithParameters:(int)nID
                andTitle:(NSString *)nTitle
                  andUrl:(NSString *)nImgUrl
              andPubDate:(double)nPubDate
         andCommentCount:(int)nCommentCount
{
    NewsItem *item = [[NewsItem alloc] init];
    item.newsID = nID;
    item.newsTitle = nTitle;
    item.newsImageUrl = nImgUrl;
    item.publishDate = nPubDate;
    item.commentCount = nCommentCount;
    return item;
}


- (NSString*)getNewsImage:(NSString*)imageField
{
    //\d+,([^,|]+),\d+/g
    NSString* str = @"11874,/user/2014/0325/201403250105070676250.thumb.jpg,0|22444,/user/2014/0325/201403250105070676250.thumb.jpg,1";
    
    NSLog(@"string:%@",str);
    NSArray *array = [imageField componentsSeparatedByString:@"|"];
    NSArray *result = [array [0] componentsSeparatedByString:@","];
    
    return kAPI_NEWSPIC(result[1]);
    
//    //regexTest
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+,([^,|]+),\\d+" options:NSRegularExpressionCaseInsensitive error:nil];
//    
//    NSArray *arrayTest = nil;
//    arrayTest = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
//    NSString *str1 = nil;
//    for (NSTextCheckingResult* b in arrayTest)
//    {
//        str1 = [str substringWithRange:b.range];
//        NSLog(@" str 1 is %@",str1);
//    }
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {

        self.newsID = [[dictionary objectForKey:@"ID"] integerValue];
        self.newsTitle = [dictionary objectForKey:@"Title"];
        self.newsContent = [dictionary objectForKey:@"Content"];
        self.publishDate = [[dictionary objectForKey:@"PublishUnixTime"] doubleValue];
        self.commentCount = [[dictionary objectForKey:@"CommentCount"] integerValue];
        
        id image = [dictionary objectForKey:@"ImagesField"];
        if ((NSNull *)image != [NSNull null]) {
        
            self.newsImageUrl = [self getNewsImage:image];
        }
    }
    return self;
}

@end
