//
//  AppDelegate.h
//  BaseProject
//
//  Created by Wangjc on 16/6/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)showTabBar;
- (void)hiddenTabBar;

@end

