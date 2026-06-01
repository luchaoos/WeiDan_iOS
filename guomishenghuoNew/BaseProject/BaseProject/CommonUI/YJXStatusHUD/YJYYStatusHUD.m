//
//  YJYYStatusHUD.m
//  YJYYStatusHUD
//
//  Created by 远洋 on 15/12/25.
//  Copyright © 2015年 yuanyang.com. All rights reserved.
//

#import "YJYYStatusHUD.h"

// 窗口的高度
#define kWindowHeight 20

// 动画的执行时间
#define kDuration 0.85

// 窗口的停留时间
#define kDelay 1.25

// 文字字体
#define kTitleFont [UIFont systemFontOfSize:13]

//屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

//设置一个全局的window 因为类方法中无法掉self.window  下划线的目的是为了区分
UIWindow * _window;

@implementation YJYYStatusHUD


+(void)showSuccess:(NSString *)msg
{
    [self showMessage:msg imageName:@"YJYYStatusHUD.bundle/success"];
}


//传入图片 和 文字
+(void)showMessage:(NSString *)msg image:(UIImage *)image
{
    //防止用于多次调用 几个方法
    if (_window) return;
        
    //新建一个button //下面代码相当于alloc  init
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //设置button的文字
    [btn setTitle:msg forState:UIControlStateNormal];
    
    //设置btn的文字大小
    btn.titleLabel.font = kTitleFont;
    
    //设置button的图片
    [btn setImage:image forState:UIControlStateNormal];
    
    //设置button内部的label和imageView的间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    //默认刚开始让window在屏幕外侧
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(0, -kWindowHeight,kScreenWidth , kWindowHeight)];
    
    //设置_window的背景颜色
    _window.backgroundColor = [UIColor blackColor];
    
    //设置window级别 为最高级别
    _window.windowLevel = UIWindowLevelAlert;
    
    //设置btn的frame
    btn.frame = _window.bounds;
    
    //将btn添加到window上
    [_window addSubview:btn];
    
    //让window显示
    _window.hidden = NO;
    
    //以动画的形式 从屏幕外让window显示出来
    [UIView animateWithDuration:kDuration animations:^{
        //取出window的frame
        CGRect rect = _window.frame;
        
        rect.origin.y = 0;
        
        _window.frame = rect;
        
    } completion:^(BOOL finished) {
        //在显示完成以后 嵌套一个延时的动画
        [UIView animateWithDuration:kDuration delay:kDelay options:kNilOptions animations:^{
            //
            CGRect rect = _window.frame;
            
            rect.origin.y = -kWindowHeight;
            
            _window.frame = rect;
            
        } completion:^(BOOL finished) {
            //显示完毕后 让window销毁
            _window = nil;
        }];
    }];

}


+(void)showMessage:(NSString *)msg imageName:(NSString *)imageName{

    [self showMessage:msg image:[UIImage imageNamed:imageName]];
}



+(void)showError:(NSString *)msg
{
    [self showMessage:msg imageName:@"YJYYStatusHUD.bundle/error"];

}




+(void)showLoading:(NSString *)msg
{
    if (_window) return;

    //默认刚开始让window在屏幕外侧
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(0, -kWindowHeight,kScreenWidth , kWindowHeight)];
    
    //添加一个label到_window上
    UILabel * msgLabel = [[UILabel alloc]init];
    
    msgLabel.frame = _window.bounds;
    
    msgLabel.text = msg;
    
    //设置文字颜色
    msgLabel.textColor = [UIColor whiteColor];
    
    //设置label文字居中
    msgLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置文字大小
    msgLabel.font = [UIFont systemFontOfSize:14];
    
    //添加到_window上
    [_window addSubview:msgLabel];
    
    //添加一个菊花到界面上
    UIActivityIndicatorView  * indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    indicatorView.frame = CGRectMake(80, 0, kWindowHeight, kWindowHeight);
    
    //添加到_window上
    [_window addSubview:indicatorView];
    
    [indicatorView startAnimating];

    
    //设置_window的背景颜色
    _window.backgroundColor = [UIColor blackColor];
    
    //设置window级别 为最高级别
    _window.windowLevel = UIWindowLevelAlert;
    
    //让window显示
    _window.hidden = NO;
    
    //动画的形式让_window从屏幕外侧进入屏幕
    [UIView animateWithDuration:kDuration animations:^{
        
        CGRect rect =  _window.frame;
        
        rect.origin.y = 0;
        
        _window.frame = rect;
    }];
}

+(void)hideLoading
{
    [UIView animateWithDuration:kDuration delay:0 options:kNilOptions animations:^{
        
        CGRect rect =  _window.frame;
        
        rect.origin.y = -kWindowHeight;
        
        _window.frame = rect;
        
    } completion:^(BOOL finished) {
        
        _window = nil;
    }];
}

@end
