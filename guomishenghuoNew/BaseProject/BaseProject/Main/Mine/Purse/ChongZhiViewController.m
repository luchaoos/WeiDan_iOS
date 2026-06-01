//
//  ChongZhiViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/5/11.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "ChongZhiViewController.h"
#import "ChongZhiForSureViewController.h"

@interface ChongZhiViewController ()

@end

@implementation ChongZhiViewController
{
    UITextField * txt_Money;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton:@"fanhui"];
    _lblTitle.text=@"充值";
    txt_Money=[[UITextField alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, 44)];
    txt_Money.keyboardType=UIKeyboardTypeDecimalPad;
    txt_Money.backgroundColor=[UIColor whiteColor];
    txt_Money.leftViewMode=UITextFieldViewModeAlways;
    UILabel * lbl_left=[[UILabel alloc] initWithFrame:CGRectMake(0, 12, 100, 20)];
    lbl_left.text=@"金额(元)";
    
    lbl_left.textAlignment=NSTextAlignmentCenter;
    txt_Money.leftView=lbl_left;
    txt_Money.placeholder=@"请输入金额";
    [self.view addSubview:txt_Money];
    
    UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(txt_Money.frame)+40, SCREEN_WIDTH-60, 40)];
    btn_sure.backgroundColor=NAVBAR_COLOR;
    btn_sure.layer.masksToBounds=YES;
    btn_sure.layer.cornerRadius=5;
    [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [btn_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_sure addTarget:self action:@selector(payForMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_sure];
    
}
-(void)payForMoney
{
    if (txt_Money.text.length==0) {
        return;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+([.]{0,1}[0-9]+){0,1}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *result = [regex firstMatchInString:txt_Money.text options:0 range:NSMakeRange(0, [txt_Money.text length])];
    if (result) {
        
        NSLog(@"%@", [txt_Money.text substringWithRange:result.range]);
        
        ChongZhiForSureViewController * chongzhiVC=[[ChongZhiForSureViewController alloc] init];
        chongzhiVC.price=txt_Money.text;
        [self.navigationController pushViewController:chongzhiVC animated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
