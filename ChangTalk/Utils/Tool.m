//
//  Tool.m
//  ChangTalk
//
//  Created by ctkj on 14-4-24.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "Tool.h"

@implementation Tool


+ (CGFloat)getAdapterHeight {
    CGFloat adapterHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        adapterHeight = 64;
    }
    return adapterHeight;
}
                                                                                                        
@end
