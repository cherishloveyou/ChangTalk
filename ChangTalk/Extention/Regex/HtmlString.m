//
//  HtmlString.m
//  TEST_16
//
//  Created by apple on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HtmlString.h"
#import <Foundation/NSObjCRuntime.h>
#import "NSString+UrlEncode.h"
#import "RegexKitLite.h"

@implementation HtmlString

+ (NSString *)transformString:(NSString *)originalStr
{
    NSString *text = originalStr;
    
    //解析http://短链接
    NSString *regex_http = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";//http://短链接正则表达式
    NSArray *array_http = [text componentsMatchedByRegex:regex_http];
    
    if ([array_http count]) {
        for (NSString *str in array_http) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, str.length) withString:funUrlStr];
        }
    }

    //解析@
    NSString* regex_at = @"@[\\u4e00-\\u9fa5\\w\\-]+";//@的正则表达式
    NSArray* matches_at = [text componentsMatchedByRegex:regex_at];
    if ([matches_at count]) {
        NSMutableArray *test_arr = [[NSMutableArray alloc] init];
        for (NSString *str in matches_at) {
            NSRange range = [text rangeOfString:str];
            if (![test_arr containsObject:str]) {
                [test_arr addObject:str];
                NSString* funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",[str urlEncode], str];
                //NSString* funUrlStr = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",str,str];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
            }
        }
        [test_arr release];
    }
    
    
//    //解析&
//    NSString *regex_dot = @"\\$\\*?[\u4e00-\u9fa5|a-zA-Z|\\d]{2,8}(\\((SH|SZ)?\\d+\\))?";//&的正则表达式
//    NSArray *array_dot = [text componentsMatchedByRegex:regex_dot];
//    if ([array_dot count]) {
//        NSMutableArray *test_arr = [[NSMutableArray alloc] init];
//        for (NSString *str in array_dot) {
//            NSRange range = [text rangeOfString:str];
//            if (![test_arr containsObject:str]) {
//                [test_arr addObject:str];
//                NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
//                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
//            }
//        }
//        [test_arr release];
//    }

    //解析话题
    NSString *regex_pound = @"#([^\\#|.]+)#";//话题的正则表达式
    NSArray *array_pound = [text componentsMatchedByRegex:regex_pound];
    
    //  #/哈哈/#
    if ([array_pound count]) {
        for (NSString *str in array_pound) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",[str urlEncode], str];
            //NSString *funUrlStr = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",str, str];
//            
//            NSString* regex_emoji = @"\\/[a-zA-Z0-9\u4e00-\u9fa5]+\\/";//表情的正则表达式
//            NSArray* array_emoji = [str componentsMatchedByRegex:regex_emoji];
//            
//            NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"EmotionIconKeys.plist"];
//            NSDictionary* m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
//            
//            if ([array_emoji count]) {
//                for (NSString *emojistr in array_emoji) {
//                    NSRange range = [text rangeOfString:emojistr];
//                    for(id key in m_EmojiDic) {
//                        if ([[m_EmojiDic objectForKey:key]isEqual:emojistr]) {
//                            
//                        }
//                }
//            }
//            [m_EmojiDic release];
            
                
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
        }
    }

    //解析表情
    //NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\]";//表情的正则表达式
    NSString* regex_emoji = @"\\/[a-zA-Z0-9\u4e00-\u9fa5]+\\/";//表情的正则表达式
    NSArray* array_emoji = [text componentsMatchedByRegex:regex_emoji];

    NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"EmotionIconKeys.plist"];
    NSDictionary* m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];

    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            
//            //得到词典中所有Value值
//            NSEnumerator * enumeratorKey = [m_EmojiDic keyEnumerator];
//            //快速枚举遍历所有Value的值
//            for (NSObject *object in enumeratorKey) {
//            }
             for(id key in m_EmojiDic) {
                 if ([[m_EmojiDic objectForKey:key]isEqual:str]) {
                    NSString *imageHtml = [NSString stringWithFormat:@"<img src =%@>", key];
                    text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:[imageHtml stringByAppendingString:@" "]];
                 }
             }
//            NSString *transCharacter = [m_EmojiDic objectForKey:str];
//            if (transCharacter) {
//                //NSString *imageHtml = [NSString stringWithFormat:@"<img src = 'file://%@/%@' width='12' height='12'>", path, i_transCharacter];
//                NSString *imageHtml = [NSString stringWithFormat:@"<img src =%@>", transCharacter];
//                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:[imageHtml stringByAppendingString:@" "]];
//            }
        }
    }
    [m_EmojiDic release];
    //返回转义后的字符串
    return [text stringByReplacingOccurrencesOfString:@"查看详情</a>" withString:@""];
}



+ (NSString*) parseToHtmlString:(NSString*) text {
    
    NSString* regex = @"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
    //    NSString* regex = @"(@\\w+)|(#\\w+#)|(http(s)?://[\\w+./]+)";
    //    NSString* target = [text stringByReplacingOccurrencesOfRegex:regex withString:@"<a href='$0'>$0</a>"];
    NSArray* matches = [text componentsMatchedByRegex:regex];
    for (NSString* match in matches) {
        NSString* replacement = nil;
        if ([match hasPrefix:@"@"]) {
            replacement = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>", [match urlEncode], match];
        }else if([match hasPrefix:@"#"] && [match hasSuffix:@"#"]){
            replacement = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>", [match urlEncode], match];
        }else if([match hasPrefix:@"http"]){
            replacement = [NSString stringWithFormat:@"<a href='%@'>%@</a>", match, match];
        }
        
        if (replacement != nil) { //防止报错
            text = [text stringByReplacingOccurrencesOfString:match withString:replacement];
        }
    }
    
    return text;
}

@end
