//
//  LoginManager.m
//  YiShengDaoJia
//
//  Created by Wangjc on 16/5/2.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "LoginManager.h"
#import "LoginRequest.h"
#import "APPDefaultManager.h"
#import "UserInfoModel.h"

@interface  LoginManager()
{
    
}


@property(nonatomic) NSMutableArray *accountList;//登录历史,暂不实现
@end

@implementation LoginManager
+(void)loginWithAccount:(NSString *)account andPassWord:(NSString *)passWord andDelegate:(nullable id/*<loginManagerDelegate>*/)delegate
{
    LoginManager *manager = [[self alloc] initWithAccount:account andPassWord:passWord];
    manager.delegate = delegate;
    [manager login];
}

+(void)quicklyLoginWithAccount:(NSString *)account andDelegate:(nullable id/*<loginManagerDelegate>*/)delegate
{
    LoginManager *manager = [[self alloc] initWithAccount:account andPassWord:nil];
    manager.delegate = delegate;
    [manager quicklyLogin];
}



+(BOOL)CheckloginWithPresent:(nullable UIViewController *)vc{
    
    NSString *str = [APPDefaultManager getDefaultByKey:Login_key];
    if ([Toolkit checkNetworkState] == NetworkStatusUnAvaliable) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        [APPDefaultManager setDefaultByKey:Login_key andObject:@"NO"];
        return NO;
    }
    if ([str isEqualToString:@"YES"]) {
        return YES;
    }
    else
    {
        //可实现此处 检测到未登录直接跳转登录页
//        if (vc !=nil) {
//            LoginViewController *loginViewCtl = [[LoginViewController alloc] init];
//            
//            [vc presentViewController:loginViewCtl animated:YES completion:^{
//                
//            }];
//        }
        
        return NO;
    }
}
+(BOOL)CheckLoginOnly
{
    NSString *str = [APPDefaultManager getDefaultByKey:Login_key];
    if ([str isEqualToString:@"YES"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(void)CheckloginAndRetry
{
    
    NSString *str = [APPDefaultManager getDefaultByKey:Login_key];
    if ([Toolkit checkNetworkState] == NetworkStatusUnAvaliable) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        [APPDefaultManager setDefaultByKey:Login_key andObject:@"NO"];
        return;
    }
    if ([str isEqualToString:@"YES"]) {
        return;
    }
    else
    {
        [[self alloc] tryLogin];
    }
}


-(instancetype)initWithAccount:(NSString *)account andPassWord:(NSString *)passWord
{
    self = [super init];
    if (self) {
        self.account = account;
        self.password = passWord;
    }
    
    return self;
}



-(void)tryLogin
{
    self.account = [APPDefaultManager getDefaultByKey:Login_Accout];
    self.password = [APPDefaultManager getDefaultByKey:Login_PassWord];
    
    if (self.account ==nil || self.password == nil || self.account.length == 0|| self.password == 0) {
        
        [APPDefaultManager setDefaultByKey:Login_key andObject:@"NO"];
//        [SVProgressHUD showErrorWithStatus:@"登录失败"];
        
    }
    else
    {
        [self login];
    }
    
}

-(void)login
{
    LoginRequest *request = [[LoginRequest alloc] init];
    [request setDelegateObject:self setSucceedBackFunctionName:@"loginCallBack:" setFailBackFunctionName:nil];
    [request loginByAccount:self.account andPassword:self.password];
    
}

-(void)quicklyLogin
{
    LoginRequest *request = [[LoginRequest alloc] init];
    [request setDelegateObject:self setSucceedBackFunctionName:@"loginCallBack:" setFailBackFunctionName:nil];
    [request LoginFastByPhone:self.account];
}

-(void)loginCallBack:(NSDictionary *)dict
{
    ELog(dict);
    
    if (RequestSuccess(dict)) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [self setUserInfoWith:dict[@"data"]];//保存登陆信息
        [self saveAccountInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:NoticeKeyLoginSuccess object:nil];

        
        if ([self.delegate respondsToSelector:@selector(loginManager:LoginSuccess:)]) {
            [self.delegate loginManager:self LoginSuccess:dict];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    }
}

-(void)saveAccountInfo//保存登录信息
{
    [APPDefaultManager setDefaultByKey:Login_key andObject:@"YES"];//设置是否已登陆
    [APPDefaultManager setDefaultByKey:Login_Accout andObject:self.account];//本次登陆的用户名和密码
    [APPDefaultManager setDefaultByKey:Login_PassWord andObject:self.password];
 
}

+(void)clearAccountInfo
{
    [APPDefaultManager removeDefaultByKey:Login_key];
    [APPDefaultManager removeDefaultByKey:Login_Accout];
    [APPDefaultManager removeDefaultByKey:Login_PassWord];
}

-(void)setUserInfoWith:(NSDictionary *)dict//保存用户信息
{
    UserInfoModel *mode = [UserInfoModel UserInfoWithDict:dict];
    [ProjectTools setUserInfo:mode];
}


#pragma mark - delegate
-(NSMutableArray *)accountList
{
    if (!_accountList) {
        _accountList = [NSMutableArray array];
        [_accountList addObjectsFromArray:[APPDefaultManager getDefaultByKey:LoginHistory]];
    }
    
    return _accountList;
}


@end
