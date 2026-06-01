//
//  LeftView.h
//  BaseProject
//
//  Created by 刘顺 on 16/10/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftView : UIView<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *phoneField;
@property (nonatomic, strong)UITextField *verification;
@property (nonatomic, strong)UILabel *code;
@property (nonatomic, strong)UITextField *code1;
@property (nonatomic, strong)UILabel *confirm;
@property (nonatomic, strong)UITextField *code2;
@property (nonatomic, strong)NSString *randomNumber;
@end
