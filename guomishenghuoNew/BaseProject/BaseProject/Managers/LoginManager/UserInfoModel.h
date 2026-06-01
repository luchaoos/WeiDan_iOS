//
//  UserInfoModel.h
//  YiShengDaoJia
//
//  Created by Wangjc on 16/4/28.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property(nonatomic) NSString *userName;//昵称
@property(nonatomic) NSString *userAccount;//账户
@property(nonatomic) NSString *userId;
@property(nonatomic) NSString *userAddr;
@property(nonatomic) NSString *userHeadImg;

+(instancetype)UserInfoWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
