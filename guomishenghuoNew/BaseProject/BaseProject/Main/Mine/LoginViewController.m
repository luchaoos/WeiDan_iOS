//
//  LoginViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/5/7.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "ForgetPWDViewController.h"
#import "SetPayPwdViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <RongIMKit/RongIMKit.h>

@interface LoginViewController ()//<loginManagerDelegate>
{
    NSTimer *timer;
    unsigned int resendTime;
    UIButton * btn_sendVifyCode;
    
    //登录返回的数据字典
    NSDictionary *loginDict;
    NSString *randomNumber;
}
@end

@implementation LoginViewController
{
    UIButton * btn_left;
    UIButton * btn_right;
    UIView * firstView;
    UIView * secondView;
    UITextField * txt_Phone;
    UITextField * txt_VerifyCode;
    UITextField * txt_Phone2;
    UITextField * txt_PWD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"登录";
    [self addLeftButton:@"fanhui"];
    [self addRightbuttontitle:@"注册"];
    // 生成 "000000-999999" 6位验证码
    int num = (arc4random() % 1000000);
    randomNumber = [NSString stringWithFormat:@"%.6d", num];
    [self BuildView];
    [self BuildTextView];
    [self BuildLoginButton];
}




-(void)BuildView
{
    btn_left=[[UIButton alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH/2, 44)];
    btn_left.tag=1;
    [btn_left setBackgroundImage:[Toolkit imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateSelected];
    [btn_left setBackgroundImage:[Toolkit imageWithColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
    [btn_left addTarget:self action:@selector(TopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn_left setTitle:@"手机快捷登录" forState:UIControlStateNormal];
    btn_left.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_left setBackgroundImage:[Toolkit imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateHighlighted];
    [btn_left setBackgroundImage:[Toolkit imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateFocused];
    btn_left.selected=YES;
    [self.view addSubview:btn_left];
    btn_right=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn_left.frame)+1, 65, SCREEN_WIDTH/2, 44)];
    btn_right.tag=2;
    [btn_right setBackgroundImage:[Toolkit imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateSelected];
    [btn_right setBackgroundImage:[Toolkit imageWithColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
    [btn_right addTarget:self action:@selector(TopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn_right setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [btn_right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_right.selected=NO;
    [btn_right setBackgroundImage:[Toolkit imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateHighlighted];
    btn_right.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn_right];
    
}

-(void)BuildTextView
{
    firstView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn_left.frame), SCREEN_WIDTH, 88)];
    firstView.backgroundColor=[UIColor whiteColor];
    txt_Phone=[[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 45)];
    txt_Phone.font = [UIFont systemFontOfSize:15];
    txt_Phone.keyboardType = UIKeyboardTypeNumberPad;
    txt_Phone.placeholder=@" 请输入您的手机号";
//    txt_Phone.borderStyle = UITextBorderStyleRoundedRect;
    txt_Phone.leftViewMode = UITextFieldViewModeAlways;
    txt_Phone.rightViewMode= UITextFieldViewModeAlways;
    UIView * V_phone_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    UILabel * lbl_phone_left=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    lbl_phone_left.text=@"手机号";
    [V_phone_left addSubview:lbl_phone_left];
    UIView * V_shuxian=[[UIView alloc] initWithFrame:CGRectMake(V_phone_left.frame.size.width-1, 5, 1, 35)];
    V_shuxian.backgroundColor=[UIColor lightGrayColor];
    [V_phone_left addSubview:V_shuxian];
    txt_Phone.leftView=V_phone_left;
    btn_sendVifyCode=[[UIButton alloc] init];
    btn_sendVifyCode.frame=CGRectMake(SCREEN_WIDTH-115, 7, 100, 30);
    btn_sendVifyCode.layer.masksToBounds=YES;
    btn_sendVifyCode.layer.borderWidth=1.0;
    btn_sendVifyCode.layer.borderColor=AppMainColor.CGColor;
    [btn_sendVifyCode addTarget:self action:@selector(authBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn_sendVifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btn_sendVifyCode setTitleColor:AppMainColor forState:UIControlStateNormal];
    btn_sendVifyCode.titleLabel.font = [UIFont systemFontOfSize:15];
    
    txt_Phone.rightView=btn_sendVifyCode;
    [firstView addSubview:txt_Phone];
    
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(txt_Phone.frame), txt_Phone.frame.size.width, 1)];
    fenge.backgroundColor=[UIColor lightGrayColor];
    [firstView addSubview:fenge];
    
    txt_VerifyCode=[[UITextField alloc] initWithFrame:CGRectMake(txt_Phone.frame.origin.x, CGRectGetMaxY(fenge.frame), txt_Phone.frame.size.width, 45)];
    txt_VerifyCode.placeholder=@" 请输入您收到的验证码";
    txt_VerifyCode.leftViewMode = UITextFieldViewModeAlways;
    UIView * V_VerifyCode_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    UILabel * lbl_VerifyCode_left=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    lbl_VerifyCode_left.text=@"验证码";
    [V_VerifyCode_left addSubview:lbl_VerifyCode_left];
    UIView * V_VerifyCode_shuxian=[[UIView alloc] initWithFrame:CGRectMake(V_phone_left.frame.size.width-1, 5, 1, 35)];
    V_VerifyCode_shuxian.backgroundColor=[UIColor lightGrayColor];
    [V_VerifyCode_left addSubview:V_VerifyCode_shuxian];
    txt_VerifyCode.leftView=V_VerifyCode_left;
    txt_VerifyCode.font = [UIFont systemFontOfSize:15];
    [firstView addSubview:txt_VerifyCode];
    [self.view addSubview:firstView];
    
    
    
    secondView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn_left.frame), SCREEN_WIDTH, 88)];
    secondView.backgroundColor=[UIColor whiteColor];
    txt_Phone2=[[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 45)];
    txt_Phone2.placeholder=@" 请输入您的手机号";
    txt_Phone2.leftViewMode = UITextFieldViewModeAlways;
    txt_Phone2.keyboardType = UIKeyboardTypeNumberPad;
    txt_Phone2.font = [UIFont systemFontOfSize:15];
    UIView * V_phone2_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    UILabel * lbl_phone2_left=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    lbl_phone2_left.text=@"账号";
    [V_phone2_left addSubview:lbl_phone2_left];
    UIView * V_shuxian2=[[UIView alloc] initWithFrame:CGRectMake(V_phone2_left.frame.size.width-1, 5, 1, 35)];
    V_shuxian2.backgroundColor=[UIColor lightGrayColor];
    [V_phone2_left addSubview:V_shuxian2];
    txt_Phone2.leftView=V_phone2_left;
    [secondView addSubview:txt_Phone2];
    
    UIView * fenge1=[[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(txt_Phone2.frame), txt_Phone2.frame.size.width, 1)];
    fenge1.backgroundColor=[UIColor lightGrayColor];
    [secondView addSubview:fenge1];
    
    txt_PWD=[[UITextField alloc] initWithFrame:CGRectMake(txt_Phone2.frame.origin.x, CGRectGetMaxY(fenge1.frame), txt_Phone2.frame.size.width, 45)];
    txt_PWD.placeholder=@" 请输入您的密码";
    txt_PWD.secureTextEntry=YES;
    txt_PWD.leftViewMode = UITextFieldViewModeAlways;
    UIView * V_PWD_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    UILabel * lbl_PWD_left=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 45)];
    lbl_PWD_left.text=@"密码";
    [V_PWD_left addSubview:lbl_PWD_left];
    UIView * V_PWD_shuxian=[[UIView alloc] initWithFrame:CGRectMake(V_PWD_left.frame.size.width-1, 5, 1, 35)];
    V_PWD_shuxian.backgroundColor=[UIColor lightGrayColor];
    [V_PWD_left addSubview:V_PWD_shuxian];
    txt_PWD.leftView=V_PWD_left;
    txt_PWD.font = [UIFont systemFontOfSize:15];
    [secondView addSubview:txt_PWD];
    [self.view addSubview:secondView];
    
    
    secondView.hidden=YES;
}
-(void)BuildLoginButton
{
    
    
    UIView * lastView=[self.view.subviews lastObject];
    UILabel * lbl_tishi=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastView.frame)+5, SCREEN_WIDTH-20, 15)];
    lbl_tishi.text=@"若您未注册,快捷登录会自动注册并登录";
    lbl_tishi.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:lbl_tishi];
    lastView=[self.view.subviews lastObject];
    UIButton * btn_login=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lastView.frame)+20, SCREEN_WIDTH-60, 44)];
    btn_login.backgroundColor=AppMainColor;
    [btn_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_login setTitle:@"登录" forState:UIControlStateNormal];
    [btn_login addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_login];
    
    
    
    UIButton * btn_ForgetPWD=[[UIButton alloc] init];
    btn_ForgetPWD.bounds=CGRectMake(0, 0, 100, 50);
    btn_ForgetPWD.center=CGPointMake((SCREEN_WIDTH/4)*3, CGRectGetMaxY(btn_login.frame)+40);
//    [btn_wxLogin setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    btn_ForgetPWD.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn_ForgetPWD setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btn_ForgetPWD setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_ForgetPWD addTarget:self action:@selector(ForgetPWD:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_ForgetPWD];
    
    UIButton * btn_qqLogin=[[UIButton alloc] init];
    btn_qqLogin.bounds=CGRectMake(0, 0, 55, 55);
    btn_qqLogin.center=CGPointMake(SCREEN_WIDTH/4, SCREEN_HEIGHT-70);
//    [btn_qqLogin setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [btn_qqLogin addTarget:self action:@selector(QQLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_qqLogin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qq"]];
    img_qqLogin.frame = btn_qqLogin.bounds;
    [btn_qqLogin addSubview:img_qqLogin];
    [self.view addSubview:btn_qqLogin];
    
    UIButton * btn_wxLogin=[[UIButton alloc] init];
    btn_wxLogin.bounds=CGRectMake(0, 0, 55, 55);
    btn_wxLogin.center=CGPointMake((SCREEN_WIDTH/4)*3, SCREEN_HEIGHT-70);
//    [btn_wxLogin setImage:[UIImage imageNamed:@"wx"] forState:UIControlStateNormal];
    [btn_wxLogin addTarget:self action:@selector(WXLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img_wxLogin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wx"]];
    img_wxLogin.frame = btn_wxLogin.bounds;
    [btn_wxLogin addSubview:img_wxLogin];
    [self.view addSubview:btn_wxLogin];
    
}
#pragma mark - login delegate

//-(void)loginManager:(LoginManager *)manager LoginSuccess:(NSDictionary *)dict
//{
//    ELog(dict);
//    if (self.navigationController == nil) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//    
//}

#pragma mark - actions

-(void)clickLeftButton:(UIButton *)sender
{
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

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
    
    [SVProgressHUD showWithStatus:@"正在发送验证码..." maskType:SVProgressHUDMaskTypeBlack];
    if (txt_Phone.text.length==11) {
        ELog(txt_Phone.text);
        NSString *url = [NSString stringWithFormat:@"http://smsapi.c123.cn/OpenPlatform/OpenApi?action=sendOnce&ac=1001@501395610001&authkey=F7245E6A06AC19BDCC07C9A45ED24466&cgid=7903&csid=101&c=%@&m=%@",ZY_NSStringFromFormat(@"您的验证码是：%@",randomNumber),txt_Phone.text];
        
        url = [url  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        //异步连接，block实现
        //queue:需要将请求连接放到一个队列中，目前，我们是将该请求放到主队列中，在主队列中操作所占有的资源的优先等级高
        //completionHandler：请求有返回结果时，会执行该block回调
        //block中的参数：response：请求返回的响应，内部包含响应头。data：是我们所需要的实际数据。connectionError：请求出错时返回的错误信息
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            [SVProgressHUD dismiss];
            
            [sender setTitle:@"已发送" forState:UIControlStateNormal];
            sender.enabled = NO;
            resendTime = 60;
            timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFunction) userInfo:nil repeats:YES];

        }];
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
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写手机号" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [SVProgressHUD dismiss];
    }
    
}

-(void)TopBtnClick:(UIButton *)sender
{
    if (sender.selected==YES) {
        return;
    }
    sender.selected=!sender.selected;
    if ([sender isEqual:btn_left]) {
        btn_right.selected=!btn_right.selected;
        secondView.hidden=YES;
        firstView.hidden=NO;
    }
    else
    {
        btn_left.selected=!btn_left.selected;
        
        firstView.hidden=YES;
        secondView.hidden=NO;
        
    }
}


-(void)loginBtnClick:(UIButton *)sender
{
    if (btn_left.selected == YES) {
        
        if(txt_Phone.text.length != 11)
        {
            [SVProgressHUD showErrorWithStatus:@"请正确输入手机号"];
            return;
        }
        
        
        
        if ([randomNumber isEqualToString:txt_VerifyCode.text]) {
//            [SVProgressHUD showWithStatus:@"验证码验证通过,正在注册..." maskType:SVProgressHUDMaskTypeBlack];
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"fastLoginCallBack:" setFailBackFunctionName:nil];
            [dataProvider fastLoginWithPhone:txt_Phone.text];
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
        
        
        
        
        
//        [SMSSDK commitVerificationCode:txt_VerifyCode.text phoneNumber:txt_Phone.text zone:@"86" result:^(NSError *error) {
//            if (!error) {
////                [SVProgressHUD showWithStatus:@"验证通过,登录中..." maskType:SVProgressHUDMaskTypeBlack];
//                
//                DataProvider *dataProvider = [[DataProvider alloc] init];
//                [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"fastLoginCallBack:" setFailBackFunctionName:nil];
//                [dataProvider fastLoginWithPhone:txt_Phone.text];
//            }
//            else
//            {
//                NSLog(@"验证失败");
//                [SVProgressHUD dismiss];
//                NSRange  range=[[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]] rangeOfString:@"验证码错误"];
//                if (range.length>0) {
//                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
//                                                                    message:@"验证码已失效请重新发送"
//                                                                   delegate:self
//                                                          cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                                          otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//                else
//                {
//                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
//                                                                    message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
//                                                                   delegate:self
//                                                          cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                                          otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//                
//                
//            }
//
//        }];
    }
    else
    {
        if(txt_Phone2.text.length != 11)
        {
            [SVProgressHUD showErrorWithStatus:@"请正确输入手机号"];
            return;
        }
        if (txt_PWD.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
//        [LoginManager loginWithAccount:txt_Phone2.text andPassWord:txt_PWD.text andDelegate:self];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"loginCallback:" setFailBackFunctionName:nil];
        [dataProvider loginWithUsername:txt_Phone2.text password:txt_PWD.text];
    }
}
-(void)fastLoginCallBack:(id)dict{
    NSLog(@"%@",dict);
     [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        
        loginDict = [NSDictionary dictionaryWithDictionary:dict[@"data"]];
        if ([loginDict[@"IsClose"] intValue]!=0) {
            [YJXStatusHUD showSuccess:@"账号已被限制使用，请联系客服"];
            [Toolkit setUserDefaultWithObject:@"NO" forKey:isLogin];
            return;
        }
//        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [Toolkit setUserDefaultWithObject:@"YES" forKey:isLogin];
        [Toolkit setUserDefaultWithObject:loginDict[@"Id"] forKey:user_ID];
        set_sp(@"UserName", loginDict[@"UserName"]);
        set_sp(@"PhotoPath", loginDict[@"PhotoPath"]);
        set_sp(@"Phone", loginDict[@"Phone"]);
        set_sp(havePayPassword, loginDict[@"IsSetPayPwd"]);
//        if ([get_sp(havePayPassword) integerValue]==1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else
//        {
//            SetPayPwdViewController * setpayPwdVC=[[SetPayPwdViewController alloc] init];
//            setpayPwdVC.isreaister=YES;
//            setpayPwdVC.isRoot=NO;
//            [self.navigationController pushViewController:setpayPwdVC animated:YES];
//        }
//        set_sp(@"UserName", loginDict[@"UserName"]);
//        set_sp(@"UserName", loginDict[@"UserName"]);
//        set_sp(@"UserName", loginDict[@"UserName"]);
//        set_sp(@"UserName", loginDict[@"UserName"]);
        [self.navigationController popViewControllerAnimated:YES];
        [YJXStatusHUD showSuccess:@"登录成功"];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
}
-(void)loginCallback:(id)dict{
    NSLog(@"%@",dict);
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        
        loginDict = [NSDictionary dictionaryWithDictionary:dict[@"data"]];
        
        if ([loginDict[@"IsClose"] intValue]!=0) {
             [YJXStatusHUD showSuccess:@"账号已被限制使用，请联系客服"];
            [Toolkit setUserDefaultWithObject:@"NO" forKey:isLogin];
            return;
        }
//        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [Toolkit setUserDefaultWithObject:@"YES" forKey:isLogin];
        [Toolkit setUserDefaultWithObject:loginDict[@"Id"] forKey:user_ID];
        set_sp(@"UserName", loginDict[@"UserName"]);
        set_sp(@"PhotoPath", loginDict[@"PhotoPath"]);
        set_sp(@"Phone", loginDict[@"Phone"]);
        set_sp(@"Name", loginDict[@"Name"]);
        set_sp(@"Token", loginDict[@"Token"]);
        set_sp(havePayPassword, loginDict[@"IsSetPayPwd"]);
//        if ([get_sp(havePayPassword) integerValue]==1) {
//        [self.navigationController popViewControllerAnimated:YES];
//        }else
//        {
//            SetPayPwdViewController * setpayPwdVC=[[SetPayPwdViewController alloc] init];
//            setpayPwdVC.isreaister=YES;
//            setpayPwdVC.isRoot=NO;
//            [self.navigationController pushViewController:setpayPwdVC animated:YES];
//        }
        [[RCIM sharedRCIM] connectWithToken:get_sp(@"Token") success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];

        
        
        [self.navigationController popViewControllerAnimated:YES];
         [YJXStatusHUD showSuccess:@"登录成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HandelNotice" object:nil];
    }
    else{
        [YJXStatusHUD showError:dict[@"error"]];
//        [SVProgressHUD showErrorWithStatus:];
    }
}

-(void)QQLoginClick:(UIButton *)sender
{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
//    
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        //          获取微博用户名、uid、token等
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
//            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
//            [LoginManager ThirdFrameLoginWith:snsAccount.usid andphotopath:response.thirdPlatformUserProfile[@"headimgurl"] andDelegate:self];
//        }});
    
    //例如QQ的登录
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [self OtherLoginWithuid:user.uid andnickname:user.nickname andphoto:user.icon];
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}
-(void)WXLoginClick:(UIButton *)sender
{
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [self OtherLoginWithuid:user.uid andnickname:user.nickname andphoto:user.icon];
         }
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}
-(void)OtherLoginWithuid:(NSString *)uid andnickname:(NSString *)nickname andphoto:(NSString *)photo
{
    set_sp(@"openid", uid);
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setSucceedBackFunctionName:@"OtherloginCallBack:" setFailBackFunctionName:nil];
    [dataprovider OtherloginWithopenid:uid nicname:nickname andphotopath:photo];
}
-(void)OtherloginCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        
        loginDict = [NSDictionary dictionaryWithDictionary:dict[@"data"]];
        
        if ([loginDict[@"IsClose"] intValue]!=0) {
            [YJXStatusHUD showSuccess:@"账号已被限制使用，请联系客服"];
            [Toolkit setUserDefaultWithObject:@"NO" forKey:isLogin];
            return;
        }
        //        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [Toolkit setUserDefaultWithObject:@"YES" forKey:isLogin];
        [Toolkit setUserDefaultWithObject:loginDict[@"Id"] forKey:user_ID];
        set_sp(@"UserName", loginDict[@"UserName"]);
        set_sp(@"PhotoPath", loginDict[@"PhotoPath"]);
        set_sp(@"Phone", loginDict[@"Phone"]);
        set_sp(@"Name", loginDict[@"Name"]);
        set_sp(@"Token", loginDict[@"Token"]);
        set_sp(havePayPassword, loginDict[@"IsSetPayPwd"]);
//        if ([get_sp(havePayPassword) integerValue]==1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }else
//        {
//            SetPayPwdViewController * setpayPwdVC=[[SetPayPwdViewController alloc] init];
//            setpayPwdVC.isreaister=YES;
//            setpayPwdVC.isRoot=NO;
//            [self.navigationController pushViewController:setpayPwdVC animated:YES];
//        }
        [self.navigationController popViewControllerAnimated:YES];
        [YJXStatusHUD showSuccess:@"登录成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HandelNotice" object:nil];
    }
    else{
        [YJXStatusHUD showError:dict[@"error"]];
        //        [SVProgressHUD showErrorWithStatus:];
    }
}
-(void)ForgetPWD:(UIButton *)sender
{
    
    
    ForgetPWDViewController * forgetPWDVC=[[ForgetPWDViewController alloc] init];
    [self.navigationController pushViewController:forgetPWDVC animated:YES];
    
}



-(void)clickRightButton:(UIButton *)sender
{
    RegisterViewController * registerVC=[[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    _app_.hiddenTabBar;
}

@end
