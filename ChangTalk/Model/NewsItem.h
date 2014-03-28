//
//  NewsItem.h
//  ChangTalk
//
//  Created by ctkj on 14-3-28.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (nonatomic, assign)NSInteger newsID;
@property (nonatomic, copy)NSString* newsTitle;
@property (nonatomic, copy)NSString* newsContent;
@property (nonatomic, copy)NSString* newsImageUrl;
@property (nonatomic, assign)double publishDate;
@property (nonatomic, assign)NSInteger commentCount;

- (id)initWithParameters:(int)nID
                andTitle:(NSString *)nTitle
                  andUrl:(NSString *)nImgUrl
              andPubDate:(double)nPubDate
         andCommentCount:(int)nCommentCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
