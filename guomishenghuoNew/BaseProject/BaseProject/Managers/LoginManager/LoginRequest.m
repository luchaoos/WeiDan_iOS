//
//  LoginRequest.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/13.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "LoginRequest.h"

#define LoginEntry   @"Login.asmx/Entry"

@implementation LoginRequest
-(void)registerByPhone:(NSString *)phone andPassword:(NSString *)password
{
    if (phone && password) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginEntry];
        
        NSString *json = [self setParam:@[@"phone",
                                          @"password",
                                          @"type",
                                          @"function"]
                              andResult:@[phone,
                                          password,
                                          @"0",
                                          @"Register"]];
        
        NSDictionary * prm=@{@"args":json};
        DLog(@"%@",prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)loginByAccount:(NSString *)username andPassword:(NSString *)password
{
    if (username && password) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginEntry];
        
        NSString *json = [self setParam:@[@"username",
                                          @"password",
                                          @"function"]
                              andResult:@[username,
                                          password,
                                          @"Log"]];
        
        NSDictionary * prm=@{@"args":json};
        DLog(@"%@",prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
    
}

-(void)resetPassWord:(NSString *)member_username andPassWord:(NSString *)member_password
{
    if (member_username && member_password) {
        

    }else{
        [SVProgressHUD dismiss];
    }
}


-(void)resetPassWordByold:(NSString *)member_password andAccount:(NSString *)member_username andNewPassWord:(NSString *)member_new_password
{
    if (member_username && member_password && member_new_password) {
        
        
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)resetPassWordByPhone:(NSString *)phone andNewpassword:(NSString *)newpassword
{
    if (phone && newpassword) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginEntry];
        
        NSString *json = [self setParam:@[@"id",
                                          @"newpassword",
                                          @"function"]
                              andResult:@[phone,
                                          newpassword,
                                          @"ChangePassword"]];
        
        NSDictionary * prm=@{@"args":json};
        DLog(@"%@",prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)LoginFastByPhone:(NSString *)phone
{
    if (phone) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LoginEntry];
        
        NSString *json = [self setParam:@[@"phone",
                                          @"function"]
                              andResult:@[phone,
                                          @"LogFast"]];
        
        NSDictionary * prm=@{@"args":json};
        DLog(@"%@",prm);
        [self postRequst:url andPrm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

@end
