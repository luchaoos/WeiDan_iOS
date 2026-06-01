//
//  RightView.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "RightView.h"

@implementation RightView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews{
    //横线
    for (int i=0; i<2; i++) {
        DrawLine *line = [[DrawLine alloc]initWithFrame:CGRectMake(20, 80*(i+1), SCREEN_WIDTH, 1)];
        [self addSubview:line];
    }
    //竖线
    for (int i = 0; i<3; i++) {
        DrawLine *line = [[DrawLine alloc]initWithFrame:CGRectMake(95, 15+80*i, 1, 50)];
        [self addSubview:line];
    }
    //界面
    UILabel *oldLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 25, 60, 30)];
    [self addSubview:oldLabel];
    oldLabel.text = @"旧密码";
    oldLabel.textColor = RGB(16, 16, 16);
    oldLabel.textAlignment = NSTextAlignmentRight;
    
    _oldCode = [UITextField new];
    _oldCode.delegate = self;
    [self addSubview:_oldCode];
    _oldCode.placeholder = @"请输入旧密码";
    [_oldCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldLabel.mas_right).offset(30);
        make.top.height.equalTo(oldLabel);
        make.width.mas_equalTo(200);
    }];
    
    
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 25+80, 60, 30)];
    [self addSubview:newLabel];
    newLabel.text = @"新密码";
    newLabel.textColor = RGB(16, 16, 16);
    newLabel.textAlignment = NSTextAlignmentRight;
    
    _code = [UITextField new];
    _code.delegate = self;
    [self addSubview:_code];
    _code.placeholder = @"请输入密码";
    [_code makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(_oldCode);
        make.top.equalTo(newLabel);
    }];
    
    
    UILabel *anewLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25+160, 80, 30)];
    [self addSubview:anewLabel];
    anewLabel.text = @"再次输入";
    anewLabel.textColor = RGB(16, 16, 16);
    anewLabel.textAlignment = NSTextAlignmentRight;
    
    _anewCode = [UITextField new];
    _anewCode.delegate = self;
    [self addSubview:_anewCode];
    _anewCode.placeholder = @"请再次输入密码";
    [_anewCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(_oldCode);
        make.top.equalTo(anewLabel);
    }];
}
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
