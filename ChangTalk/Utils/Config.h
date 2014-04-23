//
//  Config.h
//  ctkj
//
//  Created by ctkj on 14-3-25.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

//是否已经登录
@property BOOL isLogin;
//是否具备网络链接
@property BOOL isNetworking;

//保存登录用户名以及密码
- (void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd;

- (NSString *)getUserName;

- (NSString *)getUserPwd;

- (void)saveUID:(int)uid;

- (int)getUID;

- (void)saveLoginCookie:(NSString*)cookie;

- (NSString *)getLoginCookie;

- (NSString *)getIOSGuid;

+ (Config *) Instance;

+ (id)allocWithZone:(NSZone *)zone;

@end
