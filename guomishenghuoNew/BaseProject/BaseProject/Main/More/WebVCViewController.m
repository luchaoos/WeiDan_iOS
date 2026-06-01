//
//  WebVCViewController.m
//  LikeAttention
//
//  Created by 于金祥 on 15/12/14.
//  Copyright © 2015年 zykj.LikeAttention. All rights reserved.
//

#import "WebVCViewController.h"
#import "AppDelegate.h"
//#import "DataProvider.h"

@interface WebVCViewController ()
@property(strong,nonatomic)UIWebView *webV;

@end

@implementation WebVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"第三方协议声明";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.webV];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(UIWebView *)webV
{
    if (_webV == nil)
    {
        _webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webV.scalesPageToFit=YES;
        [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Xieyi.aspx?id=1",BaseImgUrl]]]];
    }
    
    return _webV;
}
-(void)viewWillAppear:(BOOL)animated
{
    [_app_ hiddenTabBar];
//    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
//    [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@data/guide",KURL]]]];
}


@end
