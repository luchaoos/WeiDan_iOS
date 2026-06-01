//
//  PullView.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PullView.h"


@implementation PullView

- (instancetype)initWithFrame:(CGRect)frame withCurrentCity:(NSString *)city andCityArr:(NSMutableArray *)arr{
    self = [super initWithFrame:frame ];
    if (self) {
        
        _recentlyArr = [NSMutableArray arrayWithArray:@[@"临沂", @"临沂", @"临沂", @"临沂", @"临沂", @"临沂", @"临沂"]];
        _historyArr = [NSMutableArray arrayWithArray:@[@"临沂", @"临沂", @"临沂", @"临沂", @"临沂", @"呼和浩特", @"临沂"]];
        
        self.backgroundColor = [UIColor whiteColor];
        _cityArr = [NSMutableArray arrayWithArray:arr];
        _currentCity = [[CustomLabel alloc]initWithFrame:CGRectMake(10, 0, 150, 30) withContent:city font:16.0 andRGBr:105 RGBg:105 RGBb:105 adaptive:NO];
        [self addSubview:_currentCity];
        
        _chooseCity = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:_chooseCity];
        [_chooseCity makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_currentCity);
            make.right.mas_equalTo(-5);
            make.width.height.equalTo(_currentCity);
        }];
        _chooseCity.tintColor = [UIColor lightGrayColor];
        [_chooseCity setTitle:@"选择县区  ∨" forState:UIControlStateNormal];
        [_chooseCity addTarget:self action:@selector(startPullView) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}
// 下拉
- (void)startPullView{
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect newFrame = self.frame;
        // 选择城市
        if (newFrame.size.height == 30) {
            NSInteger line1 = (_cityArr.count - 1)/3+1;
//            NSInteger line2 = (_recentlyArr.count-1)/3 +1;
//            NSInteger line3 = (_historyArr.count-1)/3+1;
//        
            newFrame.size.height = 30+10 + (25+5)*line1;
            [self creatBtnWithLine:line1 arr:_cityArr forView:_currentCity superView:self andTag:0];
            
            
            //灰色部分,当前定位.最近访问
//            UIView *midView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 30+(25+5)*line1+10, SCREEN_WIDTH, 30+10+25)];
//            [self addSubview:midView1];
//            midView1.tag = 105;
//            midView1.backgroundColor = RGB(236, 236, 236);
//            CustomLabel *label1 = [[CustomLabel alloc]initWithFrame:CGRectMake(10, 0, 150, 30) withContent:@"当前定位城市" font:16.0 andRGBr:189 RGBg:189 RGBb:190];
//            [midView1 addSubview:label1];
//            
//            _currentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//            _currentBtn.frame = CGRectMake(10, [Util ReturnViewFrame:label1 Direction:@"Y"], 65, 25);
//            [_currentBtn setTitle:@"临沂" forState:UIControlStateNormal];
//            _currentBtn.tag = _cityArr.count+50;
            
//            [_currentBtn addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
//            _currentBtn.tintColor = [UIColor lightGrayColor];
//            [midView1 addSubview:_currentBtn];
//            [Util makeBorderWidthForView:_currentBtn];
//
//            
//            
//            UIView *midView2 = [[UIView alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:midView1 Direction:@"Y"], SCREEN_WIDTH, (25+5)*line2+30+10)];
//            [self addSubview:midView2];
//            midView2.tag = 106;
//            midView2.backgroundColor = RGB(236, 236, 236);
//            
//            CustomLabel *label2 = [[CustomLabel alloc]initWithFrame:CGRectMake(10, 0, 150, 30) withContent:@"最近访问的城市" font:16.0 andRGBr:189 RGBg:189 RGBb:190];
//            [midView2 addSubview:label2];
//            [self creatBtnWithLine:line2 arr:_recentlyArr forView:label2 superView:midView2 andTag:_cityArr.count+1];
//
//            UIView *midView3 = [[UIView alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:midView2 Direction:@"Y"], SCREEN_WIDTH, (25+5)*line2+30+10)];
//            [self addSubview:midView3];
//            midView3.tag = 106;
//            midView3.backgroundColor = RGB(236, 236, 236);
//            
//            CustomLabel *lab2el3 = [[CustomLabel alloc]initWithFrame:CGRectMake(10, 0, 150, 30) withContent:@"最近访问的城市" font:16.0 andRGBr:189 RGBg:189 RGBb:190];
//            [midView3 addSubview:lab2el3];
//            [self creatBtnWithLine:line3 arr:_historyArr forView:lab2el3 superView:midView3 andTag:_cityArr.count+_recentlyArr.count+1];
            
        }else{
            newFrame.size.height = 30;
            for (int i = 0; i < _cityArr.count; i++) {
                UIButton *btn = [self viewWithTag:i+50];
                [btn removeFromSuperview];
//                UIView *view1 = [self viewWithTag:105];
//                [view1 removeFromSuperview];
//                UIView *view2 = [self viewWithTag:106];
//                [view2 removeFromSuperview];
//                UIView *view3 = [self viewWithTag:107];
//                [view3 removeFromSuperview];
            }
            
        }
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    
    [self.delegate pickCityClick];
}
- (void)creatBtnWithLine:(NSInteger)line arr:(NSMutableArray *)numArr forView:(UIView *)view superView:(UIView *)superView andTag:(NSInteger)tag{
    for (int i = 0; i < line; i++) {
        if (i == line-1) {
            for (int j = 0; j < numArr.count - 3*(line - 1); j++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                btn.frame = CGRectMake(10+j*((SCREEN_WIDTH - 20 - 3*65)/2+65), [Util ReturnViewFrame:view Direction:@"Y"]+5+i*(25+5), 65, 25);
                btn.tag = 3*i+j+50+tag;
                
                btn.tintColor = RGB(105, 105, 105);
                [superView addSubview:btn];
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
                [superView addSubview:btn];
                [Util makeBorderWidthForView:btn];
                [btn.titleLabel sizeToFit];
                [btn addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
            }
        }

    }
    for (int i = 0; i < _cityArr.count; i++) {
        UIButton *btn = [self viewWithTag:i+50];
        [btn setTitle:_cityArr[i] forState:UIControlStateNormal];
    }

}
- (void)chooseCity:(UIButton *)btn{
    NSMutableArray *tempArr = [NSMutableArray array];
    [tempArr addObjectsFromArray:_cityArr];

    [_currentBtn setTitle:[NSString stringWithFormat:@"%@", tempArr[btn.tag - 50]] forState:UIControlStateNormal];
    
    // 发送通知
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:tempArr[btn.tag-50], @"city", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"onlyYou" object:nil userInfo:dict];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect newFrame = self.frame;
        newFrame.size.height = 30;
        self.frame = newFrame;
    }];
    
    for (int i = 0; i < _cityArr.count; i++) {
        UIButton *btn = [self viewWithTag:i+50];
        [btn removeFromSuperview];
    }
    [self.delegate pickCity:btn];
}

@end
