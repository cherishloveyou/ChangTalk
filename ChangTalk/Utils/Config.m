//
//  Config.m
//  ctkj
//
//  Created by wangjun on 14-3-25.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "Config.h"
#import "AESCrypt.h"

@implementation Config

static Config * instance = nil;

+ (Config *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"UserName"];
    [setting removeObjectForKey:@"Password"];
    [setting setObject:userName forKey:@"UserName"];
    
    pwd = [AESCrypt encrypt:pwd password:@"pwd"];
    
    [setting setObject:pwd forKey:@"Password"];
    [setting synchronize];
}

- (void)saveUID:(int)uid
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"UID"];
    [setting setObject:[NSString stringWithFormat:@"%d", uid] forKey:@"UID"];
    [setting synchronize];
}

- (NSString *)getUserName
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"UserName"];
}

- (NSString *)getUserPwd
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * temp = [settings objectForKey:@"Password"];
    return [AESCrypt decrypt:temp password:@"pwd"];
}

- (int)getUID
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *value = [setting objectForKey:@"UID"];
    if (value && [value isEqualToString:@""] == NO) 
    {
        return [value intValue];
    }else{
        return 0;
    }
}

- (void)saveLoginCookie:(NSString*)cookie
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"Cookie"];
    [setting setObject:cookie forKey:@"Cookie"];
    [setting synchronize];
}

- (NSString*)getLoginCookie
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:@"Cookie"];
}

- (void)savePushNotice:(BOOL)isNotice
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"isNotice"];
    [settings setObject:isNotice ? @"1" : @"0" forKey:@"isNotice"];
    [settings synchronize];
}

- (BOOL)isPushNotice
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * value = [settings objectForKey:@"isNotice"];
    return value && [value isEqualToString:@"1"];
}

- (NSString *)getIOSGuid
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * value = [settings objectForKey:@"guid"];
    if (value && [value isEqualToString:@""] == NO) {
        return value;
    }else{
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString * uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);
        [settings setObject:uuidString forKey:@"guid"];
        [settings synchronize];
        return uuidString;
    }
}

@end
