//
//  PorjectTools.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/13.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "ProjectTools.h"
#import "UserInfoModel.h"
#import "APPDefaultManager.h"

@implementation ProjectTools
#pragma mark - 项目相关的方法

+(void)setUserInfo:(UserInfoModel *)model
{
    
    NSData *tempData = [NSKeyedArchiver archivedDataWithRootObject:model];
    [APPDefaultManager setDefaultByKey:USERINFO_KEY andObject:tempData];
}


+(UserInfoModel *)getUserInfo
{
    NSData *tempData = [APPDefaultManager getDefaultByKey:USERINFO_KEY];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
}

+(NSString *)getUserID
{
    return [ProjectTools getUserInfo].userId;
}

+(BOOL)islogin
{
    
    NSString *str = [APPDefaultManager getDefaultByKey:Login_key];
    if ([Toolkit checkNetworkState] == NetworkStatusUnAvaliable) {
        
        return NO;
    }
    if ([str isEqualToString:@"YES"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
