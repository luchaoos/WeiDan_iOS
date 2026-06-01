//
//  CooperationFirstViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/5.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CooperationFirstViewController.h"
#import "CooperationSecondViewController.h"

@interface CooperationFirstViewController ()
{
    UIView *contentView;
    UIWebView *clauseLbl;
    UILabel *isAgree;
    UIButton *agreeBtn;
//    UILabel *agreeLbl;
    UIButton *disAgreeBtn;
//    UILabel *disAgreeLbl;
    UIButton *commitBtn;
}
@end

@implementation CooperationFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navtitle = @"我要合作";
    [self addLeftButton:@"fanhui"];
    
    [self createViews];
}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate hiddenTabBar];
}

-(void)createViews{
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(8, Header_Height+8, SCREEN_WIDTH-16, SCREEN_HEIGHT-Header_Height-8-20-20-45)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 3;
    [self.view addSubview:contentView];
    
    clauseLbl = [[UIWebView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH-16, contentView.frame.size.height-80)];
    clauseLbl.scalesPageToFit=YES;
    [clauseLbl loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Xieyi.aspx?id=2",BaseImgUrl]]]];
    [contentView addSubview:clauseLbl];
    
    isAgree = [[UILabel alloc] initWithFrame:CGRectMake(8, contentView.frame.size.height-35-30, 300, 25)];
    isAgree.text = @"是否同意此声明";
    isAgree.textColor = [UIColor grayColor];
    [contentView addSubview:isAgree];
    
    agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height-35, contentView.frame.size.width/2, 30)];
    [agreeBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [agreeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    agreeBtn.tag = 101;
    [agreeBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:agreeBtn];
    
    disAgreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(contentView.frame.size.width/2, contentView.frame.size.height-35, contentView.frame.size.width/2, 30)];
    [disAgreeBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [disAgreeBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [disAgreeBtn setTitle:@"不同意" forState:UIControlStateNormal];
    disAgreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [disAgreeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    disAgreeBtn.tag = 102;
    [disAgreeBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:disAgreeBtn];
    
    commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(contentView.frame)+20, SCREEN_WIDTH-60, 45)];
    commitBtn.backgroundColor = ORANGE_COLOR;
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}
-(void)checkClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        if (button.tag == 101) {
            disAgreeBtn.selected = NO;
        }
        else{
            agreeBtn.selected = NO;
        }
    }
}
-(void)commit{
//    if (agreeBtn.selected == NO && disAgreeBtn.selected == NO) {
//        return;
//    }
    if (agreeBtn.selected == YES) {
        CooperationSecondViewController *cooperationVC = [[CooperationSecondViewController alloc] init];
        [self.navigationController pushViewController:cooperationVC animated:YES];
    }
    if (disAgreeBtn.selected == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
