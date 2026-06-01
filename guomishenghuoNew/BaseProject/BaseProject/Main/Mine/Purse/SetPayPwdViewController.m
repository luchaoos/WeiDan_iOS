//
//  SetPayPwdViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/5/11.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "SetPayPwdViewController.h"
#import "TXTradePasswordView.h"
//#import "MainRequest.h"
#import "ProjectTools.h"
#import "ForgetPayPWDViewController.h"
#import "DataProviderOther.h"

@interface SetPayPwdViewController ()<TXTradePasswordViewDelegate>

@end

@implementation SetPayPwdViewController
{
    TXTradePasswordView *TXView;
    TXTradePasswordView *TXView1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"fanhui"];
    if ([get_sp(havePayPassword) integerValue]==1) {
    [self addRightbuttontitle:@"忘记密码"];
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
    if ([get_sp(havePayPassword) integerValue]==1) {
        _lblTitle.text = @"修改支付密码";
        TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, 100,SCREEN_WIDTH, 200) WithTitle:@"请输入旧支付密码"];
    }
    else{
        _lblTitle.text=@"设置支付密码";
        TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, 100,SCREEN_WIDTH, 200) WithTitle:@"请输入支付密码"];
    }
    TXView.tag=1;
    TXView.TXTradePasswordDelegate = self;
    if (![TXView.TF becomeFirstResponder])
    {
        //成为第一响应者。弹出键盘
        [TXView.TF becomeFirstResponder];
    }
    
    
    [self.view addSubview:TXView];
}

-(void)clickLeftButton:(UIButton *)sender
{
    if (self.isreaister) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickRightButton:(UIButton *)sender
{
    if ([get_sp(havePayPassword) integerValue]==1) {
    ForgetPayPWDViewController * forgetPayVC=[[ForgetPayPWDViewController alloc] init];
    [self.navigationController pushViewController:forgetPayVC animated:YES];
    }
}
#pragma mark  密码输入结束后调用此方法
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password
{
    NSLog(@"密码 = %@",Password);
    
    
    if ([view isEqual:TXView]) {
        if ([get_sp(havePayPassword) integerValue]==1) {
            DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
            [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"VerifyPWDCallBack:" setFailBackFunctionName:nil];
            [mainrequest CheckPayPasswordWithpaypassword:Password];
            return;
        }
        else{
            [TXView removeFromSuperview];
            TXView1 = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, 100,SCREEN_WIDTH, 200) WithTitle:@"请再次输入支付密码"];
        }
        TXView1.tag=2;
        TXView1.TXTradePasswordDelegate = self;
        if (![TXView1.TF becomeFirstResponder])
        {
            //成为第一响应者。弹出键盘
            [TXView1.TF becomeFirstResponder];
        }
        [self.view addSubview:TXView1];
    }
    else
    {
        DataProvider *dataProvider = [[DataProvider alloc] init];
        
        if (!([get_sp(havePayPassword) integerValue]==1)) {
            if (![TXView.TF.text isEqualToString:TXView1.TF.text]) {
                [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
                return;
            }
            NSLog(@"%@",[Toolkit getUserDefaultByKey:isLogin]);
            [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"setPWDCallBack:" setFailBackFunctionName:nil];
            [dataProvider setPayPasswordWithId:[Toolkit getUserDefaultByKey:user_ID] paypassword:TXView1.TF.text];
        }
        else{
            [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"changePWDCallBack:" setFailBackFunctionName:nil];
            [dataProvider changePayPasswordWithId:[Toolkit getUserDefaultByKey:user_ID] oldpaypassword:TXView.TF.text newpaypassword:TXView1.TF.text];
        }
    }
}
-(void)VerifyPWDCallBack:(id)dict
{
       //    [YJXStatusHUD hideLoading];
    if (RequestSuccess(dict)) {
        //        [YJXStatusHUD showLoading:@"正在获取支付信息..."];
        if ([dict[@"data"][@"Result"] intValue]==0) {
            [YJXStatusHUD showError:@"支付密码验证失败,支付取消"];
            return;
        }
         [TXView removeFromSuperview];
        TXView1 = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, 100,SCREEN_WIDTH, 200) WithTitle:@"请输入新支付密码"];
        TXView1.tag=2;
        TXView1.TXTradePasswordDelegate = self;
        if (![TXView1.TF becomeFirstResponder])
        {
            //成为第一响应者。弹出键盘
            [TXView1.TF becomeFirstResponder];
        }
        [self.view addSubview:TXView1];
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}
-(void)setPWDCallBack:(id)dict
{
    NSLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        if (self.isRoot) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView1" object:nil];
//            return
        }
        [SVProgressHUD showSuccessWithStatus:@"密码保存成功"];
        [Toolkit setUserDefaultWithObject:@"1" forKey:havePayPassword];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}

-(void)changePWDCallBack:(id)dict
{
    NSLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//        [Toolkit setUserDefaultWithObject:@"YES" forKey:havePayPassword];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
