//
//  AboutUsViewController.m
//  LikeAttention
//
//  Created by 于金祥 on 15/12/14.
//  Copyright © 2015年 zykj.LikeAttention. All rights reserved.
//

#import "AboutUsViewController.h"
//#import "DataProvider.h"
#import "UIImageView+WebCache.h"

#import "AppDelegate.h"

@interface AboutUsViewController (){
//    DataProvider *mDataProvider;
    
}
@property (nonatomic,strong)UIWebView * mainWebView;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.text=@"关于果米";
    [self.view addSubview:self.mainWebView];
    
}

//隐藏tabbar
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(UIWebView *)mainWebView
{
    if (!_mainWebView) {
        _mainWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _mainWebView.scalesPageToFit=YES;
        [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@About.aspx",BaseImgUrl)]]];
    }
    return _mainWebView;
}





@end
