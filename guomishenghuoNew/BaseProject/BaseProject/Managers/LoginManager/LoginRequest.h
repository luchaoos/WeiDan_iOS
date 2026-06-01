//
//  LoginRequest.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/13.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "BaseRequest.h"


@interface LoginRequest : BaseRequest
//注册
-(void)registerByPhone:(NSString *)phone andPassword:(NSString *)password;
//登录
-(void)loginByAccount:(NSString *)member_username andPassword:(NSString *)member_password;
//重置密码
-(void)resetPassWord:(NSString *)member_username andPassWord:(NSString *)member_password;
//更改密码通过旧密码
-(void)resetPassWordByold:(NSString *)member_password andAccount:(NSString *)member_username andNewPassWord:(NSString *)member_new_password;
//更改密码通过手机号
-(void)resetPassWordByPhone:(NSString *)phone andNewpassword:(NSString *)newpassword;
//快速登录
-(void)LoginFastByPhone:(NSString *)phone;
@end
