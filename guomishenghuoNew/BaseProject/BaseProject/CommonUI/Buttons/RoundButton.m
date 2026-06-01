//
//  RoundButton.m
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.myTintColor = [UIColor lightGrayColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return self;
}

-(void)setMyTintColor:(UIColor *)myTintColor
{
    _myTintColor = myTintColor;
    
    self.layer.borderColor = [_myTintColor CGColor];
    self.backgroundColor = _myTintColor;
//    [self setTitleColor:_myTintColor forState:UIControlStateNormal];
}

@end
