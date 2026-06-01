//
//  ForgetPayPWDViewController.m
//  BaseProject
//
//  Created by 于金祥 on 2017/1/3.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "ForgetPayPWDViewController.h"

@interface ForgetPayPWDViewController ()
@property (assign, nonatomic)BOOL status;
@property (nonatomic, strong)LeftView *leftView;
@property (nonatomic, strong)UIButton *leftBtn;
@end

@implementation ForgetPayPWDViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _status = YES;
    
    _lblTitle.text=@"重置支付密码";
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
                                    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"setPWDCallBack:" setFailBackFunctionName:nil];
                                    [dataProvider setPayPasswordWithId:[Toolkit getUserDefaultByKey:user_ID] paypassword:_leftView.code1.text];
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

-(void)setPWDCallBack:(id)dict
{
    NSLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        [SVProgressHUD showSuccessWithStatus:@"支付密码重置成功"];
        [Toolkit setUserDefaultWithObject:@"1" forKey:havePayPassword];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
