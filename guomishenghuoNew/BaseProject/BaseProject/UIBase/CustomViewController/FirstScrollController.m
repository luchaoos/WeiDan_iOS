//
//  FirstScrollController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/20.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "FirstScrollController.h"
#import "CustomTabBarViewController.h"
#import "AppDelegate.h"
@interface FirstScrollController ()

@end

@implementation FirstScrollController
@synthesize scrollBG,pageCol;
- (void)viewDidLoad {
    [super viewDidLoad];
    scrollBG=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollBG.delegate=self;
    scrollBG.showsHorizontalScrollIndicator=NO;
    scrollBG.contentSize=CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
    scrollBG.pagingEnabled=YES;
    scrollBG.userInteractionEnabled=YES;
    [self.view addSubview:scrollBG];
    
    for (int i=0; i<3; i++) {
        UIImageView *imgInfo=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
        imgInfo.image=[UIImage imageNamed:[NSString stringWithFormat:@"index_%d.jpg",i]];
        if (i==2) {
            imgInfo.userInteractionEnabled=YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage)];
            [imgInfo addGestureRecognizer:singleTap];
            
//            UIButton * btn_action=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            [btn_action addTarget:self action:@selector(onClickImage) forControlEvents:UIControlEventTouchUpInside];
        }
        [scrollBG addSubview:imgInfo];
    }
    
    pageCol=[[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-30, 320, 20)];
    pageCol.numberOfPages=3;
    //pageCol.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-30);
    [self.view addSubview:pageCol];
    
    pageCol.hidden=YES;
    // Do any additional setup after loading the view from its nib.
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    int pageIndex = fabs(sender.contentOffset.x) /sender.frame.size.width;
    pageCol.currentPage = pageIndex;
    
    if (sender.contentOffset.x>(SCREEN_WIDTH*2+60)) {

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
//        CustomTabBarViewController *_tabBarViewCol = [[CustomTabBarViewController alloc] init];
//        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        app.window.rootViewController =_tabBarViewCol;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView1" object:nil];
    }
    
    
    
}

-(void)onClickImage{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
    //        CustomTabBarViewController *_tabBarViewCol = [[CustomTabBarViewController alloc] init];
    //        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //        app.window.rootViewController =_tabBarViewCol;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView1" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
