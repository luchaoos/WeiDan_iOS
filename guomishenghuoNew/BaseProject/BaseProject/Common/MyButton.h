//
//  MyButton.h
//  自定义btn
//
//  Created by MS on 15-10-9.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>



@class MyButton;

typedef void(^myButtonBlock)(MyButton *myButton);

@interface MyButton : UIButton
+ (MyButton *)buttonWithType:(UIButtonType)type frame:(CGRect)frame title:(NSString *)title  andBlock:(myButtonBlock)block;
@end
