//
//  ChongZhiForSureViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/5/12.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "ChongZhiForSureViewController.h"
#import "pingpp.h"
#import "DataProviderOther.h"
#import "WXApi.h"
#import <UIKit/UIKit.h>

@interface ChongZhiForSureViewController ()<UIAlertViewDelegate>

@end

@implementation ChongZhiForSureViewController
{
    UIButton * btn_wxpay;
    UIButton * btn_alipay;
    UIButton * btn_Uninepay;
    
    UIButton * btn_pay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"充值确认";
    [self addLeftButton:@"fanhui"];
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
    
    UILabel * lbl_money=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img_shop.frame)+10, img_shop.frame.origin.y, SCREEN_WIDTH-CGRectGetMaxX(img_shop.frame)-10, 20)];
    lbl_money.text=[NSString stringWithFormat:@"￥%@",_price];
    [topBackView addSubview:lbl_money];
    UILabel * lbl_content=[[UILabel alloc] initWithFrame:CGRectMake(lbl_money.frame.origin.x, CGRectGetMaxY(lbl_money.frame)+10, lbl_money.frame.size.width, 20)];
    lbl_content.text=@"余额充值";
    [topBackView addSubview:lbl_content];
    [self.view addSubview:topBackView];
}

-(void)BuildSecondBackView
{
    UIView * lastview=[self.view.subviews lastObject];
    UIView  * topBackView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastview.frame)+30, SCREEN_WIDTH, 44)];
    topBackView.backgroundColor=[UIColor whiteColor];
    UIImageView * img_shop=[[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 30, 30)];
    img_shop.image=img(@"weixzhifu");
    [topBackView addSubview:img_shop];
    
    UILabel * lbl_money=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img_shop.frame)+10, img_shop.frame.origin.y, SCREEN_WIDTH-CGRectGetMaxX(img_shop.frame)-10, 15)];
    lbl_money.text=@"微信支付";
    [topBackView addSubview:lbl_money];
    UILabel * lbl_content=[[UILabel alloc] initWithFrame:CGRectMake(lbl_money.frame.origin.x, CGRectGetMaxY(lbl_money.frame), lbl_money.frame.size.width, 15)];
    lbl_content.text=@"推荐微信5.0及以上版本";
    lbl_content.font=[UIFont systemFontOfSize:12];
    [topBackView addSubview:lbl_content];
    btn_wxpay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 2, 60, 40)];
    [btn_wxpay setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [btn_wxpay setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [btn_wxpay addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:btn_wxpay];
    btn_wxpay.selected=YES;
    
    
    [self.view addSubview:topBackView];
    
    lastview=[self.view.subviews lastObject];
    UIView  * topBackView1=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastview.frame)+1, SCREEN_WIDTH, 44)];
    topBackView1.backgroundColor=[UIColor whiteColor];
    UIImageView * img_shop1=[[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 30, 30)];
    img_shop1.image=img(@"zhifubao");
    [topBackView1 addSubview:img_shop1];
    
    UILabel * lbl_money1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img_shop1.frame)+10, img_shop1.frame.origin.y, SCREEN_WIDTH-CGRectGetMaxX(img_shop1.frame)-10, 15)];
    lbl_money1.text=@"支付宝支付";
    [topBackView1 addSubview:lbl_money1];
    UILabel * lbl_content1=[[UILabel alloc] initWithFrame:CGRectMake(lbl_money1.frame.origin.x, CGRectGetMaxY(lbl_money1.frame), lbl_money1.frame.size.width, 15)];
    lbl_content1.font=[UIFont systemFontOfSize:12];
    lbl_content1.text=@"推荐有支付宝账号的使用";
    [topBackView1 addSubview:lbl_content1];
    btn_alipay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 2, 60, 40)];
    [btn_alipay setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [btn_alipay setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [btn_alipay addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBackView1 addSubview:btn_alipay];
    [self.view addSubview:topBackView1];
    
    lastview=[self.view.subviews lastObject];
    UIView  * topBackView2=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastview.frame)+1, SCREEN_WIDTH, 44)];
    topBackView2.backgroundColor=[UIColor whiteColor];
    UIImageView * img_shop2=[[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 30, 30)];
    img_shop2.image=img(@"yinlianzhifu");
    [topBackView2 addSubview:img_shop2];
    
    UILabel * lbl_money2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img_shop2.frame)+10, img_shop2.frame.origin.y, SCREEN_WIDTH-CGRectGetMaxX(img_shop2.frame)-10, 15)];
    lbl_money2.text=@"银联支付";
    [topBackView2 addSubview:lbl_money2];
    UILabel * lbl_content2=[[UILabel alloc] initWithFrame:CGRectMake(lbl_money2.frame.origin.x, CGRectGetMaxY(lbl_money2.frame), lbl_money2.frame.size.width, 15)];
    lbl_content2.font=[UIFont systemFontOfSize:12];
    lbl_content2.text=@"推荐有银行卡的使用";
    [topBackView2 addSubview:lbl_content2];
    btn_Uninepay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 2, 60, 40)];
    [btn_Uninepay setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [btn_Uninepay setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [btn_Uninepay addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBackView2 addSubview:btn_Uninepay];
    [self.view addSubview:topBackView2];
    
    btn_pay=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(topBackView2.frame)+30, SCREEN_WIDTH-60, 40)];
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
    
    DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
    [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"GetChargeCallBack:" setFailBackFunctionName:nil];
//    [mainrequest GetChargeWithchannel:btn_wxpay.isSelected?@"wx":@"alipay" andamount:[NSString stringWithFormat:@"%d",[self.price intValue]*100]];
    if ((!btn_Uninepay.selected)&&(!btn_alipay.selected)&&(!btn_wxpay.selected)) {
        [YJXStatusHUD showError:@"请选择支付方式"];
        return;
    }
    sender.enabled=NO;
    NSString * payWay=@"";
    if (btn_wxpay.selected) {
        payWay=@"wx";
    }
    if (btn_alipay.selected) {
        payWay=@"alipay";
    }
    if (btn_Uninepay.selected) {
        payWay=@"upacp";
    }
    
    [mainrequest ChongZhiGetChargeWithchannel:payWay andamount:[NSString stringWithFormat:@"%.2f",[self.price floatValue]]];
}
-(void)GetChargeCallBack:(id)dict
{
    btn_pay.enabled=YES;
    if (RequestSuccess(dict)) {
        DLog(@"%@",dict);
        
        [Pingpp createPayment:dict[@"data"]
               viewController:self
                 appURLScheme:kUrlScheme
               withCompletion:^(NSString *result, PingppError *error) {
                   if ([result isEqualToString:@"success"]) {
                       // 支付成功
                       [YJXStatusHUD showSuccess:@"支付成功"];
                       [self.navigationController popToRootViewControllerAnimated:YES];
                       
                   } else {
                       // 支付失败或取消
//                       if ([WXApi isWXAppInstalled]) {
//                           NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                           [YJXStatusHUD showError:@"支付失败"];
//                       }
//                       else
//                       {
//                           UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"前去下载微信?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去下载", nil];
//                           [alert show];
//                       }
                       
                   }
               }];
    }
    else
    {
        [YJXStatusHUD showError:@"充值请求失败"];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
