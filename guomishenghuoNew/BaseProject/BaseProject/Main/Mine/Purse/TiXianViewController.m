//
//  TiXianViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/5/12.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "TiXianViewController.h"
#import "TiXianJiLuViewController.h"
#import "DataProviderOther.h"

@interface TiXianViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>
{
    UITextField * txt_Money;
    NSString * payType;
}

@end

@implementation TiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.text=@"提现";
    [self addLeftButton:@"fanhui"];
    [self addRightbuttontitle:@"提现记录"];
//    self.view.backgroundColor=RGB(235, 235, 235);
    
    UITextField * txt_title=[[UITextField alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, 44)];
    txt_title.enabled=NO;
    txt_title.backgroundColor=[UIColor whiteColor];
    txt_title.leftViewMode=UITextFieldViewModeAlways;
    txt_title.text=[NSString stringWithFormat:@"￥%.2f",self.TotalMoney];
    txt_title.textColor=NAVBAR_COLOR;
    UILabel * title_left=[[UILabel alloc] initWithFrame:CGRectMake(0, 12, 100, 20)];
    title_left.text=@"可提金额";
    
    title_left.textAlignment=NSTextAlignmentCenter;
    txt_title.leftView=title_left;
    [self.view addSubview:txt_title];
    
    
    
    
    txt_Money=[[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(txt_title.frame)+20, SCREEN_WIDTH, 44)];
    txt_Money.keyboardType=UIKeyboardTypeNumberPad;
    txt_Money.backgroundColor=[UIColor whiteColor];
    txt_Money.leftViewMode=UITextFieldViewModeAlways;
    UILabel * lbl_left=[[UILabel alloc] initWithFrame:CGRectMake(0, 12, 100, 20)];
    lbl_left.text=@"金额(元)";
    
    lbl_left.textAlignment=NSTextAlignmentCenter;
    txt_Money.leftView=lbl_left;
    txt_Money.placeholder=@"请输入提现金额";
    [self.view addSubview:txt_Money];
    
    UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(txt_Money.frame)+40, SCREEN_WIDTH-60, 40)];
    btn_sure.backgroundColor=NAVBAR_COLOR;
    [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [btn_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_sure addTarget:self action:@selector(payForMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_sure];
}

-(void)payForMoney
{
    [self.view endEditing:YES];
    if ([txt_Money.text intValue]>self.TotalMoney) {
        
        return;
    }
    UIActionSheet * actionsheet=[[UIActionSheet alloc] initWithTitle:@"选择提现方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", @"微信", nil];
    [actionsheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        payType=@"0";
    }
    else
    {
        payType=@"1";
    }
    if (buttonIndex!=2) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入提现账号" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
        [dialog show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex !=0) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        DLog(@"%@",nameField.text);
        
        DataProviderOther * mainRequest=[[DataProviderOther alloc] init];
        [mainRequest setDelegateObject:self setSucceedBackFunctionName:@"SubmitCallBack:" setFailBackFunctionName:nil];
        [mainRequest WidthDrawWithtype:payType andamount:txt_Money.text andcardno:nameField.text];
        
        //TODO
    }
}
-(void)SubmitCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"申请提交成功,请等待"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}
-(void)clickRightButton:(UIButton *)sender
{
    TiXianJiLuViewController * tixianjiluVC=[[TiXianJiLuViewController alloc] init];
    
    [self.navigationController pushViewController:tixianjiluVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
