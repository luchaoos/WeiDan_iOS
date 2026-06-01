//
//  ForgetPWDViewController.m
//  BaseProject
//
//  Created by 于金祥 on 2016/12/9.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ForgetPWDViewController.h"
#import "LeftView.h"
#import <SMS_SDK/SMSSDK.h>

@interface ForgetPWDViewController ()
@property (assign, nonatomic)BOOL status;
@property (nonatomic, strong)LeftView *leftView;
@property (nonatomic, strong)UIButton *leftBtn;
@end

@implementation ForgetPWDViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _status = YES;
    
    _lblTitle.text=@"忘记密码";
    [self btnView];
    [self botView];
}
- (void)btnView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 15)];
    [self.view addSubview:view];
    view.backgroundColor = RGB(235, 236, 241);
    
    _leftView = [[LeftView alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:view Direction:@"Y"], SCREEN_WIDTH, 240)];
    [self.view addSubview:_leftView];
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
   
        [SMSSDK commitVerificationCode:_leftView.verification.text
                           phoneNumber:_leftView.phoneField.text
                                  zone:@"86"
                                result:^(NSError *error) {
                                    if (!error) {
                                        
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
                                        
                                        
                                        DataProvider *dataProvider = [[DataProvider alloc] init];
                                        [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"verifyCodeCallBack:" setFailBackFunctionName:nil];
                                        
                                        [dataProvider changePasswordByVerifyCodeWithId:_leftView.phoneField.text newpassword:_leftView.code1.text];
                                    }
                                    else{
                                        NSLog(@"验证失败");
                                        [SVProgressHUD dismiss];
                                        NSRange  range=[[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]] rangeOfString:@"验证码错误"];
                                        if (range.length>0) {
                                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                                            message:@"验证码已失效请重新发送"
                                                                                           delegate:self
                                                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                                                  otherButtonTitles:nil, nil];
                                            [alert show];
                                        }
                                        else
                                        {
                                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                                            message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                                                           delegate:self
                                                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                                                  otherButtonTitles:nil, nil];
                                            [alert show];
                                            
                                        }
                                        
                                    }
                                }];
   }
-(void)verifyCodeCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
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
