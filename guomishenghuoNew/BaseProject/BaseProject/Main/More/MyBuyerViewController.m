//
//  MyBuyerViewController.m
//  LikeAttention
//
//  Created by 鞠超 on 16/1/8.
//  Copyright © 2016年 zykj.LikeAttention. All rights reserved.
//

#import "MyBuyerViewController.h"

#import "AppDelegate.h"
@interface MyBuyerViewController ()

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation MyBuyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_navi];
    
    [self p_setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navi
- (void)p_navi
{
    _lblTitle.text=@"我是商家";
    [self addLeftButton:@"Icon_Back@2x.png"];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

//隐藏tabbar
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

#pragma mark - web页
- (void)p_setupView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width , self.view.frame.size.height - 64)];
#warning 商户版上线后在这写app链接地址
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.pgyer.com/ppWU"]];
    [self.view addSubview: self.webView];
    [self.webView loadRequest:request];
}

@end
