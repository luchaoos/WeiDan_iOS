//
//  UserDefaultKeys.h
//  YiShengDaoJia
//
//  Created by Wangjc on 16/4/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>


#define USERINFO_KEY    @"userInfo"//用户信息
#define Login_key       @"isLogin"//是否登陆

//上次登陆的用户名和密码
#define Login_Accout    @"account_login"
#define Login_PassWord  @"account_passWord"
#define LoginHistory    @"accountList"

@interface APPDefaultManager : NSObject
//设置default
+(void)setDefaultByKey:( NSString * __nonnull )key andObject:(__nonnull id)obj;
//获取default
+(nullable id )getDefaultByKey:( NSString * __nonnull )key;
//删除default key
+(void)removeDefaultByKey:( NSString * __nonnull )key;

@end
