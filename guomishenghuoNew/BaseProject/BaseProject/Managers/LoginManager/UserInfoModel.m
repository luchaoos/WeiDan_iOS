//
//  UserInfoModel.m
//  YiShengDaoJia
//
//  Created by Wangjc on 16/4/28.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel


+(instancetype)UserInfoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        @try {
            
            self.userAccount = [Toolkit judgeIsNull:dict[@"Phone"]];
            self.userName = [Toolkit judgeIsNull:dict[@"UserName"]];
            self.userId = [Toolkit judgeIsNull:dict[@"Id"]];
            self.userHeadImg = [Toolkit judgeIsNull:dict[@"PhotoPath"]];
            self.userAddr = @"";
            
        }
        @catch (NSException *exception) {
            
        }
        @finally{
        
        }
    }
    
    return self;
}

/*
 * 自定义的对象 无法直接写入到userdefault中 需要转化为 nsdata 这时需要实现下面两个方法
 */
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.userName forKey:@"userName"];
    [coder encodeObject:self.userId forKey:@"userId"];
    [coder encodeObject:self.userAddr forKey:@"userAddr"];
    [coder encodeObject:self.userAccount forKey:@"userAccount"];
    [coder encodeObject:self.userHeadImg forKey:@"userHeadImg"];
}


-(instancetype)initWithCoder:(NSCoder *)coder
{
    self.userName = [[coder decodeObjectForKey:@"userName"] copy];
    self.userId = [[coder decodeObjectForKey:@"userId"] copy];
    self.userAddr = [[coder decodeObjectForKey:@"userAddr"] copy];
    self.userAccount = [[coder decodeObjectForKey:@"userAccount"] copy];
    self.userHeadImg = [[coder decodeObjectForKey:@"userHeadImg"] copy];
    
    return self;
}

@end
