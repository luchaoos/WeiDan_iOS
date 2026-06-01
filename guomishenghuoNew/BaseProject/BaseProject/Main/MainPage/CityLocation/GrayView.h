//
//  GrayView.h
//  BaseProject
//
//  Created by 刘顺 on 16/10/12.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrayViewDelegate <NSObject>

- (void)grayClicl:(UIButton *)btn;

@end

@interface GrayView : UIView

@property (nonatomic, strong)id<GrayViewDelegate>delegate;
@property (nonatomic, strong)NSMutableArray *recentlyArr;
@property (nonatomic, strong)NSMutableArray *historyArr;
@property (nonatomic, strong)UIButton *currentBtn;
@property (nonatomic, assign)NSInteger number;

- (instancetype)initWithFrame:(CGRect)frame currentCity:(NSString *)cityName recentlyCity:(NSMutableArray *)recentlyArr historyCity:(NSMutableArray *)historyArr andNum:(NSInteger)num;
@end
