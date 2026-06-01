//
//  PullView.h
//  BaseProject
//
//  Created by 刘顺 on 16/10/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullViewDelegate <NSObject>

- (void)pickCity:(UIButton *)btn;
- (void)pickCityClick;

@end
@interface PullView : UIView
{
    UILabel *_currentCity;
    UIButton *_chooseCity;
    
    NSString *_curCity;
    NSMutableArray *_recentlyArr;
    NSMutableArray *_historyArr;
    UIButton *_currentBtn;
}
@property (nonatomic, weak)id<PullViewDelegate>delegate;
@property (nonatomic, strong)NSMutableArray *cityArr;

- (instancetype)initWithFrame:(CGRect)frame withCurrentCity:(NSString *)city andCityArr:(NSMutableArray *)arr;
@end

