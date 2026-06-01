//
//  LoginManager.h
//  YiShengDaoJia
//
//  Created by Wangjc on 16/5/2.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LoginManager;
@protocol loginManagerDelegate <NSObject>
-(void)loginManager:(LoginManager *)manager LoginSuccess:(NSDictionary *)dict;
@end

@interface LoginManager : NSObject
@property(nonatomic) NSString *account;
@property(nonatomic) NSString *password;
@property(nonatomic) id<loginManagerDelegate> delegate;

//登录通过手机号和密码
+(void)loginWithAccount:(NSString *)account andPassWord:(NSString *)passWord andDelegate:(nullable id/*<loginManagerDelegate>*/)delegate;
//快速登录 只使用手机号和验证码
+(void)quicklyLoginWithAccount:(nonnull NSString *)account andDelegate:(nullable id/*<loginManagerDelegate>*/)delegate;
//检查登录并弹出登陆页面
+(BOOL)CheckloginWithPresent:(nullable UIViewController *)vc;
//检查是否登录并重试
+(void)CheckloginAndRetry;
//单纯的检查是否是登录状态
+(BOOL)CheckLoginOnly;
//清除账号信息
+(void)clearAccountInfo;
@end
