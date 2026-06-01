//
//  BottomView.m
//  Grade
//
//  Created by 刘顺 on 16/10/13.
//  Copyright © 2016年 LiuShun. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGB(235, 235, 241);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:btn];
        
        btn.frame = CGRectMake(10, 15, self.frame.size.width-20, 35);
        btn.backgroundColor = [UIColor orangeColor];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        btn.tintColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)btnClick{
    if ([self.delegate respondsToSelector:@selector(commit)]) {
        [self.delegate commit];
    }
}
@end
