//
//  PayInShopViewController.m
//  BaseProject
//
//  Created by 于金祥 on 2016/12/1.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PayInShopViewController.h"
#import "Pingpp.h"
#import "DataProviderOther.h"
#import "TXTradePasswordView.h"
#import "SetPayPwdViewController.h"
#import "BoundPhoneViewController.h"

@interface PayInShopViewController ()<TXTradePasswordViewDelegate>

@end

@implementation PayInShopViewController
{
    UIButton * btn_wxpay;
    UIButton * btn_alipay;
    UIButton * btn_Uninepay;
    NSString *mymoney;
    UITextField * txt_money;
    UILabel * lbl_content_1;
    TXTradePasswordView *TXView;
    NSString * payWay;
    
    UIButton * btn_pay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"支付确认";
    mymoney=@"0.00";
    payWay=@"";
    self.tapGesture.enabled=YES;
//    [self addLeftButton:@"fanhui"];
    [self GetDetialList];
    [self BuildTopView];
    [self BuildSecondBackView];
}
-(void)BuildTopView
{
    UIView  * topBackView=[[UIView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 70)];
    topBackView.backgroundColor=[UIColor whiteColor];
    UIImageView * img_shop=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    img_shop.image=img(@"guomi512");
    img_shop.layer.masksToBounds=YES;
    img_shop.layer.cornerRadius=25;
    [topBackView addSubview:img_shop];
    
    txt_money=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img_shop.frame)+10, img_shop.frame.origin.y, SCREEN_WIDTH-CGRectGetMaxX(img_shop.frame)-10, 25)];
    txt_money.placeholder=@"请输入到店支付的金额";
    [txt_money setKeyboardType:UIKeyboardTypeDecimalPad];
    [topBackView addSubview:txt_money];
    lbl_content_1=[[UILabel alloc] initWithFrame:CGRectMake(txt_money.frame.origin.x, CGRectGetMaxY(txt_money.frame)+10, txt_money.frame.size.width, 16)];
    if (_fandian==100.00) {
        lbl_content_1.text=@"余额:0.00";
    }
    else
    {
        lbl_content_1.text=[NSString stringWithFormat:@"当前钱包余额不可用"];
    }
    
    [topBackView addSubview:lbl_content_1];
    [self.view addSubview:topBackView];
}

-(void)BuildSecondBackView
{
    UIView * lastview=[self.view.subviews lastObject];
    UIView  * topBackView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastview.frame)+30, SCREEN_WIDTH, 50)];
    topBackView.backgroundColor=[UIColor whiteColor];
    UIImageView * img_shop=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
    img_shop.image=img(@"weixinzhifu-1");
    [topBackView addSubview:img_shop];
    
    UILabel * lbl_money=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img_shop.frame)+10, img_shop.frame.origin.y, SCREEN_WIDTH-CGRectGetMaxX(img_shop.frame)-10, 15)];
    lbl_money.text=@"微信支付";
    [topBackView addSubview:lbl_money];
    UILabel * lbl_content=[[UILabel alloc] initWithFrame:CGRectMake(lbl_money.frame.origin.x, CGRectGetMaxY(lbl_money.frame), lbl_money.frame.size.width, 15)];
    lbl_content.text=@"推荐微信5.0及以上版本";
    lbl_content.font=[UIFont systemFontOfSize:12];
    [topBackView addSubview:lbl_content];
    btn_wxpay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 5, 60, 40)];
    [btn_wxpay setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [btn_wxpay setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [btn_wxpay addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:btn_wxpay];
    
    
    
    [self.view addSubview:topBackView];
    
    lastview=[self.view.subviews lastObject];
    UIView  * topBackView1=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastview.frame)+1, SCREEN_WIDTH, 50)];
    topBackView1.backgroundColor=[UIColor whiteColor];
    UIImageView * img_shop1=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
    img_shop1.image=img(@"zhifub");
    [topBackView1 addSubview:img_shop1];
    
    UILabel * lbl_money1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img_shop1.frame)+10, img_shop1.frame.origin.y, SCREEN_WIDTH-CGRectGetMaxX(img_shop1.frame)-10, 15)];
    lbl_money1.text=@"支付宝支付";
    [topBackView1 addSubview:lbl_money1];
    UILabel * lbl_content1=[[UILabel alloc] initWithFrame:CGRectMake(lbl_money1.frame.origin.x, CGRectGetMaxY(lbl_money1.frame), lbl_money1.frame.size.width, 15)];
    lbl_content1.font=[UIFont systemFontOfSize:12];
    lbl_content1.text=@"推荐有支付宝账号的使用";
    [topBackView1 addSubview:lbl_content1];
    btn_alipay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 5, 60, 40)];
    [btn_alipay setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [btn_alipay setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [btn_alipay addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBackView1 addSubview:btn_alipay];
    btn_alipay.selected=YES;
    [self.view addSubview:topBackView1];
    
//    if (_fandian==100.00) {
    
        lastview=[self.view.subviews lastObject];
        UIView  * topBackView2=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastview.frame)+1, SCREEN_WIDTH, 50)];
        topBackView2.backgroundColor=[UIColor whiteColor];
        UIImageView * img_shop2=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
        img_shop2.image=img(@"yinlian");
        [topBackView2 addSubview:img_shop2];
        UILabel * lbl_money2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img_shop2.frame)+10, img_shop2.frame.origin.y, SCREEN_WIDTH-CGRectGetMaxX(img_shop2.frame)-10, 15)];
        lbl_money2.text=@"银联支付";
        [topBackView2 addSubview:lbl_money2];
        UILabel * lbl_content2=[[UILabel alloc] initWithFrame:CGRectMake(lbl_money2.frame.origin.x, CGRectGetMaxY(lbl_money2.frame), lbl_money2.frame.size.width, 15)];
        lbl_content2.font=[UIFont systemFontOfSize:12];
        lbl_content2.text=@"推荐有银行卡的使用";
        [topBackView2 addSubview:lbl_content2];
        btn_Uninepay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 5, 60, 40)];
        [btn_Uninepay setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [btn_Uninepay setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        [btn_Uninepay addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBackView2 addSubview:btn_Uninepay];
        [self.view addSubview:topBackView2];
//    }
    
    lastview=[self.view.subviews lastObject];
    btn_pay=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lastview.frame)+30, SCREEN_WIDTH-60, 40)];
    btn_pay.backgroundColor=NAVBAR_COLOR;
    [btn_pay setTitle:@"确认支付" forState:UIControlStateNormal];
    [btn_pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_pay addTarget:self action:@selector(PayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_pay];
    
}

-(void)btnClick:(UIButton *)sender
{
    
    if (sender.selected==YES) {
        return;
    }
    if ([sender isEqual:btn_wxpay]) {
//        [YJXStatusHUD showError:@"微信支付尚未开通"];
//        return;
        btn_wxpay.selected=YES;
        btn_alipay.selected=NO;
        btn_Uninepay.selected=NO;
    }
    else if ([sender isEqual:btn_alipay])
    {
        btn_alipay.selected=YES;
        btn_wxpay.selected=NO;
        btn_Uninepay.selected=NO;
    }
    else
    {
        btn_alipay.selected=NO;
        btn_wxpay.selected=NO;
        btn_Uninepay.selected=YES;
    }
    
}


-(void)PayAction:(UIButton *)sender
{
    if ([mymoney floatValue]<[txt_money.text floatValue]) {
        if ((!btn_Uninepay.selected)&&(!btn_alipay.selected)&&(!btn_wxpay.selected)) {
            [YJXStatusHUD showError:@"请选择支付方式"];
            return;
        }
        sender.enabled=NO;
        if (btn_wxpay.selected) {
            payWay=@"wx";
        }
        if (btn_alipay.selected) {
            payWay=@"alipay";
        }
        if (btn_Uninepay.selected) {
            payWay=@"upacp";
        }
    }
    
    
    
    
//    set_sp(havePayPassword, @"0");
    
//    if ([get_sp(havePayPassword) integerValue]==1) {
        DLog(@"%f",[mymoney floatValue]);
        if ([mymoney floatValue]<0.01) {
            DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
            [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"GetChargeCallBack:" setFailBackFunctionName:nil];
            [mainrequest DaoDianWithtotalprice:[NSString stringWithFormat:@"%.2f",[txt_money.text floatValue]] andchannel:payWay andshopid:self.shopID];
        }
        else
        {
            if (_fandian !=100.00) {
                DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
                [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"GetChargeCallBack:" setFailBackFunctionName:nil];
                [mainrequest DaoDianWithtotalprice:[NSString stringWithFormat:@"%.2f",[txt_money.text floatValue]] andchannel:payWay andshopid:self.shopID];
            }
            else
            {
                TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-400,SCREEN_WIDTH, 200) WithTitle:@"请输入支付密码"];
                TXView.backgroundColor=[UIColor whiteColor];
                TXView.TXTradePasswordDelegate = self;
                if (![TXView.TF becomeFirstResponder])
                {
                    //成为第一响应者。弹出键盘
                    [TXView.TF becomeFirstResponder];
                }
                [self.view addSubview:TXView];
            }
        }
//    }
//    else
//    {
//        if ([ZY_NSStringFromFormat(@"%@",get_sp(@"Phone")) length]<9) {
//            BoundPhoneViewController *pvc = [[BoundPhoneViewController alloc]init];
//            [self.navigationController pushViewController:pvc animated:YES];
//        }
//        else
//        {
//            SetPayPwdViewController * setpayPwdVC=[[SetPayPwdViewController alloc] init];
//            setpayPwdVC.isreaister=NO;
//            setpayPwdVC.isRoot=NO;
//            [self.navigationController pushViewController:setpayPwdVC animated:YES];
//        }
//    }
    
    
    
   
}


#pragma mark  密码输入结束后调用此方法
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password
{
    NSLog(@"密码 = %@",Password);
    if ([view isEqual:TXView]) {
        [TXView removeFromSuperview];
        DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
        [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"VerifyPWDCallBack:" setFailBackFunctionName:nil];
        [mainrequest CheckPayPasswordWithpaypassword:Password];
        //        [YJXStatusHUD showLoading:@"正在验证支付密码..."];
    }
    
}
-(void)VerifyPWDCallBack:(id)dict
{
    btn_pay.enabled=YES;
    //    [YJXStatusHUD hideLoading];
    if (RequestSuccess(dict)) {
        //        [YJXStatusHUD showLoading:@"正在获取支付信息..."];
        if ([dict[@"data"][@"Result"] intValue]==0) {
            [YJXStatusHUD showError:@"支付密码验证失败,支付取消"];
            return;
        }
        DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
        [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"GetChargeCallBack:" setFailBackFunctionName:nil];
        [mainrequest DaoDianWithtotalprice:[NSString stringWithFormat:@"%.2f",[txt_money.text floatValue]] andchannel:payWay andshopid:self.shopID];
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}
-(void)GetChargeCallBack:(id)dict
{
    //    [YJXStatusHUD hideLoading];
    btn_pay.enabled=YES;
    
    if (RequestSuccess(dict)) {
        DLog(@"%@",dict);
        NSDictionary *data = [self dictionaryWithJsonString:dict[@"data"]];
        if ([NSString stringWithFormat:@"%@",dict[@"data"]].length>5) {
            [Pingpp createPayment:dict[@"data"]
                   viewController:self
                     appURLScheme:kUrlScheme
                   withCompletion:^(NSString *result, PingppError *error) {
                       if ([result isEqualToString:@"success"]) {
                           // 支付成功
                           
//                           [YJXStatusHUD showSuccess:@"支付成功"];
//                           [self.navigationController popViewControllerAnimated:YES];
                           
                           DataProvider *dataProvider = [[DataProvider alloc] init];
                           [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"callBackFinish:" setFailBackFunctionName:nil];
                           [dataProvider mallServiceCallBackOrderno:data[@"order_no"] amount:data[@"amount"]];
                           
                           
                       } else {
                           // 支付失败或取消
                           NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                           [YJXStatusHUD showError:error.getMsg];//@"支付失败"];
                       }
                   }];
        }
        else
        {
            [YJXStatusHUD showSuccess:@"支付成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else
    {
        [YJXStatusHUD showError:@"请求失败"];
    }
}

- (void)callBackFinish:(NSDictionary *)data {
    
    [YJXStatusHUD showSuccess:@"支付成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)GetDetialList
{
    if (_fandian==100.00) {
        DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
        [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetDetitlListCallBack:" setFailBackFunctionName:nil];
        [dataproviderOther SelectAllWalletDetailWithstartRowIndex:@"0" andmaximumRows:@"1" andtype:@"9"];
    }
    else
    {
        lbl_content_1.text=[NSString stringWithFormat:@"当前钱包余额不可用"];
    }
    
}

-(void)GetDetitlListCallBack:(id)dict
{
    ELog(dict);
    
    
    if (RequestSuccess(dict)) {
        mymoney=[NSString stringWithFormat:@"%.2f",[dict[@"data"][@"TotalMoney"] floatValue]];
        lbl_content_1.text=[NSString stringWithFormat:@"当前钱包余额:%@",mymoney];
    }
    //    else
    //    {
    //        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    //    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
