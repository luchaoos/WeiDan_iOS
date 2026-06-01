//
//  GrayView.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/12.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "GrayView.h"


@implementation GrayView

- (instancetype)initWithFrame:(CGRect)frame currentCity:(NSString *)cityName recentlyCity:(NSMutableArray *)recentlyArr historyCity:(NSMutableArray *)historyArr andNum:(NSInteger)num{
    self = [super initWithFrame:frame];
    if (self) {
        
        _number = num;
        _recentlyArr = [NSMutableArray arrayWithArray:recentlyArr];

        _historyArr = [NSMutableArray arrayWithArray:historyArr];
    

        NSInteger line2 = (_recentlyArr.count-1)/3 +1;
        NSInteger line3 = (_historyArr.count-1)/3+1;
        
        
        //灰色部分,当前定位.最近访问
        self.backgroundColor = RGB(236, 236, 236);
        CustomLabel *label1 = [[CustomLabel alloc]initWithFrame:CGRectMake(10, 0, 150, 30) withContent:@"当前定位城市" font:16.0 andRGBr:189 RGBg:189 RGBb:190 adaptive:NO];
        [self addSubview:label1];
        
        _currentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _currentBtn.frame = CGRectMake(10, [Util ReturnViewFrame:label1 Direction:@"Y"], 65, 25);
        [_currentBtn setTitle:cityName forState:UIControlStateNormal];
        _currentBtn.tintColor = [UIColor lightGrayColor];
        _currentBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_currentBtn];
        [Util makeBorderWidthForView:_currentBtn];

        CustomLabel *label2 = [[CustomLabel alloc]initWithFrame:CGRectMake(10, [Util ReturnViewFrame:_currentBtn Direction:@"Y"]+10, 150, 30) withContent:@"最近访问的城市" font:16.0 andRGBr:189 RGBg:189 RGBb:190 adaptive:NO];
        [self addSubview:label2];
        [self creatBtnWithLine:line2 arr:_recentlyArr forView:label2 andTag:num];
        
        CustomLabel *lab2el3 = [[CustomLabel alloc]initWithFrame:CGRectMake(10, (30+10)*2+(line2+1)*(25+5), 150, 30) withContent:@"最近访问的城市" font:16.0 andRGBr:189 RGBg:189 RGBb:190 adaptive:NO];
        [self creatBtnWithLine:line3 arr:_historyArr forView:lab2el3 andTag:num+_recentlyArr.count];
        [self addSubview:lab2el3];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityName:) name:@"onlyYou" object:nil];
        
    }
    return self;
}
- (void)cityName:(NSNotification *)notification{
    [_currentBtn setTitle:[notification.userInfo objectForKey:@"city"] forState:UIControlStateNormal];
}
- (void)creatBtnWithLine:(NSInteger)line arr:(NSMutableArray *)numArr forView:(UIView *)view andTag:(NSInteger)tag{
    for (int i = 0; i < line; i++) {
        if (i == line-1) {
            for (int j = 0; j < numArr.count - 3*(line - 1); j++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                btn.frame = CGRectMake(10+j*((SCREEN_WIDTH - 20 - 3*65)/2+65), [Util ReturnViewFrame:view Direction:@"Y"]+5+i*(25+5), 65, 25);
                btn.tag = 3*i+j+50+tag;
                btn.backgroundColor = [UIColor whiteColor];
                btn.tintColor = RGB(105, 105, 105);
                [self addSubview:btn];
                [Util makeBorderWidthForView:btn];
                [btn.titleLabel sizeToFit];
                [btn addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            for (int j = 0; j < 3; j++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                btn.frame = CGRectMake(10+j*((SCREEN_WIDTH - 20 - 3*65)/2+65), [Util ReturnViewFrame:view Direction:@"Y"]+5+i*(25+5), 65, 25);
                btn.tag = 3*i+j+50+tag;
                btn.tintColor = RGB(105, 105, 105);
                [self addSubview:btn];
                [Util makeBorderWidthForView:btn];
                [btn.titleLabel sizeToFit];
                btn.backgroundColor = [UIColor whiteColor];
                [btn addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }

    for (int i = 0; i< _recentlyArr.count; i++) {
        UIButton *btn = [self viewWithTag:i+50+_number];
        [btn setTitle:_recentlyArr[i] forState:UIControlStateNormal];
    }
    for (int i = 0; i< _historyArr.count; i++) {
        UIButton *btn = [self viewWithTag:i+50+_recentlyArr.count+_number];
        [btn setTitle:_historyArr[i] forState:UIControlStateNormal];
    }
}
- (void)chooseCity:(UIButton *)btn{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_recentlyArr];
    [tempArr addObjectsFromArray:_historyArr];
    
    NSLog(@"%ld", btn.tag);
    
    [_currentBtn setTitle:tempArr[btn.tag-50-_number] forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(grayClicl:)]) {
        [self.delegate grayClicl:btn];
    }
    [tempArr removeAllObjects];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:@"onlyYou"];
}
@end
