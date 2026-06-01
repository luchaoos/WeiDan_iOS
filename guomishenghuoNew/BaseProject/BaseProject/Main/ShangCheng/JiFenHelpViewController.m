//
//  JiFenHelpViewController.m
//  BaseProject
//
//  Created by 于金祥 on 16/11/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "JiFenHelpViewController.h"

@interface JiFenHelpViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView * webView;
@end

@implementation JiFenHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _lblTitle.text=@"帮助";
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.webView.delegate=self;
    self.webView.scalesPageToFit=NO;
    //    self.webView.scrollView.bounces = NO ;
    self.webView.scrollView.showsHorizontalScrollIndicator=NO;
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:_webView];
    NSURL * webUrl=[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,@"Help.aspx")];
    [_webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [_app_ hiddenTabBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
