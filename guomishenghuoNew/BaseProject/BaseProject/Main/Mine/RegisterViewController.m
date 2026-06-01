//
//  RegisterViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/5/9.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "DataProvider.h"
#import "SetPayPwdViewController.h"
#import "SecriteViewController.h"
#import "DataProviderOther.h"

@interface RegisterViewController ()
{
    UIButton * btn_sendVifyCode;
    NSTimer *timer;
    unsigned int resendTime;
    NSString *randomNumber;
}
@end

@implementation RegisterViewController
{
    UIView * firstView;
    UIView * secondView;
    UITextField * txt_Phone;
    UITextField * txt_VerifyCode;
    UITextField * txt_Phone2;
    UITextField * txt_PWD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"注册";
    [self addLeftButton:@"fanhui"];
    self.tapGesture.enabled=YES;
    // 生成 "000000-999999" 6位验证码
    int num = (arc4random() % 1000000);
    randomNumber = [NSString stringWithFormat:@"%.6d", num];
//    NSLog(@"%@", randomNumber);
    
    [self BuildTextView];
    [self BuildLoginButton];
}

-(void)BuildTextView
{
    firstView=[[UIView alloc] initWithFrame:CGRectMake(10, 74, SCREEN_WIDTH-20, 88*2)];
    firstView.backgroundColor=[UIColor whiteColor];
    firstView.layer.masksToBounds=YES;
    firstView.layer.cornerRadius=8;
    txt_Phone=[[UITextField alloc] initWithFrame:CGRectMake(10, 0, firstView.frame.size.width-20, 40)];
    txt_Phone.placeholder=@" 请输入您的手机号";
    txt_Phone.font = [UIFont systemFontOfSize:15];
    txt_Phone.leftViewMode = UITextFieldViewModeAlways;
    txt_Phone.rightViewMode= UITextFieldViewModeAlways;
    UIView * V_phone_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    UILabel * lbl_phone_left=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    lbl_phone_left.text=@"手机号";
    [V_phone_left addSubview:lbl_phone_left];
    
    txt_Phone.leftView=V_phone_left;
    [firstView addSubview:txt_Phone];
    
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(txt_Phone.frame), txt_Phone.frame.size.width, 1)];
    fenge.backgroundColor=[UIColor lightGrayColor];
    [firstView addSubview:fenge];
    
    txt_VerifyCode=[[UITextField alloc] initWithFrame:CGRectMake(txt_Phone.frame.origin.x, CGRectGetMaxY(fenge.frame), txt_Phone.frame.size.width, 43)];
    txt_VerifyCode.placeholder=@" 请输入您收到的验证码";
    txt_VerifyCode.font = [UIFont systemFontOfSize:15];
    txt_VerifyCode.leftViewMode = UITextFieldViewModeAlways;
    txt_VerifyCode.rightViewMode = UITextFieldViewModeAlways;
    btn_sendVifyCode=[[UIButton alloc] init];
    btn_sendVifyCode.frame=CGRectMake(SCREEN_WIDTH-115, 7, 100, 30);
//    btn_sendVifyCode.backgroundColor=AppMainColor;
    btn_sendVifyCode.layer.masksToBounds=YES;
    btn_sendVifyCode.layer.cornerRadius=5;
    btn_sendVifyCode.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_sendVifyCode addTarget:self action:@selector(authBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn_sendVifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btn_sendVifyCode setTitleColor:AppMainColor forState:UIControlStateNormal];
    UIView * V_shuxian=[[UIView alloc] initWithFrame:CGRectMake(0, 5, 1, 35)];
    V_shuxian.backgroundColor=AppMainColor;
    [btn_sendVifyCode addSubview:V_shuxian];
    txt_VerifyCode.rightView=btn_sendVifyCode;
    [firstView addSubview:txt_VerifyCode];
    
    UIView * fenge2=[[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(txt_VerifyCode.frame), txt_Phone.frame.size.width, 1)];
    fenge2.backgroundColor=[UIColor lightGrayColor];
    [firstView addSubview:fenge2];
    
//    txt_Phone2=[[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(fenge.frame), SCREEN_WIDTH-30, 40)];
    txt_Phone2=[[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(fenge2.frame), SCREEN_WIDTH-30, 40)];
    txt_Phone2.placeholder=@" 请输入您的密码";
    txt_Phone2.font = [UIFont systemFontOfSize:15];
    txt_Phone2.leftViewMode = UITextFieldViewModeAlways;
    txt_Phone2.secureTextEntry=YES;
    UIView * V_phone2_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    UILabel * lbl_phone2_left=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    lbl_phone2_left.text=@"密码";
    [V_phone2_left addSubview:lbl_phone2_left];
    txt_Phone2.leftView=V_phone2_left;
    [firstView addSubview:txt_Phone2];
    
    UIView * fenge1=[[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(txt_Phone2.frame), txt_Phone2.frame.size.width, 1)];
    fenge1.backgroundColor=[UIColor lightGrayColor];
    [firstView addSubview:fenge1];
    
    txt_PWD=[[UITextField alloc] initWithFrame:CGRectMake(txt_Phone2.frame.origin.x, CGRectGetMaxY(fenge1.frame), txt_Phone2.frame.size.width, 43)];
    txt_PWD.placeholder=@" 请输入您的密码";
    txt_PWD.font = [UIFont systemFontOfSize:15];
    txt_PWD.secureTextEntry=YES;
    txt_PWD.leftViewMode = UITextFieldViewModeAlways;
    [firstView addSubview:txt_PWD];
    UIView * V_pwd_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
    UILabel * lbl_pwd_left=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
    lbl_pwd_left.text=@"确认密码";
    [V_pwd_left addSubview:lbl_pwd_left];
    
    txt_PWD.leftView=V_pwd_left;
    [self.view addSubview:firstView];
    
    
}
-(void)btn_secritClick
{
    SecriteViewController *_mysecriteVC=[[SecriteViewController alloc] initWithNibName:@"SecriteViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_mysecriteVC animated:YES];
}
-(void)BuildLoginButton
{
    UIView * lastView=[self.view.subviews lastObject];
    UIButton * btn_login=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lastView.frame)+20, SCREEN_WIDTH-60, 44)];
    btn_login.backgroundColor=AppMainColor;
    [btn_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_login setTitle:@"确定" forState:UIControlStateNormal];
    [btn_login addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_login];
    
    
    UILabel * lbl_secrit=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxX(btn_login.frame)+30, 170, 15)];
    lbl_secrit.text=@"点击确定表示您已完成阅读";
    lbl_secrit.textColor=[UIColor blackColor];
    lbl_secrit.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:lbl_secrit];
    UIButton * btn_secrit=[[UIButton alloc] initWithFrame:CGRectMake(lbl_secrit.frame.origin.x+lbl_secrit.frame.size.width, lbl_secrit.frame.origin.y, 60, 15)];
    [btn_secrit setTitle:@"隐私政策" forState:UIControlStateNormal];
    [btn_secrit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn_secrit.titleLabel.font=[UIFont systemFontOfSize:13];
    [btn_secrit addTarget:self action:@selector(btn_secritClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_secrit];
    
}

#pragma mark - actions


-(void)timeFunction
{
    
    UIButton  *tempBtn = btn_sendVifyCode;
    [tempBtn setTitle:[NSString stringWithFormat:@"(%ds)后重发",resendTime] forState:UIControlStateNormal];
    tempBtn.enabled= NO;
    if(resendTime > 0)
    {
        resendTime --;
    }
    else
    {
        [timer setFireDate:[NSDate distantFuture]];
        [tempBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        tempBtn.enabled= YES;
    }
}

-(void)authBtnClick:(UIButton *)sender
{
    
//    [SVProgressHUD showWithStatus:@"正在发送验证码..." maskType:SVProgressHUDMaskTypeBlack];
    if (txt_Phone.text.length==11) {
        ELog(txt_Phone.text);
//        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:txt_Phone.text
//                                       zone:@"86"
//                           customIdentifier:nil
//                                     result:^(NSError *error)
//         {
//             
//             if (!error)
//             {
//                 [SVProgressHUD dismiss];
//                 
//                 [sender setTitle:@"已发送" forState:UIControlStateNormal];
//                 sender.enabled = NO;
//                 resendTime = 60;
//                 timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFunction) userInfo:nil repeats:YES];
//                 
//             }
//             else
//             {
//                 [SVProgressHUD dismiss];
//                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
//                                                                 message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
//                                                                delegate:self
//                                                       cancelButtonTitle:NSLocalizedString(@"sure", nil)
//                                                       otherButtonTitles:nil, nil];
//                 [alert show];
//             }
//             
//         }];
        NSString *url = [NSString stringWithFormat:@"http://smsapi.c123.cn/OpenPlatform/OpenApi?action=sendOnce&ac=1001@501395610001&authkey=F7245E6A06AC19BDCC07C9A45ED24466&cgid=7903&csid=101&c=%@&m=%@",ZY_NSStringFromFormat(@"您的验证码是：%@",randomNumber),txt_Phone.text];
        
        url = [url  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        //异步连接，block实现
        //queue:需要将请求连接放到一个队列中，目前，我们是将该请求放到主队列中，在主队列中操作所占有的资源的优先等级高
        //completionHandler：请求有返回结果时，会执行该block回调
        //block中的参数：response：请求返回的响应，内部包含响应头。data：是我们所需要的实际数据。connectionError：请求出错时返回的错误信息
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//            [self jsonParserWithData:data];
            NSLog(@"我实在异步block里打印%@",connectionError);
            [btn_sendVifyCode setTitle:@"已发送" forState:UIControlStateNormal];
            btn_sendVifyCode.enabled = NO;
            resendTime = 60;
            timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFunction) userInfo:nil repeats:YES];
        }];
        
//        DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
//        [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"SendSMSCodeCallBack:" setFailBackFunctionName:nil];
//        [dataproviderOther SendSMSCodeWithVerifyCode:ZY_NSStringFromFormat(@"您的验证码是：%@",randomNumber) andPhone:txt_Phone.text];
        
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写手机号" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [SVProgressHUD dismiss];
    }
    
}

//-(void)SendSMSCodeCallBack:(id)dict
//{
//    if (dict) {
//        [SVProgressHUD dismiss];
//        
//        
//    }
//}

-(NSError *)checkInfo
{
    if (txt_Phone.text.length == 0) {
        return [NSError errorWithDomain:@"请输入手机号" code:1 userInfo:nil];
    }
    
    if (txt_Phone2.text.length == 0) {
        return [NSError errorWithDomain:@"请输入密码" code:2 userInfo:nil];
    }
    
//    if (txt_VerifyCode.text.length == 0) {
//        return [NSError errorWithDomain:@"请输入验证码" code:3 userInfo:nil];
//    }
    
    if (txt_PWD.text.length == 0) {
        return [NSError errorWithDomain:@"请输入确认密码" code:4 userInfo:nil];
    }
    
    if (![txt_Phone2.text isEqualToString:txt_PWD.text]) {
        return [NSError errorWithDomain:@"两次输入密码不一致" code:5 userInfo:nil];
    }
    
    
    return nil;
}

-(void)registBtnClick:(UIButton *)sender
{
    
    NSError *err = [self checkInfo];
    
    if (err !=nil) {
        
        [SVProgressHUD showErrorWithStatus:err.domain];
        return;
    }
   
    if ([randomNumber isEqualToString:txt_VerifyCode.text]) {
        [SVProgressHUD showWithStatus:@"验证码验证通过,正在注册..." maskType:SVProgressHUDMaskTypeBlack];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"registerCallBack:" setFailBackFunctionName:nil];
        [dataProvider registerWithUsername:txt_Phone.text password:txt_Phone2.text];
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
    
//    [SVProgressHUD showWithStatus:@"验证码验证通过,正在注册..." maskType:SVProgressHUDMaskTypeBlack];
//    
//    [SMSSDK commitVerificationCode:txt_VerifyCode.text phoneNumber:txt_Phone.text zone:@"86" result:^(NSError *error) {
//        if (!error) {
//            
//            NSLog(@"验证成功");
//            
//            DataProvider *dataProvider = [[DataProvider alloc] init];
//            [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"registerCallBack:" setFailBackFunctionName:nil];
//            [dataProvider registerWithUsername:txt_Phone.text password:txt_Phone2.text];
//        }
//        else
//        {
//            NSLog(@"验证失败");
//            [SVProgressHUD dismiss];
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
//                                                            message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
//                                                           delegate:self
//                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                                  otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }];
}
-(void)registerCallBack:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        NSString * userid=[NSString stringWithFormat:@"%@",dict[@"data"][@"Id"]];
        set_sp(user_ID, userid);
        set_sp(havePayPassword, @"NO");
//        SetPayPwdViewController * setpayPwdVC=[[SetPayPwdViewController alloc] init];
//        setpayPwdVC.isreaister=YES;
//        [self.navigationController pushViewController:setpayPwdVC animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
}

#pragma mark - self data source

-(void)registCallBack:(id)dict
{
    ELog(dict);
    [SVProgressHUD dismiss];
    if (RequestSuccess(dict)) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    }
}



@end
