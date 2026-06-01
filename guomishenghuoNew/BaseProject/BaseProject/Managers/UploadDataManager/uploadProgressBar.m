//
//  uploadProgressBar.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/7/20.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "uploadProgressBar.h"

#define Viewheight 35

@interface uploadProgressBar ()
@property(nonatomic) UIView *rateLineView;
@property(nonatomic) UIView *rateView;

@end

@implementation uploadProgressBar

-(void)layoutSubviews
{
    self.rateLineView.frame = CGRectMake(15, (Viewheight - 5)/2, self.bounds.size.width - 35 - 40, 5);
    self.rateLineView.layer.cornerRadius = _rateLineView.frame.size.height/2;
    self.rateLineView.layer.masksToBounds = YES;
    
    
    self.cancelBtn.frame = CGRectMake(CGRectGetMaxX(self.rateLineView.frame)+10, 0, 40, Viewheight);
}


-(instancetype)init
{
    if (self = [super init]) {
        
        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, Viewheight);
        self.backgroundColor = [UIColor lightGrayColor];
    
        [self addSubview:self.cancelBtn];
        [self addSubview:self.rateLineView];
        self.rateView.frame = CGRectMake(0, 0,0 , self.rateLineView.bounds.size.height);
        [self.rateLineView addSubview:self.rateView];
        
        self.alpha = 0.8;

    }
    
    return self;
}

-(void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.rateView.backgroundColor = tintColor;
    [self.cancelBtn setTitleColor:tintColor forState:UIControlStateNormal];
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _rateView.frame = CGRectMake(0, 0, progress * self.rateLineView.frame.size.width,self.rateLineView.bounds.size.height );
}
-(UIButton *)cancelBtn
{
    if (_cancelBtn == nil) {
        
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    
    return _cancelBtn;
}

-(UIView *)rateView
{
    if (_rateView == nil) {
        _rateView = [[UIView alloc] init];
        _rateView.backgroundColor = [UIColor greenColor];
    }
    
    return _rateView;
}

-(UIView *)rateLineView
{
    if (_rateLineView == nil) {
        _rateLineView = [[UIView alloc] init];
        _rateLineView.backgroundColor = [UIColor grayColor];
        
    }
    
    return _rateLineView;
}


@end
