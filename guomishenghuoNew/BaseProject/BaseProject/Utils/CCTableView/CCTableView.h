//
//  CCTableView.h
//  CCdoubleTableView
//
//  Created by 陈程 on 15/6/2.
//  Copyright (c) 2015年 陈程. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>

@interface CCTableView : UIView
@property (nonatomic,strong) NSArray  *dataArray;
@end
