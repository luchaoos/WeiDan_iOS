//
//  ModifyViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ModifyViewController.h"
#import "LeftView.h"
#import "RightView.h"
#import <SMS_SDK/SMSSDK.h>

@interface ModifyViewController ()
@property (assign, nonatomic)BOOL status;
@property (nonatomic, strong)LeftView *leftView;
@property (nonatomic, strong)RightView *rightView;
@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic, strong)UIButton *rightBtn;
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _status = YES;
    
    
    [self btnView];
    [self botView];
}
- (void)btnView{
    _leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _leftBtn.frame = CGRectMake(0, 64, SCREEN_WIDTH/2, 50);
    [self.view addSubview:_leftBtn];
    [_leftBtn setTitle:@"通过短信验证" forState:UIControlStateNormal];
    _leftBtn.tintColor = [UIColor orangeColor];
    _leftBtn.backgroundColor = [UIColor whiteColor];
    _leftBtn.tag = 115;
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [_leftBtn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _rightBtn.frame = CGRectMake(SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2, 50);
    [self.view addSubview:_rightBtn];
    [_rightBtn setTitle:@"通过旧密码" forState:UIControlStateNormal];
    _rightBtn.tintColor = [UIColor blackColor];
    _rightBtn.backgroundColor = [UIColor whiteColor];
    _rightBtn.tag = 116;
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [_rightBtn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64+50, SCREEN_WIDTH, 15)];
    [self.view addSubview:view];
    view.backgroundColor = RGB(235, 236, 241);
    
    _leftView = [[LeftView alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:view Direction:@"Y"], SCREEN_WIDTH, 240)];
    [self.view addSubview:_leftView];
    _rightView = [[RightView alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:view Direction:@"Y"], SCREEN_WIDTH, 240)];
    [self.view addSubview:_rightView];
    _rightView.hidden = YES;
}
- (void)changePage:(UIButton *)btn{
    if (btn.tag == 115) {
        if (!_status) {
            btn.tintColor = [UIColor orangeColor];
            _rightBtn.tintColor = [UIColor blackColor];
            [_rightView.oldCode resignFirstResponder];
            [_rightView.code resignFirstResponder];
            [_rightView.anewCode resignFirstResponder];
            _rightView.hidden = YES;
            _leftView.hidden = NO;
            _status = !_status;
        }
    }else if (btn.tag == 116){
        if (_status) {
            btn.tintColor = [UIColor orangeColor];
            _leftBtn.tintColor = [UIColor blackColor];
            [_leftView.phoneField resignFirstResponder];
            [_leftView.verification resignFirstResponder];
            [_leftView.code1 resignFirstResponder];
            [_leftView.code2 resignFirstResponder];
            _leftView.hidden = YES;
            _rightView.hidden = NO;
            _status = !_status;
        }
        
    }
}
- (void)botView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:_leftView Direction:@"Y"], SCREEN_WIDTH, SCREEN_HEIGHT-[Util ReturnViewFrame:_leftView Direction:@"Y"])];
    [self.view addSubview:view];
    view.backgroundColor = RGB(235, 235, 241);
    
    UIButton *confimBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confimBtn.frame = CGRectMake(20, 40, SCREEN_WIDTH-40, 50);
    confimBtn.backgroundColor = [UIColor orangeColor];
    [confimBtn setTitle:@"确认" forState:UIControlStateNormal];
    confimBtn.titleLabel.font = [UIFont systemFontOfSize:19.0];
    confimBtn.tintColor = [UIColor whiteColor];
    [confimBtn addTarget:self action:@selector(confimClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confimBtn];
}
- (void)confimClick{
    if (_status) {//如果是左边
//        NSLog(@"===左=%@===", _leftView.phoneField.text);
//        NSLog(@"====%@===", _rightView.oldCode.text);
        if ([_leftView.phoneField.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号！"];
            return;
        }
        if ([_leftView.verification.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入收到的验证码！"];
            return;
        }
        if ([_leftView.code1.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码！"];
            return;
        }
        if ([_leftView.code2.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入确认密码！"];
            return;
        }
        if (![_rightView.code.text isEqualToString:_rightView.anewCode.text]) {
            [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致！"];
            return;
        }
        
        
        
        if ([_leftView.randomNumber isEqualToString:_leftView.verification.text]) {
            [SVProgressHUD showWithStatus:@"验证码验证通过,正在注册..." maskType:SVProgressHUDMaskTypeBlack];
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"verifyCodeCallBack:" setFailBackFunctionName:nil];
            [dataProvider changePasswordByVerifyCodeWithId:_leftView.phoneField.text newpassword:_leftView.code1.text];
        }
        else
        {
            [SVProgressHUD dismiss];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                            message:@"验证失败，请重新输入"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
        
        
//        [SMSSDK commitVerificationCode:_leftView.verification.text
//                           phoneNumber:_leftView.phoneField.text
//                                  zone:@"86"
//                                result:^(NSError *error) {
//                                    if (!error) {
//                                        
//                                        
//                                        
//                                        
//                                    }
//                                    else{
//                                        NSLog(@"验证失败");
//                                        [SVProgressHUD dismiss];
//                                        NSRange  range=[[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]] rangeOfString:@"验证码错误"];
//                                        if (range.length>0) {
//                                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
//                                                                                            message:@"验证码已失效请重新发送"
//                                                                                           delegate:self
//                                                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                                                                  otherButtonTitles:nil, nil];
//                                            [alert show];
//                                        }
//                                        else
//                                        {
//                                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
//                                                                                            message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
//                                                                                           delegate:self
//                                                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                                                                  otherButtonTitles:nil, nil];
//                                            [alert show];
//                                        }
//                                        
//                                    }
//                                }];
    }else{
//        NSLog(@"===右=%@===", _rightView.oldCode.text);
//        NSLog(@"====%@===", _leftView.phoneField.text);
        if ([_rightView.oldCode.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入旧密码！"];
            return;
        }
        if ([_rightView.code.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入新密码！"];
            return;
        }
        if ([_rightView.anewCode.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入确认密码！"];
            return;
        }
        if (![_rightView.code.text isEqualToString:_rightView.anewCode.text]) {
            [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致！"];
            return;
        }
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"changePasswordCallBack:" setFailBackFunctionName:nil];
        //    NSLog(@"%@",[Toolkit getUserDefaultByKey:user_ID]);
        [dataProvider changePasswordWithId:get_sp(@"Phone") oldpassword:_rightView.oldCode.text newpassword:_rightView.code.text];
    }
}
-(void)verifyCodeCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
}
-(void)changePasswordCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
