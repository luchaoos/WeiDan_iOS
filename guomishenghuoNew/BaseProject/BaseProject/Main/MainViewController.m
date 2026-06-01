//
//  MainViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/6/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MainViewController.h"
#import "SDCycleScrollView.h"
#import "IndexCollectionViewCell.h"
#import "IndexCateViewController.h"
#import "FL_Button.h"
#import "lhScanQCodeViewController.h"
#import "SearchViewController.h"
#import "LocationViewController.h"
#import "DataProviderOther.h"
#import "SellerCell.h"
#import "CWStarRateView.h"
#import "SelectCityViewController.h"
#import "Index_ShopInfoViewController.h"
#import "MingDianListViewController.h"
#import "Index_GoodInfoViewController.h"
#import "HotGoodListViewController.h"
#import "LoginViewController.h"
#import "AllClassViewController.h"
#import "NewsCenterViewController.h"
#import "CtrlCodeScan.h"
#import "SearchResultViewController.h"
#import "firstViewController.h"
#import "IndexShopDetailViewController.h"

#define CELL_ID @"cell_id"


@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,CtrlCodeScanDelegate>
@property (nonatomic,strong) UITableView * mainTableView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;//轮播图
@property (nonatomic,strong) UIScrollView *mainScorllView;//分类
@property (nonatomic,strong) UICollectionView * mainCollectionView;
@end

@implementation MainViewController
{
    UIPageControl *_pageControl;
    FL_Button * btn_city;
    UIView * headerview;
    NSArray * mingDianArray;
    NSArray * hotGoodArray;
    NSArray * sliderArray;
    
    NSArray * shopListData;
    
    NSString * mingdianStr;
    
    NSString *jifen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mingdianStr=@"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetCityInfo) name:@"GetLocationSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startGetIndexData) name:@"ChangeCity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeCity) name:@"ChangeCity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanSuccess:) name:@"scanSuccess" object:nil];
    [self.view addSubview:self.mainTableView];
    [self BuildheaderView];
    [self.view bringSubviewToFront:_topView];
    _topView.alpha=0;
    [self BuildTopView];
//
    [self startGetIndexData];
    
    
//    DataProvider *dataProvider = [[DataProvider alloc] init];
//    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"callBackFinish:" setFailBackFunctionName:nil];
//    [dataProvider mallServiceCallBackOrderno:@"2017061700000023" amount:@"216000"];
}

//- (void)callBackFinish:(NSDictionary *)data {
//    NSLog(@"%@", data);
//}

-(void)startGetIndexData
{
    [self GetLunBoTu];
    [self GetFenLei];
    [self GetMingDian];
//    [self GetHotGood];
    [self GetShopData];
}
-(void)GetLunBoTu
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetLunbotuCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetLunBoTu:get_sp(@"city_Id") andtype:@"2"];
}
-(void)GetLunbotuCallBack:(id)dict
{
    DLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        [_cycleScrollView removeFromSuperview];
        sliderArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        //    sliderArray = [mDataArray valueForKey:@"rotationAdvertList"];
            if (sliderArray.count > 0) {
                for (int i=0; i<sliderArray.count; i++) {
                    UIImageView * img=[[UIImageView alloc] init];
                    [img sd_setImageWithURL:[NSURL URLWithString:sliderArray[i][@"ImagePath"]] placeholderImage:[UIImage imageNamed:@"placeholder"] ];
                    [images addObject:sliderArray[i][@"ImagePath"]];
                }
            }
            else
            {
                UIImageView * img=[[UIImageView alloc] init];
                [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"] ];
                [images addObject:@""];
            }
        
        // 网络加载 --- 创建带标题的图片轮播器
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerview.frame.size.height*0.45) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//        cycleScrollView2.titlesGroup = titles;
        _cycleScrollView.imageURLStringsGroup = images;
        _cycleScrollView.currentPageDotColor = NAVBAR_COLOR; // 自定义分页控件小圆标颜色
        [headerview addSubview:_cycleScrollView];
    }
}
-(void)GetFenLei
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetFenLeiCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetFenLei];
}
-(void)GetFenLeiCallBack:(id)dict
{
//    DLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        [self.mainScorllView removeFromSuperview];
        NSMutableArray * mDataArray=[[NSMutableArray alloc] initWithArray:dict[@"data"]];
//        NSDictionary * itemdict=[[NSDictionary alloc] initWithObjectsAndKeys:@"全部",@"Name",@"0",@"Id",@"",@"ImagePath", nil];
//        [mDataArray addObject:itemdict];
        self.mainScorllView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleScrollView.frame), SCREEN_WIDTH, headerview.frame.size.height*0.55)];
        CGFloat itemwidth=(SCREEN_WIDTH)/5;
        CGFloat itemJiange=(SCREEN_WIDTH-(itemwidth*5))/6;
        int page=mDataArray.count%10>0?mDataArray.count/10+1:mDataArray.count/10;
        for (int i = 0; i < page; ++i) {
            UIView *item=[[UIView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 10, SCREEN_WIDTH, headerview.frame.size.height*0.55)];
            item.backgroundColor=[UIColor whiteColor];
            int itemNumber=10;
            if ((i+1)==page) {
                itemNumber=mDataArray.count-(i*10);
            }
            for (int j=0; j<itemNumber; j++) {
                UIButton * btn_pinglun = nil;
                if (j<4) {
                    btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(itemJiange+(j%5)*(itemwidth+itemJiange),(j/5)*(itemwidth+itemJiange), itemwidth, itemwidth)];
                }else{
                    btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(itemJiange+(j%5)*(itemwidth+itemJiange),(j/5)*(itemwidth+itemJiange+20), itemwidth, itemwidth)];
                }
                btn_pinglun.tag= (mDataArray.count == 0?0:[mDataArray[i*10 + j][@"Id"] intValue]);
                btn_pinglun.layer.masksToBounds=YES;
                btn_pinglun.layer.cornerRadius=itemwidth/2;
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(itemwidth*0.15,itemwidth*0.15, itemwidth*0.7, itemwidth*0.7)];
                NSString *img = (mDataArray.count == 0?@"":mDataArray[i*10 + j][@"ImagePath"]?mDataArray[i*10 + j][@"ImagePath"]:@"");
                NSString *url = [NSString stringWithFormat:@"%@%@",@"",img];
                [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"gengduo"]];
                [btn_pinglun addSubview:imgView];
                
                //[btn_pinglun setImage:[UIImage imageNamed:[NSString stringWithFormat:@"item_%d",i*8+j+1]] forState:UIControlStateNormal];
                [btn_pinglun addTarget:self action:@selector(JumpToTypeVC:) forControlEvents:UIControlEventTouchUpInside];
                [item addSubview:btn_pinglun];
                
                UILabel *lbl_name = [[UILabel alloc] initWithFrame:CGRectMake(itemJiange+(j%5)*(itemwidth+itemJiange), btn_pinglun.frame.origin.y + btn_pinglun.frame.size.height-20, itemwidth, 50)];
                lbl_name.numberOfLines = 2;
                lbl_name.lineBreakMode = NSLineBreakByWordWrapping;
                lbl_name.textAlignment = NSTextAlignmentCenter;
                lbl_name.text = mDataArray.count == 0?@"":mDataArray[i*10 + j][@"Name"]?mDataArray[i*10 + j][@"Name"]:@"";
                lbl_name.font = [UIFont systemFontOfSize:12];
                [item addSubview:lbl_name];
            }
            [self.mainScorllView addSubview:item];
        }
        // height == 0 代表 禁止垂直方向滚动
        self.mainScorllView.contentSize = CGSizeMake(page * SCREEN_WIDTH, 0);
        self.mainScorllView.showsHorizontalScrollIndicator = NO;
        self.mainScorllView.pagingEnabled = YES;
        self.mainScorllView.delegate = self;
        [headerview addSubview:self.mainScorllView];
        // 添加PageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.center = CGPointMake(SCREEN_WIDTH * 0.5, headerview.frame.size.height*0.95);
        pageControl.bounds = CGRectMake(0, 0, 150, 50);
        pageControl.numberOfPages = page; // 一共显示多少个圆点（多少页）
        // 设置非选中页的圆点颜色
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        // 设置选中页的圆点颜色
        pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        
        // 禁止默认的点击功能
        pageControl.enabled = NO;
        [headerview addSubview:pageControl];
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, headerview.frame.size.height-5, headerview.frame.size.width, 5)];
        fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [headerview addSubview:fenge];
    }
}
-(void)GetMingDian
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetMingDianCallBack:" setFailBackFunctionName:nil];
//    [dataproviderother GetMingDian:get_sp(@"city_Id")];
    [dataproviderother GetPicture:get_sp(@"city_Id")];
}
-(void)GetMingDianCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
//        mingDianArray=[[NSArray alloc] initWithArray:dict[@"data"]];
//        [self.mainCollectionView reloadData];
        mingdianStr=dict[@"data"][@"Path"];
        [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    }
}
-(void)GetHotGood
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetHotGoodCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetFotGood:get_sp(@"city_Id") andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
}
-(void)GetHotGoodCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        hotGoodArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)GetShopData
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectShopIndexNewRowIndex:@"0" andmaximumRows:@"6" andsearch:@"" andcategoryid:@"0" andlength:@"100000000" andorder:@"1" andareaid:get_sp(@"city_Id") andisallcity:@"1" andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
    //    [dataproviderother GetShopListstartRowIndex:ZY_NSStringFromFormat(@"%ld",page*pageSize) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:@"" andcategoryid:fenleiID andlength:length andorder:orderID andareaid:areaID];
}
-(void)GetShopDataCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        shopListData=[[NSArray alloc] initWithArray:dict[@"data"]];
        [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}


-(void)GetCityInfo
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetCityInfoCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetCityInfo:get_sp(@"location_City")];
}
-(void)GetCityInfoCallBack:(id)dict
{
//    if (RequestSuccess(dict)) {
//        DLog(@"%@",dict);
//        
//        if (get_sp(@"city_Id")==nil) {
//            
//        }else
//        {
//            if ([[NSString stringWithFormat:@"%@",get_sp(@"city_Id")] isEqualToString:[NSString stringWithFormat:@"%@",dict[@"data"][@"Id"]]]) {
//                return;
//            }
//        }
//        set_sp(@"city_ParentId", dict[@"data"][@"Id"]);
//        set_sp(@"city_Id", dict[@"data"][@"Id"]);
//        set_sp(@"city_Name", dict[@"data"][@"Name"]);
//        [self startGetIndexData];
//    }
    @try {
        if (RequestSuccess(dict)) {
            DLog(@"%@",dict);
            
            if (get_sp(@"city_Id")==nil) {
                
            }else
            {
                if ([[NSString stringWithFormat:@"%@",get_sp(@"city_Id")] isEqualToString:[NSString stringWithFormat:@"%@",dict[@"data"][@"Id"]]]) {
                    return;
                }
            }
            set_sp(@"city_Id", dict[@"data"][@"Id"]);
            set_sp(@"city_Name", dict[@"data"][@"Name"]);
        }
    } @catch (NSException *exception) {
        set_sp(@"city_Id", @"30887");
        set_sp(@"city_Name", @"临沂市");
    } @finally {
        [self startGetIndexData];
    }
}
-(void)BuildTopView
{
    
    UIButton * btn_search=[[UIButton alloc] init];
    btn_search.bounds=CGRectMake(0, 0, SCREEN_WIDTH-160, 30);
    btn_search.center=CGPointMake(SCREEN_WIDTH/2, 42);
    [btn_search addTarget:self action:@selector(JumpToSearch) forControlEvents:UIControlEventTouchUpInside];
    btn_search.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
    btn_search.layer.masksToBounds=YES;
    [btn_search setTitle:@"搜索商铺" forState:UIControlStateNormal];
    btn_search.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn_search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_search.layer.cornerRadius=15;
    UIImageView * img_search=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    img_search.image=[UIImage imageNamed:@"sousuo"];
    [btn_search addSubview:img_search];
    [self.view addSubview:btn_search];
    
    btn_city=[FL_Button fl_shareButton];
    btn_city.status=FLAlignmentStatusRight;
    [btn_city setImage:[UIImage imageNamed:@"chenshidingwei"] forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"city_Name"] ) {
        [btn_city setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"city_Name"] forState:UIControlStateNormal];
    }
    else{
        [btn_city setTitle:@"临沂市" forState:UIControlStateNormal];
    }
    btn_city.titleLabel.font=[UIFont systemFontOfSize:13];
    btn_city.center=CGPointMake((btn_search.frame.origin.x-10)/2-10, 42);
    btn_city.bounds=CGRectMake(0, 0,btn_search.frame.origin.x-10, 30);
    [btn_city setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_city addTarget:self action:@selector(JumpToLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_city];
    
    UIButton * btn_MessageVC=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, btn_search.frame.origin.y, 25, 30)];
    [btn_MessageVC setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [btn_MessageVC addTarget:self action:@selector(JumpToMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_MessageVC];
    
    
    UIButton * btn_scanVC=[[UIButton alloc] initWithFrame:CGRectMake(btn_MessageVC.frame.origin.x-30, btn_search.frame.origin.y, 25, 30)];
    [btn_scanVC setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
//    [btn_scanVC addTarget:self action:@selector(JumpToScan) forControlEvents:UIControlEventTouchUpInside];
    [btn_scanVC addTarget:self action:@selector(JumpToScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_scanVC];
    
    
}

-(void)JumpToMessage
{
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
        NewsCenterViewController * newsCenterVC=[[NewsCenterViewController alloc] init];
        [self.navigationController pushViewController:newsCenterVC animated:YES];
    
}
-(void)JumpToLocation
{
//    LocationViewController * locationVC=[[LocationViewController alloc] init];
//    [self.navigationController pushViewController:locationVC animated:YES];
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    [self.navigationController pushViewController:selectCityVC animated:YES];
}
-(void)JumpToScan
{
    CtrlCodeScan * scanCode=[[CtrlCodeScan alloc] initWithNibName:@"CtrlCodeScan" bundle:[NSBundle mainBundle]];
    scanCode.delegate=self;
    [self.navigationController presentViewController:scanCode animated:YES completion:nil];
}
-(void)JumpToSearch
{
    SearchViewController * searchVC=[[SearchViewController alloc] init];
    searchVC.type=2;
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)JumpToMingDian
{
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    MingDianListViewController * mingdianList=[[MingDianListViewController alloc] init];
    [self.navigationController pushViewController:mingdianList animated:YES];
//    SearchResultViewController * searchResVC=[[SearchResultViewController alloc] init];
//    searchResVC.keyWorld=@"";
//    [self.navigationController pushViewController:searchResVC animated:YES];
}
-(void)BuildheaderView
{
    //410*(SCREEN_HEIGHT/568)
    headerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.7)];
    headerview.backgroundColor=[UIColor whiteColor];
    NSMutableArray *images = [[NSMutableArray alloc] init];
        [images addObject:@""];
    // 创建带标题的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerview.frame.size.height*0.45) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //        cycleScrollView2.titlesGroup = titles;
    _cycleScrollView.imageURLStringsGroup = images;
    [headerview addSubview:_cycleScrollView];
    //
    //    /220*(SCREEN_HEIGHT/568)
    self.mainScorllView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleScrollView.frame), SCREEN_WIDTH, headerview.frame.size.height*0.55)];
    CGFloat itemwidth=(SCREEN_WIDTH-95)/4;
    CGFloat itemJiange=(SCREEN_WIDTH-(itemwidth*4))/5;
    for (int i = 0; i < 3; ++i) {
        UIView *item=[[UIView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 10, SCREEN_WIDTH, headerview.frame.size.height*0.55)];
        item.backgroundColor=[UIColor whiteColor];
        for (int j=0; j<8; j++) {
            UIButton * btn_pinglun = nil;
            if (j<4) {
                btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(itemJiange+(j%4)*(itemwidth+itemJiange),(j/4)*(itemwidth+itemJiange), itemwidth, itemwidth)];
            }else{
                btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(itemJiange+(j%4)*(itemwidth+itemJiange),(j/4)*(itemwidth+itemJiange+20), itemwidth, itemwidth)];
            }
            btn_pinglun.tag=i*8+j;
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, btn_pinglun.frame.size.width, btn_pinglun.frame.size.height)];
//            NSString *img = mDataArray.count == 0?@"":[mDataArray valueForKey:@"iconList"][i*8 + j][@"imgpath"]?[mDataArray valueForKey:@"iconList"][i*8 + j][@"imgpath"]:@"";
            NSString *url = [NSString stringWithFormat:@"%@%@",BaseImgUrl,@""];
            [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"gengduo"]];
            [btn_pinglun addSubview:imgView];
            
            //[btn_pinglun setImage:[UIImage imageNamed:[NSString stringWithFormat:@"item_%d",i*8+j+1]] forState:UIControlStateNormal];
            [btn_pinglun addTarget:self action:@selector(JumpToTypeVC:) forControlEvents:UIControlEventTouchUpInside];
            [item addSubview:btn_pinglun];
            
            UILabel *lbl_name = [[UILabel alloc] initWithFrame:CGRectMake(itemJiange+(j%4)*(itemwidth+itemJiange), btn_pinglun.frame.origin.y + btn_pinglun.frame.size.height-10, itemwidth, 50)];
            lbl_name.numberOfLines = 2;
            lbl_name.lineBreakMode = NSLineBreakByWordWrapping;
            lbl_name.textAlignment = NSTextAlignmentCenter;
//            lbl_name.text = mDataArray.count == 0?@"":[mDataArray valueForKey:@"iconList"][i*8 + j][@"name"]?[mDataArray valueForKey:@"iconList"][i*8 + j][@"name"]:@"";
            lbl_name.text=@"一级分类";
            lbl_name.font = [UIFont systemFontOfSize:14];
            [item addSubview:lbl_name];
        }
        [self.mainScorllView addSubview:item];
    }
    // height == 0 代表 禁止垂直方向滚动
    self.mainScorllView.contentSize = CGSizeMake(2 * SCREEN_WIDTH, 0);
    self.mainScorllView.showsHorizontalScrollIndicator = NO;
    self.mainScorllView.pagingEnabled = YES;
    self.mainScorllView.delegate = self;
    [headerview addSubview:self.mainScorllView];
    // 添加PageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(SCREEN_WIDTH * 0.5, headerview.frame.size.height*0.95);
    pageControl.bounds = CGRectMake(0, 0, 150, 50);
    pageControl.numberOfPages = 2; // 一共显示多少个圆点（多少页）
    // 设置非选中页的圆点颜色 
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    // 设置选中页的圆点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    // 禁止默认的点击功能
    pageControl.enabled = NO;
    [headerview addSubview:pageControl];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, headerview.frame.size.height-5, headerview.frame.size.width, 5)];
    fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [headerview addSubview:fenge];
    _pageControl = pageControl;
    _mainTableView.tableHeaderView=headerview;
    
    
    UIView * footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    footerView.backgroundColor=BACKGROUND_COLOR;
    UIButton * btn_more=[[UIButton alloc] init];
    btn_more.center=CGPointMake(SCREEN_WIDTH/2, 30);
    btn_more.bounds=CGRectMake(0, 0, SCREEN_WIDTH*0.7, 40);
    btn_more.backgroundColor=NAVBAR_COLOR;
    btn_more.layer.masksToBounds=YES;
    btn_more.layer.cornerRadius=6;
    [btn_more setTitle:@"查看更多团购" forState:UIControlStateNormal];
    [btn_more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_more addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn_more];
    _mainTableView.tableFooterView=footerView;
}
- (void)JumpToTypeVC:(UIButton *)clickBtn{
    NSLog(@"暂未开发");
    if (clickBtn.tag==0) {
        AllClassViewController * allclassVC=[[AllClassViewController alloc] init];
        [self.navigationController pushViewController:allclassVC animated:YES];
        return;
    }
    IndexCateViewController * indexCateVC=[[IndexCateViewController alloc] init];
    indexCateVC.ParientID=[NSString stringWithFormat:@"%ld",(long)clickBtn.tag];
    [self.navigationController pushViewController:indexCateVC animated:YES];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    if (!sliderArray) {
//        return;
//    }
//    if (sliderArray.count>0) {
//        if ([[NSString stringWithFormat:@"%@",sliderArray[index][@"ImageUrl"]] length]>0) {
//            Index_GoodInfoViewController * index_goodInfoVC=[[Index_GoodInfoViewController alloc] init];
//            index_goodInfoVC.goodID=sliderArray[index][@"ImageUrl"];
//            [self.navigationController pushViewController:index_goodInfoVC animated:YES];
//        }
//    }
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (shopListData) {
        return shopListData.count>5?5:shopListData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return SCREEN_HEIGHT*0.55;
    }
//    if (indexPath.section==0&&indexPath.row==0) {
//        return 50;
//    }
    return SCREEN_HEIGHT*0.2-20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 60;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UIView * v_line1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.4)];
        v_line1.backgroundColor=[UIColor lightGrayColor];
        [sectionHeaderView addSubview:v_line1];
//        sectionHeaderView.backgroundColor=AppMainColor;
//        NSString *str1 = @"推荐店铺";
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str1];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 8.0;
//        NSDictionary *attrsDictionary1 = @{NSFontAttributeName:[UIFont systemFontOfSize:22],
//                                           NSParagraphStyleAttributeName:paragraphStyle};
//        //给str1添加属性
//        [attributedString addAttributes:attrsDictionary1 range:NSMakeRange(0, str1.length)];
//
//        UILabel * lbl_SectionTitle=[[UILabel alloc] initWithFrame:sectionHeaderView.frame];
//        lbl_SectionTitle.numberOfLines=2;
//        lbl_SectionTitle.attributedText=attributedString;
//        lbl_SectionTitle.textAlignment=NSTextAlignmentCenter;
////        [sectionHeaderView addSubview:lbl_SectionTitle];
        
        UIImageView * imgmingdian=[[UIImageView alloc] init];
        imgmingdian.bounds=CGRectMake(0, 0, 100, 30);
        imgmingdian.center=CGPointMake(55, 30);
        imgmingdian.image=[UIImage imageNamed:@"shangjiadianpu"];
        [sectionHeaderView addSubview:imgmingdian];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 10, 50, 40)];
        [sectionHeaderView addSubview:btn];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitle:@"全部" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 22.5, 15, 15)];
        img_go.image=[UIImage imageNamed:@"iconfont-fanhuiyou"];
        [sectionHeaderView addSubview:img_go];
        
        UIView * v_line=[[UIView alloc] initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH, 0.4)];
        v_line.backgroundColor=[UIColor lightGrayColor];
        [sectionHeaderView addSubview:v_line];
        return sectionHeaderView;
    }
    else
    {
        return nil;
    }
}
- (void)moreClick{
    NSLog(@"更多选项");
//    HotGoodListViewController * hotGoodListVC=[[HotGoodListViewController alloc] init];
//    [self.navigationController pushViewController:hotGoodListVC animated:YES];
//    SearchResultViewController * searchResVC=[[SearchResultViewController alloc] init];
//    searchResVC.keyWorld=@"";
//    [self.navigationController pushViewController:searchResVC animated:YES];
    firstViewController * firstVC=[[firstViewController alloc] init];
    [self.navigationController pushViewController:firstVC animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section==0&&indexPath.row==0) {
//        UITableViewCell * cell=[[UITableViewCell alloc] init];
////        UILabel * lbl_textlabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-50, 44)];
////        lbl_textlabel.text=@"名店抢购";
////        lbl_textlabel.textColor=[UIColor redColor];
////        lbl_textlabel.font=[UIFont systemFontOfSize:16];
////        [cell.contentView addSubview:lbl_textlabel];
//        UIImageView * imgmingdian=[[UIImageView alloc] init];
//        imgmingdian.bounds=CGRectMake(0, 0, 100, 30);
//        imgmingdian.center=CGPointMake(55, 25);
//        imgmingdian.image=[UIImage imageNamed:@"mingdianLOGO.jpg"];
//        [cell.contentView addSubview:imgmingdian];
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        UIView * v_line=[[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.4)];
//        v_line.backgroundColor=[UIColor lightGrayColor];
//        [cell.contentView addSubview:v_line];
//        return cell;
//    }
    if (indexPath.section==0&&indexPath.row==0) {
        UITableViewCell * cell=[[UITableViewCell alloc] init];
//        if (mingDianArray.count>0) {
//            [cell addSubview:self.mainCollectionView];
//        }
        UIImageView * img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        [img_icon sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,mingdianStr)] placeholderImage:[UIImage imageNamed:@""]];
        [cell addSubview:img_icon];
        return cell;
    }
    
//    SellerCell *cell = [SellerCell cellWithTableView:tableView];
//    [cell.logoView sd_setImageWithURL:[NSURL URLWithString:hotGoodArray[indexPath.row][@"ImagePath"]] placeholderImage:[UIImage imageNamed:@"beijing"]];
//    cell.nameLabel.text=hotGoodArray[indexPath.row][@"Name"];
//    cell.price.text=[NSString stringWithFormat:@"￥%@",hotGoodArray[indexPath.row][@"Price"]];
//    cell.distance.text=[NSString stringWithFormat:@"%.2fkm",[hotGoodArray[indexPath.row][@"Length"] floatValue]];
//    cell.other.text=hotGoodArray[indexPath.row][@"CategoryName"];
//    cell.dress.text=@"";
//    cell.score.text=ZY_NSStringFromFormat(@"已售:%@",Zy_JudgeIsNull(hotGoodArray[indexPath.row][@"SeleNum"]));
//    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,80,12) numberOfStars:5];
//    weisheng.scorePercent = [hotGoodArray[indexPath.row][@"AvgScore"] floatValue]/5;
//    weisheng.allowIncompleteStar = NO;
//    weisheng.hasAnimation = YES;
//    [cell.starView addSubview:weisheng];
    
    SellerCell *cell = [SellerCell cellWithTableView:tableView];
    [cell.logoView sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,shopListData[indexPath.row][@"PhotoPath"])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    cell.nameLabel.text=shopListData[indexPath.row][@"Name"];
    cell.score.text=[NSString stringWithFormat:@"人均%@", Zy_JudgeIsNull(shopListData[indexPath.row][@"RenJun"])];
    cell.price.text=ZY_NSStringFromFormat(@"已售%@",shopListData[indexPath.row][@"SeleNum"]);
    cell.distance.text=[NSString stringWithFormat:@"%.2fkm",[shopListData[indexPath.row][@"Length"] floatValue]];
    cell.other.text=shopListData[indexPath.row][@"CategoryName"];
    cell.dress.text=[NSString stringWithFormat:@"消费100送%@", Zy_JudgeIsNull(shopListData[indexPath.row][@"JifenRate"])];
    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,80,12) numberOfStars:5];
    weisheng.scorePercent = [shopListData[indexPath.row][@"AvgScore"] floatValue]/5;
    weisheng.allowIncompleteStar = NO;
    weisheng.hasAnimation = YES;
    [cell.starView addSubview:weisheng];
    cell.price.textColor=[UIColor redColor];
    cell.dress.textColor=[UIColor redColor];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==1) {
        if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
            LoginViewController* loginVC=[[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
//        Index_GoodInfoViewController * index_goodInfoVC=[[Index_GoodInfoViewController alloc] init];
//        index_goodInfoVC.goodID=hotGoodArray[indexPath.row][@"Id"];
//        [self.navigationController pushViewController:index_goodInfoVC animated:YES];
        
        
//        Index_ShopInfoViewController * index_shopInfoVC=[[Index_ShopInfoViewController alloc] init];
//        index_shopInfoVC.shopID=shopListData[indexPath.row][@"Id"];
//        [self.navigationController pushViewController:index_shopInfoVC animated:YES];
        
        IndexShopDetailViewController *vc = [[IndexShopDetailViewController alloc] init];
        vc.shopId = shopListData[indexPath.row][@"Id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self JumpToMingDian];
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mingDianArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell=[[UICollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, SCREEN_WIDTH-20)];
    UIImageView * img_icon=[[UIImageView alloc] initWithFrame:cell.frame];
    [img_icon sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    [cell addSubview:img_icon];
//    IndexCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
//    if (mingDianArray.count>0) {
////        [cell.image_iocn setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.item] forState:UIControlStateNormal];
//        [cell.image sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,mingDianArray[indexPath.item][@"ImagePath"])] placeholderImage:[UIImage imageNamed:@""]];
//        cell.lbl_price.text=[NSString stringWithFormat:@"￥%.2f",[mingDianArray[indexPath.item][@"Price"] floatValue]];
//        cell.detail.text=ZY_NSStringFromFormat(@"%@",mingDianArray[indexPath.item][@"Name"]);
//    }
//    else
//    {
////        [cell.image_iocn setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.item] forState:UIControlStateNormal];
//        [cell.image sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"jiudian"]];
//        cell.lbl_price.text=@"￥300.00";
//    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
//    [self JumpToMingDian];
//    Index_ShopInfoViewController * index_goodInfoVC=[[Index_ShopInfoViewController alloc] init];
//    index_goodInfoVC.shopID=mingDianArray[indexPath.row][@"Id"];
//    [self.navigationController pushViewController:index_goodInfoVC animated:YES];
    Index_GoodInfoViewController * index_goodInfoVC=[[Index_GoodInfoViewController alloc] init];
    index_goodInfoVC.goodID=mingDianArray[indexPath.item][@"Id"];
    [self.navigationController pushViewController:index_goodInfoVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat threholdHeight = 200 - 64;
    if(scrollView.contentOffset.y >= 0 &&
       scrollView.contentOffset.y <= threholdHeight) {
        CGFloat alpha = scrollView.contentOffset.y / threholdHeight;
        _topView.alpha = alpha;
    }
    else if(scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    else {
        _topView.alpha = 1.0;
    }
    
}



-(UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        //每个item的大小
        int  item_length = SCREEN_WIDTH -20;
        layout.itemSize = CGSizeMake(item_length, item_length);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.55) collectionViewLayout:layout];
        self.mainCollectionView.backgroundColor=[UIColor whiteColor];
        [self.mainCollectionView registerClass:[IndexCollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
        //4.设置代理
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
    }
    return _mainCollectionView;
}

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(TabBar_HEIGHT*(SCREEN_WIDTH/320)))];
        _mainTableView.dataSource=self;
        _mainTableView.delegate=self;
        [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        _mainTableView.showsVerticalScrollIndicator=NO;
        [_mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//去掉多余cell的线
    }
    return _mainTableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [_app_ showTabBar];
    
    
}
-(void)scanSuccess:(NSNotification *)notification
{
    
}
- (void)didCodeScanOk:(id)info
{
    if([info containsString:@"http"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:info]];
        return;
        
    }
    else if ([info hasPrefix:@"abd"] ) {
        NSArray *arr = [info componentsSeparatedByString:@","];
        NSString *jfstr = [NSString stringWithFormat:@"商品价值%.2lf分", [arr[2] doubleValue]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扣除积分" message:jfstr preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"submitPointFinish:" setFailBackFunctionName:nil];
            [dataProvider ShopIndexServiceSubmitPointWithShopid:[arr[0] substringFromIndex:3] userid:get_sp(user_ID) priceid:arr[1]];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self presentViewController:alert animated:YES completion:nil];
        });
        return;
        
    }
    else if ([info hasPrefix:@"abc"]) {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扣除积分" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入积分";
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            [textField addTarget:self action:@selector(textFieldEnd:) forControlEvents:UIControlEventEditingDidEnd];
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"submitPointFinish:" setFailBackFunctionName:nil];
            [dataProvider ShopIndexServiceSubmitPointWithShopid:[info substringFromIndex:3] userid:get_sp(user_ID) point:jifen];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self presentViewController:alert animated:YES completion:nil];
        });
        return;
    }
    else
    {
        if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
            Index_ShopInfoViewController * index_goodInfoVC=[[Index_ShopInfoViewController alloc] init];
            index_goodInfoVC.shopID=info;
            [self.navigationController pushViewController:index_goodInfoVC animated:YES];
        }
        else
        {
            LoginViewController* loginVC=[[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        
    }
}

- (void)textFieldEnd:(UITextField *)sender {
    jifen = sender.text;
}

- (void)submitPointFinish:(NSDictionary *)data {
    if (RequestSuccess(data)) {
        [SVProgressHUD showSuccessWithStatus:@"扣除成功"];
    }
}

-(void)ChangeCity{
    [btn_city setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"city_Name"] forState:UIControlStateNormal];
}

@end
