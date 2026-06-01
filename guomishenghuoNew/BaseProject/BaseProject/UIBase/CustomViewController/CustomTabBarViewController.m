//
//  CustomTabBarViewController.m
//  Blinq
//
//  Created by Sugar on 13-8-12.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "UIImage+NSBundle.h"
#import "IMRecentListViewController.h"

/**
 *    设置此处和customBaseViewControllers
 */

//#define TabBarImgs ([[NSArray alloc] initWithObjects:        \
//                                                        @"shouyehui@2x.png",          \
//                                                        @"shangjiahui@2x.png",       \
//                                                        @"shangchenghui@2x.png",         \
//                                                        @"wodehui@2x.png",      \
//                                                        @"gengduohui@2x.png",      \
//                                                         nil]) //在此处定义tabbar的图片
//#define TabBarSeletedImgs ([[NSArray alloc] initWithObjects:        \
//@"shouyehuang@2x.png",          \
//@"shangjiahuang@2x.png",       \
//@"shangchenghuang@2x.png",         \
//@"wodehuang@2x.png",      \
//@"gengduohuang@2x.png",      \
//nil])//tabbar的选中状态的图片
//#define TabBarImgs ([[NSArray alloc] initWithObjects:        \
//@"shouyehui@2x.png",          \
//@"shangjiahui@2x.png",         \
//@"wodehui@2x.png",      \
//@"gengduohui@2x.png",      \
//nil]) //在此处定义tabbar的图片
//#define TabBarSeletedImgs ([[NSArray alloc] initWithObjects:        \
//@"shouyehuang@2x.png",          \
//@"shangjiahuang@2x.png",       \
//@"wodehuang@2x.png",      \
//@"gengduohuang@2x.png",      \
//nil])//tabbar的选中状态的图片

//#define TabBarImgs ([[NSArray alloc] initWithObjects:        \
//@"shouyehui@2x.png",        \
//@"shangchenghui@2x.png",         \
//@"wodehui@2x.png",      \
//@"gengduohui@2x.png",      \
//nil]) //在此处定义tabbar的图片
//#define TabBarSeletedImgs ([[NSArray alloc] initWithObjects:        \
//@"shouyehuang@2x.png",        \
//@"shangchenghuang@2x.png",         \
//@"wodehuang@2x.png",      \
//@"gengduohuang@2x.png",      \
//nil])//tabbar的选中状态的图片




#define TabBarImgs ([[NSArray alloc] initWithObjects:        \
@"shouye@2x.png",        \
@"duiguan@2x.png",         \
@"tuiguang@2x.png",      \
@"wode@2x.png",      \
nil]) //在此处定义tabbar的图片
#define TabBarSeletedImgs ([[NSArray alloc] initWithObjects:        \
@"shouye_sel@2x.png",        \
@"duihuan_sel@2x.png",         \
@"tuiguang_sel@2x.png",      \
@"wode_sel@2x.png",      \
nil])//tabbar的选中状态的图片

@interface CustomTabBarViewController ()
{
    NSArray *_arrayImages;
    UIButton *_btnSelected;
    UIView *_tabBarBG;
    
    NSMutableArray *btnArr;
    MainViewController *HomeView;
}
@end

@implementation CustomTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏系统tabbar
    self.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectTableBarIndex:) name:@"setSelectTableBarIndex" object:nil];
    
    NSArray *arrayImages = TabBarImgs;
    NSArray *arraySeletedImages = TabBarSeletedImgs;
    _tabBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (TabBar_HEIGHT*(SCREEN_WIDTH/320)), SCREEN_WIDTH, TabBar_HEIGHT*(SCREEN_WIDTH/320))];
    _tabBarBG.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_tabBarBG];
    
    
    btnArr = [NSMutableArray array];
    int tabBarWitdh = SCREEN_WIDTH * 1.0f / TabBarImgs.count;
    for(int i = 0; i < TabBarImgs.count; i++)
    {
        CGRect frame=CGRectMake(i * tabBarWitdh, 0, tabBarWitdh, TabBar_HEIGHT*(SCREEN_WIDTH/320));
        
        UIButton * btnTabBar = [[UIButton alloc] initWithFrame:frame];
        [btnTabBar setImage: [UIImage imageWithBundleName:[arrayImages objectAtIndex:i]] forState:UIControlStateNormal];
        [btnTabBar setImage:[UIImage imageWithBundleName:[arraySeletedImages objectAtIndex:i]] forState:UIControlStateSelected];
        
        btnTabBar.titleLabel.font=[UIFont systemFontOfSize:8.0];
        btnTabBar.titleLabel.textAlignment=NSTextAlignmentCenter;
        
        btnTabBar.tag = i + 1000;
        [btnTabBar addTarget:self action:@selector(onTabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarBG addSubview:btnTabBar];
        [btnArr addObject:btnTabBar];
        
        
    }
    
    
    //加入到真正的tabbar
    //fix me 商铺选项卡暂时隐藏
    self.viewControllers= [self customBaseViewControllers];
    
    UIButton *btnSender = (UIButton *)[self.view viewWithTag:0 + 1000];
    [self onTabButtonPressed:btnSender];
    
    
}

//该方法创建tabbar的页面
-(NSArray<UIViewController *>*)customBaseViewControllers
{

    HomeView=[[MainViewController alloc]init];
    HomeView.DoNotcheckLogin = YES;
//    if ([Toolkit isSystemIOS7]||[Toolkit isSystemIOS8])
//        HomeView.automaticallyAdjustsScrollViewInsets = NO;
    BaseNavViewController * homeviewnav=[[BaseNavViewController alloc]initWithRootViewController:HomeView];
    HomeView.hidesBottomBarWhenPushed = YES;
    homeviewnav.navigationBar.hidden=YES;
    
    firstViewController *techniciansViewCtl = [[firstViewController alloc]init];
    BaseNavViewController *techniciansViewnav = [[BaseNavViewController alloc] initWithRootViewController:techniciansViewCtl];
    techniciansViewCtl.hidesBottomBarWhenPushed=YES;
    techniciansViewnav.navigationBar.hidden=YES;
    
    SecondNewViewController *cateViewCtl=[[SecondNewViewController alloc]init];
    BaseNavViewController *cateViewnav = [[BaseNavViewController alloc] initWithRootViewController:cateViewCtl];
    cateViewCtl.hidesBottomBarWhenPushed = YES;
    cateViewnav.navigationBarHidden=YES;
    //消息
    /*Key :    25wehl3u284kw
     Secret :      f7AoDweTWb4KeO*/
    
//    TuiguangViewController *tuiguangVc=[[TuiguangViewController alloc]init];
//    BaseNavViewController *tuiguangNav = [[BaseNavViewController alloc] initWithRootViewController:tuiguangVc];
//    tuiguangVc.hidesBottomBarWhenPushed = YES;
//    tuiguangNav.navigationBarHidden=YES;

    IMRecentListViewController *tuiguangVc=[[IMRecentListViewController alloc]init];
    BaseNavViewController *tuiguangNav = [[BaseNavViewController alloc] initWithRootViewController:tuiguangVc];
    tuiguangVc.hidesBottomBarWhenPushed = YES;
    tuiguangNav.navigationBarHidden=YES;
    
    ThirdViewController *orderViewCtl = [[ThirdViewController alloc] init];
    BaseNavViewController *ordernav = [[BaseNavViewController alloc] initWithRootViewController:orderViewCtl];
    orderViewCtl.hidesBottomBarWhenPushed=YES;
    ordernav.navigationBar.hidden=YES;
    
//    MoreViewController *moreViewCtl = [[MoreViewController alloc] init];
//    BaseNavViewController *morenav = [[BaseNavViewController alloc] initWithRootViewController:moreViewCtl];
//    moreViewCtl.hidesBottomBarWhenPushed=YES;
//    morenav.navigationBar.hidden=YES;
    
    return @[homeviewnav,cateViewnav,tuiguangNav,ordernav];
//    [NSArray arrayWithObjects:homeviewnav,cateViewnav,ordernav,morenav,nil];
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];//UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}


//点击tab页时的响应
-(void)onTabButtonPressed:(UIButton *)sender
{
    
//    sender.backgroundColor = [UIColor redColor];
    for(int i = 0;i<btnArr.count;i++)
    {
        UIButton *tempBtn;
        if(i == sender.tag-1000)
            continue;
        tempBtn = btnArr[i];
//        tempBtn.backgroundColor = NAVBAR_COLOR;
    }
    
    if (_btnSelected == sender)
        return ;
    
    if (_btnSelected)
        _btnSelected.selected = !_btnSelected.selected;
    
    sender.selected = !sender.selected;
    _btnSelected = sender;
    [self setSelectedIndex:sender.tag - 1000];
}

- (void)selectTableBarIndex:(NSInteger)index
{
    if (index < 0 || index > 5)
        return ;
    UIButton *btnSender = (UIButton *)[self.view viewWithTag:index + 1000];
    [self onTabButtonPressed:btnSender];
}

-(void)setSelectTableBarIndex:(id)sender
{
    
    NSInteger index = [[[sender userInfo]objectForKey:@"index"] integerValue];
    [self onTabButtonPressed:[btnArr objectAtIndex:index]];

    [self setSelectedIndex:index];
    
    if (index == 0) {
        [HomeView.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

//隐藏tabbar
- (void)hideCustomTabBar
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.1];
	_tabBarBG.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _tabBarBG.frame.size.height);
    
    [self.tabBar setHidden:YES];
    
	[UIView commitAnimations];
	
}
//显示tabbar
-(void)showTabBar
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.1];
	_tabBarBG.frame=CGRectMake(0, SCREEN_HEIGHT - (TabBar_HEIGHT*(SCREEN_WIDTH/320)), SCREEN_WIDTH, _tabBarBG.frame.size.height);
    [self.tabBar setHidden:YES];
	[UIView commitAnimations];
}

- (void)goToHomePage
{
    [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
