//
//  UIView+GetChainViewController.m
//  WeiboDemo1
//
//  Created by leo.zhu on 14-1-17.
//  Copyright (c) 2014年 3k. All rights reserved.
//

#import "UIView+GetChainViewController.h"

@implementation UIView (GetChainViewController)

- (UIViewController*)viewController {

    UIResponder* responder = [self nextResponder];
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)responder;
        }
        
        responder = [responder nextResponder];
    } while (responder != nil);
    
    return nil;
}

@end
