//
//  YJYYStatusHUD.h
//  YJYYStatusHUD
//
//  Created by 远洋 on 15/12/25.
//  Copyright © 2015年 yuanyang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYYStatusHUD : NSObject

/**
 *  显示信息
 *
 *  @param msg   信息
 *  @param image 图片
 */
+ (void)showMessage:(NSString *)msg image:(UIImage *)image;

/**
 *  显示信息
 *
 *  @param msg   信息
 *  @param imageName 图片(图片高度最好在20以内, 仅限于本地图片)
 */
+ (void)showMessage:(NSString *)msg imageName:(NSString *)imageName;

/**
 *  显示成功信息
 *
 *  @param msg 信息
 */
+ (void)showSuccess:(NSString *)msg; //NS_DEPRECATED_IOS(2_0, 3_0, "请使用xxxx方法");

/**
 *  显示失败信息
 *
 *  @param msg 信息
 */
+ (void)showError:(NSString *)msg;

/**
 *  显示加载信息
 *
 *  @param msg 信息
 */
+ (void)showLoading:(NSString *)msg;

/**
 *  隐藏加载信息
 */
+ (void)hideLoading;
@end
