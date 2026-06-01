//
//  YJXStatusHUD.m
//  YJYYStatusHUD
//
//  Created by 于金祥 on 16/4/20.
//  Copyright © 2016年 yuanyang.com. All rights reserved.
//

#import "YJXStatusHUD.h"
#import "YJYYStatusHUD.h"

@implementation YJXStatusHUD

+(void)showError:(NSString *)msg
{
    [YJYYStatusHUD showError:msg];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [YJYYStatusHUD hideLoading];
    });
    
}


+(void)showLoading:(NSString *)msg
{
    [YJYYStatusHUD showLoading:msg];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [YJYYStatusHUD hideLoading];
//    });
}

+(void)hideLoading
{
    [YJYYStatusHUD hideLoading];
}

+(void)showMessage:(NSString *)msg image:(UIImage *)image
{
    [YJYYStatusHUD showMessage:msg image:image];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [YJYYStatusHUD hideLoading];
    });
}

+(void)showMessage:(NSString *)msg imageName:(NSString *)imageName
{
    [YJYYStatusHUD showMessage:msg imageName:imageName];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [YJYYStatusHUD hideLoading];
    });
}

+(void)showSuccess:(NSString *)msg
{
    [YJYYStatusHUD showSuccess:msg];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [YJYYStatusHUD hideLoading];
    });
}

@end
