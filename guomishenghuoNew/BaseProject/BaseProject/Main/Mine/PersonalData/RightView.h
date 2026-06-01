//
//  RightView.h
//  BaseProject
//
//  Created by 刘顺 on 16/10/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightView : UIView<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *oldCode;
@property (nonatomic, strong)UITextField *code;
@property (nonatomic, strong)UITextField *anewCode;
@end
