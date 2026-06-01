//
//  LeftView.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "LeftView.h"
#import <SMS_SDK/SMSSDK.h>

@interface  LeftView()
{
    NSTimer *timer;
    unsigned int resendTime;
    UIButton *_btn;
}
@end

@implementation LeftView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self subViews];
        
    }
    return self;
}
// 自定子控件
- (void)subViews{
    for (int i=0; i<3; i++) {
        DrawLine *line = [[DrawLine alloc]initWithFrame:CGRectMake(0, 60*(i+1), SCREEN_WIDTH, 1)];
        [self addSubview:line];
    }
    UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 60, 30)];
    phone.text = @"手机号";
    phone.font = [UIFont systemFontOfSize:18.0];
    [self addSubview:phone];
    
    _phoneField = [UITextField new];
    _phoneField.delegate = self;
    [self addSubview:_phoneField];
    [_phoneField makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(phone);
        make.left.equalTo(phone.mas_right).offset(30);
        make.width.mas_equalTo(200);
    }];
    _phoneField.placeholder = @"请输入手机号";
    
    _verification = [[UITextField alloc]initWithFrame:CGRectMake(20, 15+60, 120, 30)];
    _verification.placeholder = @"请输入验证码";
    _verification.delegate = self;
    [self addSubview:_verification];
    _btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:_btn];
    [_btn makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.height.equalTo(_verification);
        make.width.mas_equalTo(90);
    }];
    [_btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(authBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    _btn.tintColor = [UIColor orangeColor];
    
    
    DrawLine *line = [DrawLine new];
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_btn.mas_left).offset(-10);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(40);
        make.top.equalTo(_phoneField.mas_bottom).offset(25);
    }];
    line.backgroundColor = [UIColor orangeColor];
    
    _code = [[UILabel alloc]initWithFrame:CGRectMake(20, 120+15, 60, 30)];
    [self addSubview:_code];
    _code.text = @"密码";
    _code.font = [UIFont systemFontOfSize:18.0];
    
    _code1 = [UITextField new];
    [self addSubview:_code1];
    _code1.delegate = self;
    [_code1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(_phoneField);
        make.top.equalTo(_code);
    }];
    _code1.placeholder = @"请输入密码";
    
    _confirm = [[UILabel alloc]initWithFrame:CGRectMake(20, 180+15, 80, 30)];
    [self addSubview:_confirm];
    _confirm.text = @"确认密码";
    _confirm.font = [UIFont systemFontOfSize:18.0];
    
    _code2 = [UITextField new];
    [self addSubview:_code2];
    [_code2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(_phoneField);
        make.top.equalTo(_confirm);
    }];
    _code2.delegate = self;
    _code2.placeholder = @"请再次输入密码";
}

// 获取验证码
-(void)authBtnClick:(UIButton *)sender{
    [SVProgressHUD showWithStatus:@"正在发送验证码..." maskType:SVProgressHUDMaskTypeBlack];
    if (_phoneField.text.length==11) {
        ELog(_phoneField.text);
        // 生成 "000000-999999" 6位验证码
        int num = (arc4random() % 1000000);
        _randomNumber = [NSString stringWithFormat:@"%.6d", num];
//        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneField.text
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
        NSString *url = [NSString stringWithFormat:@"http://smsapi.c123.cn/OpenPlatform/OpenApi?action=sendOnce&ac=1001@501395610001&authkey=F7245E6A06AC19BDCC07C9A45ED24466&cgid=7903&csid=101&c=%@&m=%@",ZY_NSStringFromFormat(@"您的验证码是：%@",self.randomNumber),_phoneField.text];
        
        url = [url  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        //异步连接，block实现
        //queue:需要将请求连接放到一个队列中，目前，我们是将该请求放到主队列中，在主队列中操作所占有的资源的优先等级高
        //completionHandler：请求有返回结果时，会执行该block回调
        //block中的参数：response：请求返回的响应，内部包含响应头。data：是我们所需要的实际数据。connectionError：请求出错时返回的错误信息
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            //            [self jsonParserWithData:data];
            [SVProgressHUD dismiss];
            [sender setTitle:@"已发送" forState:UIControlStateNormal];
            sender.enabled = NO;
            resendTime = 60;
            timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFunction) userInfo:nil repeats:YES];
        }];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写手机号" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [SVProgressHUD dismiss];
    }
    
}
-(void)timeFunction
{
    
    UIButton  *tempBtn = _btn;
    [tempBtn setTitle:[NSString stringWithFormat:@"(%ds)后重发",resendTime] forState:UIControlStateNormal];
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
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
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
