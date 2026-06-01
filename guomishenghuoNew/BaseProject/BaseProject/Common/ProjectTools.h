//
//  PorjectTools.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/13.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface ProjectTools : NSObject
+(void)setUserInfo:(UserInfoModel *)model;
+(UserInfoModel *)getUserInfo;
+(NSString *)getUserID;
+(BOOL)islogin;
@end
