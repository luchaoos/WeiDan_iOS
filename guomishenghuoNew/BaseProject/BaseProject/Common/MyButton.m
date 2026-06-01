//
//  MyButton.m
//  自定义btn
//
//  Created by MS on 15-10-9.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "MyButton.h"

@interface MyButton ()

@property (nonatomic, copy)myButtonBlock tempBlock;
@end

@implementation MyButton



+ (MyButton *)buttonWithType:(UIButtonType)type frame:(CGRect)frame title:(NSString *)title andBlock:(myButtonBlock)block
{
    MyButton *btn = [MyButton buttonWithType:type];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:btn action:@selector(blockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)blockButtonClick:(MyButton *)btn{
    _tempBlock(btn);
}







@end
