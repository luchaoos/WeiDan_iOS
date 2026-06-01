//
//  BoundPhoneViewController.m
//  BaseProject
//
//  Created by 于金祥 on 17/3/9.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "BoundPhoneViewController.h"
#import "LeftView.h"
#import <SMS_SDK/SMSSDK.h>


@interface BoundPhoneViewController ()
@property (nonatomic, strong)LeftView *leftView;
@end

@implementation BoundPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lblTitle.text=@"绑定手机号";
    _leftView = [[LeftView alloc]initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 120)];
    [self.view addSubview:_leftView];
    _leftView.code1.hidden=YES;
    _leftView.code2.hidden=YES;
    _leftView.code.hidden=YES;
    _leftView.confirm.hidden=YES;
    
    
    UIButton *confimBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confimBtn.frame = CGRectMake(20, CGRectGetMaxY(_leftView.frame)+20, SCREEN_WIDTH-40, 50);
    confimBtn.backgroundColor = [UIColor orangeColor];
    [confimBtn setTitle:@"确认" forState:UIControlStateNormal];
    confimBtn.titleLabel.font = [UIFont systemFontOfSize:19.0];
    confimBtn.tintColor = [UIColor whiteColor];
    [confimBtn addTarget:self action:@selector(confimClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confimBtn];
}
- (void)confimClick{
    
    if ([_leftView.phoneField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号！"];
        return;
    }
    if ([_leftView.verification.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入收到的验证码！"];
        return;
    }
    
    if ([_leftView.randomNumber isEqualToString:_leftView.verification.text]) {
        [SVProgressHUD showWithStatus:@"验证码验证通过,正在注册..." maskType:SVProgressHUDMaskTypeBlack];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"verifyCodeCallBack:" setFailBackFunctionName:nil];
        //                                        [dataProvider changePasswordByVerifyCodeWithId:_leftView.phoneField.text newpassword:_leftView.code1.text];
        [dataProvider BoundPhoneWithopenid:get_sp(@"openid") andphone:_leftView.phoneField.text];
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
//                                        DataProvider *dataProvider = [[DataProvider alloc] init];
//                                        [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"verifyCodeCallBack:" setFailBackFunctionName:nil];
////                                        [dataProvider changePasswordByVerifyCodeWithId:_leftView.phoneField.text newpassword:_leftView.code1.text];
//                                        [dataProvider BoundPhoneWithopenid:get_sp(@"openid") andphone:_leftView.phoneField.text];
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
//   
////        DataProvider *dataProvider = [[DataProvider alloc] init];
////        [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"changePasswordCallBack:" setFailBackFunctionName:nil];
//        //    NSLog(@"%@",[Toolkit getUserDefaultByKey:user_ID]);
////        [dataProvider changePasswordWithId:get_sp(@"Phone") oldpassword:_rightView.oldCode.text newpassword:_rightView.code.text];
    
}
-(void)verifyCodeCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"绑定成功"];
        set_sp(@"Phone", _leftView.phoneField.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
