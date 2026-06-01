//
//  IndexCateViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "IndexCateViewController.h"
#import "SDCycleScrollView.h"
#import "SellerCell.h"
#import "ShopListViewController.h"
#import "DataProviderOther.h"
#import "WJDropdownMenu.h"
#import "NearlyMapViewController.h"
#import "CWStarRateView.h"
#import "Index_ShopInfoViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"

@interface IndexCateViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,WJMenuDelegate>
@property (nonatomic,strong) UITableView * mainTableView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;//轮播图
@property (nonatomic,strong) UIScrollView *mainScorllView;//分类

@property (nonatomic, strong) NSMutableArray *classifys;
@property (nonatomic, strong) NSMutableArray *areas;
@property (nonatomic, strong) NSMutableArray *sorts;
@property (nonatomic, strong) NSMutableArray *shaixuan;

@property (nonatomic, strong) NSMutableArray *juliArray;
@property (nonatomic,strong)NSMutableArray *data;

@end

@implementation IndexCateViewController
{
    WJDropdownMenu *menu;
    UIPageControl *_pageControl;
    UIView *headerview;
    BOOL mnueIsShow;
    NSArray * fenLeiArray;
    NSArray * xianquArray;
    NSArray * FirstMMMMM;//全部分类菜单数据
    NSArray * SecondMMMMM;//县区菜单数据
    NSArray * ThirdMMMMM;//排序数据
    
    
    NSInteger pageNo;
    NSInteger pageSize;
    NSString * fenleiID;
    NSString * length;
    NSString * areaID;
    NSString * orderID;
    NSArray * shopListData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mnueIsShow=YES;
    pageSize=10;
    areaID=get_sp(@"city_Id");
    orderID=@"1";
    length=@"-1";
    fenleiID=_ParientID;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowMnue) name:@"showMnue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HideMnue) name:@"hideMenu" object:nil];
    NSDictionary *firstobject =@{@"categoryid":@"0",@"name":@"全部",@"type":@"0"};
    self.classifys =[[NSMutableArray alloc] initWithObjects:firstobject, nil];
    NSDictionary *secondobject =@{@"cityid":@"0",@"cityname":@"附近",@"type":@"0"};
    self.areas = [[NSMutableArray alloc] initWithObjects:secondobject, nil];
    self.sorts = [[NSMutableArray alloc] initWithObjects:@"智能排序",@"离我最近",@"好评优先", nil];
    self.shaixuan=[[NSMutableArray alloc] initWithObjects:@"筛选",@"卡券",@"免预约",@"有偿广告", nil];
    
    self.juliArray=[[NSMutableArray alloc]initWithObjects:@"全部",@"500米",@"1000米",@"2000米",@"3000米", nil];

    
    [self.view addSubview:self.mainTableView];
    
//    [self BuildheaderView];
    
    [self BuildTopView];
    [self startGetIndexData];
    
}
-(void)ShowMnue
{
    mnueIsShow=NO;
    [self.mainTableView reloadData];
}
-(void)HideMnue
{
    mnueIsShow=YES;
    [self.mainTableView reloadData];
}

-(void)startGetIndexData
{
//    [self GetLunBoTu];
    [self GetFenLei];
    [self GetShopData];
}

-(void)GetCityNext
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetCityNextCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetCityNext:get_sp(@"city_Id")];
}
-(void)GetCityNextCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        xianquArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        NSMutableArray * itemArray1=[[NSMutableArray alloc] init];
        NSMutableArray * itemArray2=[[NSMutableArray alloc] init];
        for (NSDictionary * itemitemdict in dict[@"data"]) {
            [itemArray1 addObject:itemitemdict[@"Name"]];
            [itemArray2 addObject:self.juliArray];
        }
        SecondMMMMM=[NSArray arrayWithObjects:itemArray1,itemArray2, nil];
        [self CreatMenu:FirstMMMMM andsecondcolom:SecondMMMMM andThirdcolom:ThirdMMMMM];
    }
}
-(void)GetAllFenLei
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetAllFenLeiCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetAllFenLei];
}
-(void)GetAllFenLeiCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        @try {
            NSMutableDictionary * dictall=[[NSMutableDictionary alloc] init];
            [dictall setObject:@"0" forKey:@"Id"];
            [dictall setObject:@"全部" forKey:@"Name"];
            NSDictionary * quanbu=[[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"Id",@"全部",@"Name", nil];
            [dictall setObject:@[quanbu] forKey:@"Children"];
            NSMutableArray * addall=[[NSMutableArray alloc] init];
            [addall addObject:dictall];
            [addall addObjectsFromArray:dict[@"data"]];
            fenLeiArray=[[NSArray alloc] initWithArray:addall];
            [self.classifys addObjectsFromArray:fenLeiArray];
            //        fenLeiArray=[[NSArray alloc] initWithArray:dict[@"data"]];
            //        [self.classifys addObjectsFromArray:fenLeiArray];
            
            
            //  创建第一个菜单的first数据second数据
            
            NSMutableArray * firstArrayM=[[NSMutableArray alloc] init];
            NSMutableArray * firstArrayyiji=[[NSMutableArray alloc] init];
            
            for (NSDictionary * itemdict in fenLeiArray) {
                NSMutableArray * itemArray1=[[NSMutableArray alloc] init];
                for (NSDictionary * itemitemdict in itemdict[@"Children"]) {
                    [itemArray1 addObject:itemitemdict[@"Name"]];
                }
                [firstArrayM addObject:itemArray1];
                [firstArrayyiji addObject:itemdict[@"Name"]];
            }
            FirstMMMMM=[[NSArray alloc] initWithObjects:firstArrayyiji,firstArrayM, nil];
            
            //  创建第三个菜单的first数据second数据
            NSArray *firstArrThree = [NSArray arrayWithObjects:@"智能排序",@"离我最近",@"好评优先", nil];
            ThirdMMMMM = [NSArray arrayWithObjects:firstArrThree, nil];
            
            
            
            
            
            
            
            menu = [[WJDropdownMenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            menu.delegate = self;         //  设置代理
            
            
            // 设置属性(可不设置)
            menu.caverAnimationTime = 0.2;             //  增加了展开动画时间设置   不设置默认是  0.15
            menu.hideAnimationTime = 0.2;              //  增加了缩进动画时间设置   不设置默认是  0.15
            menu.menuTitleFont = 12;                   //  设置menuTitle字体大小    不设置默认是  11
            menu.tableTitleFont = 11;                  //  设置tableTitle字体大小   不设置默认是  10
            menu.cellHeight = 38;                      //  设置tableViewcell高度   不设置默认是  40
            menu.menuArrowStyle = menuArrowStyleSolid; //  旋转箭头的样式(空心箭头 or 实心箭头)
            menu.tableViewMaxHeight = 200;             //  tableView的最大高度(超过此高度就可以滑动显示)
            menu.menuButtonTag = 100;                  //  menu定义了一个tag值如果与本页面的其他button的值有冲突重合可以自定义设置
            menu.CarverViewColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];//设置遮罩层颜色
            menu.selectedColor = [UIColor redColor];   //  选中的字体颜色
            menu.unSelectedColor = [UIColor grayColor];//  未选中的字体颜色
            
            [self CreatMenu:FirstMMMMM andsecondcolom:SecondMMMMM andThirdcolom:ThirdMMMMM];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}

-(void)CreatMenu:(NSArray *)firstcolom andsecondcolom:(NSArray * )secondcolom andThirdcolom:(NSArray * )thirdcolom
{
    if (firstcolom&&secondcolom&&thirdcolom) {
        NSArray *threeMenuTitleArray =  @[@"全部",@"附近",@"智能排序"];
        [menu createThreeMenuTitleArray:threeMenuTitleArray FirstArr:firstcolom SecondArr:secondcolom threeArr:thirdcolom];
        
        // 设置rightItem点击收缩menu
        [self createRightNav];
        
        [self.mainTableView reloadData];
    }
    
}

#pragma mark -- 代理方法1 返回点击时对应的index

- (void)menuCellDidSelected:(NSInteger)MenuTitleIndex firstIndex:(NSInteger)firstIndex secondIndex:(NSInteger)secondIndex thirdIndex:(NSInteger)thirdIndex{
    NSLog(@"菜单数:%ld      一级菜单数:%ld      二级子菜单数:%ld  三级子菜单:%ld",(long)MenuTitleIndex,(long)firstIndex,(long)secondIndex,(long)thirdIndex);
    switch (MenuTitleIndex) {
        case 0:
        {
            NSArray * itemarray=[[NSArray alloc] initWithArray:fenLeiArray[firstIndex][@"Children"]];
            if (secondIndex!=-1) {
                fenleiID=[NSString stringWithFormat:@"%@",itemarray[secondIndex][@"Id"]];
            }
            else
            {
                fenleiID=[NSString stringWithFormat:@"%@",fenLeiArray[firstIndex][@"Id"]];
            }
        }
            break;
        case 1:
        {
            areaID=[NSString stringWithFormat:@"%@",xianquArray[firstIndex][@"Id"]];
            length=[NSString stringWithFormat:@"%ld",(long)secondIndex];
        }
            break;
        case 2:
        {
            orderID=[NSString stringWithFormat:@"%ld",(long)firstIndex];
        }
            break;
        default:
            break;
    }
    [self GetShopData];
    
};


#pragma mark -- 代理方法2 返回点击时对应的内容
- (void)menuCellDidSelected:(NSString *)MenuTitle firstContent:(NSString *)firstContent secondContent:(NSString *)secondContent thirdContent:(NSString *)thirdContent{
    
    NSLog(@"菜单title:%@       一级菜单:%@         二级子菜单:%@    三级子菜单:%@",MenuTitle,firstContent,secondContent,thirdContent);
    
    
    self.data = [NSMutableArray array];
    [self.data addObject:[NSString stringWithFormat:@"%@ 的 detail data 1",secondContent]];
    [self.data addObject:[NSString stringWithFormat:@"%@ 的 detail data 2",secondContent]];
    [self.data addObject:[NSString stringWithFormat:@"%@ 的 detail data 3",secondContent]];
    [self.mainTableView reloadData];
    
};


-(void)GetLunBoTu
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetLunbotuCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetLunBoTuSecond:get_sp(@"city_Id") andtype:@"3"];
}
-(void)GetLunbotuCallBack:(id)dict
{
    DLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        [_cycleScrollView removeFromSuperview];
        NSArray * sliderArray=[[NSArray alloc] initWithArray:dict[@"data"]];
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
        // 创建带标题的图片轮播器
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerview.frame.size.height*0.315) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //        cycleScrollView2.titlesGroup = titles;
        _cycleScrollView.imageURLStringsGroup = images;
        [headerview addSubview:_cycleScrollView];
    }
}
-(void)GetFenLei
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetFenLeiCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetFenLeiSecond:self.ParientID];
}
-(void)GetFenLeiCallBack:(id)dict
{
    DLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        //410*(SCREEN_HEIGHT/568)
        headerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.385)];
        headerview.backgroundColor=[UIColor whiteColor];
        [self.mainScorllView removeFromSuperview];
        NSMutableArray * mDataArray=[[NSMutableArray alloc] initWithArray:dict[@"data"]];
        
        if (mDataArray.count>0) {
            self.mainScorllView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleScrollView.frame), SCREEN_WIDTH, headerview.frame.size.height)];
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
            self.mainTableView.tableHeaderView=headerview;
//            [self.mainTableView reloadData];
        }
        
        
    }
}

-(void)BuildTopView
{
    UIButton * btn_search=[[UIButton alloc] init];
    btn_search.bounds=CGRectMake(0, 0, SCREEN_WIDTH-120, 30);
    btn_search.center=CGPointMake(SCREEN_WIDTH/2, 42);
    btn_search.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
    [btn_search setTitle:@"     请输入商家名称" forState:UIControlStateNormal];
    btn_search.layer.masksToBounds=YES;
    [btn_search addTarget:self action:@selector(JumpToSearch) forControlEvents:UIControlEventTouchUpInside];
    btn_search.layer.cornerRadius=15;
    btn_search.titleLabel.font=[UIFont systemFontOfSize:14];
    UIImageView * img_search=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    img_search.image=[UIImage imageNamed:@"sousuo"];
    [btn_search addSubview:img_search];
    [self.view addSubview:btn_search];
    
    
    
    
//    
//    UIButton * btn_scanVC=[[UIButton alloc] initWithFrame:CGRectMake(btn_MessageVC.frame.origin.x-25, btn_search.frame.origin.y, 25, 30)];
//    [btn_scanVC setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
//    [self.view addSubview:btn_scanVC];
    
    
}
-(void)JumpToSearch
{
    SearchViewController * searchVC=[[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


-(void)BuildheaderView
{
    //410*(SCREEN_HEIGHT/568)
    headerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.315)];
    headerview.backgroundColor=[UIColor whiteColor];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    UIImageView * img=[[UIImageView alloc] init];
    [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"] ];
    [images addObject:img];
    // 创建带标题的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerview.frame.size.height*0.315) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //        cycleScrollView2.titlesGroup = titles;
    _cycleScrollView.imageURLStringsGroup = images;
    [headerview addSubview:_cycleScrollView];
//    //
//    //    /220*(SCREEN_HEIGHT/568)
//    self.mainScorllView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleScrollView.frame), SCREEN_WIDTH, SCREEN_HEIGHT*0.35)];
//    CGFloat itemwidth=(SCREEN_WIDTH-95)/4;
//    CGFloat itemJiange=(SCREEN_WIDTH-(itemwidth*4))/5;
//    for (int i = 0; i < 3; ++i) {
//        UIView *item=[[UIView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 10, SCREEN_WIDTH, headerview.frame.size.height*0.55)];
//        item.backgroundColor=[UIColor whiteColor];
//        for (int j=0; j<8; j++) {
//            UIButton * btn_pinglun = nil;
//            if (j<4) {
//                btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(itemJiange+(j%4)*(itemwidth+itemJiange),(j/4)*(itemwidth+itemJiange), itemwidth, itemwidth)];
//            }else{
//                btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(itemJiange+(j%4)*(itemwidth+itemJiange),(j/4)*(itemwidth+itemJiange+20), itemwidth, itemwidth)];
//            }
//            btn_pinglun.tag=i*8+j;
//            
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, btn_pinglun.frame.size.width, btn_pinglun.frame.size.height)];
//            //            NSString *img = mDataArray.count == 0?@"":[mDataArray valueForKey:@"iconList"][i*8 + j][@"imgpath"]?[mDataArray valueForKey:@"iconList"][i*8 + j][@"imgpath"]:@"";
//            NSString *url = [NSString stringWithFormat:@"%@%@",BaseImgUrl,@""];
//            [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"gengduo"]];
//            [btn_pinglun addSubview:imgView];
//            
//            //[btn_pinglun setImage:[UIImage imageNamed:[NSString stringWithFormat:@"item_%d",i*8+j+1]] forState:UIControlStateNormal];
//            [btn_pinglun addTarget:self action:@selector(JumpToTypeVC:) forControlEvents:UIControlEventTouchUpInside];
//            [item addSubview:btn_pinglun];
//            
//            UILabel *lbl_name = [[UILabel alloc] initWithFrame:CGRectMake(itemJiange+(j%4)*(itemwidth+itemJiange), btn_pinglun.frame.origin.y + btn_pinglun.frame.size.height-10, itemwidth, 50)];
//            lbl_name.numberOfLines = 2;
//            lbl_name.lineBreakMode = NSLineBreakByWordWrapping;
//            lbl_name.textAlignment = NSTextAlignmentCenter;
//            //            lbl_name.text = mDataArray.count == 0?@"":[mDataArray valueForKey:@"iconList"][i*8 + j][@"name"]?[mDataArray valueForKey:@"iconList"][i*8 + j][@"name"]:@"";
//            lbl_name.text=@"一级分类";
//            lbl_name.font = [UIFont systemFontOfSize:14];
//            [item addSubview:lbl_name];
//        }
//        [self.mainScorllView addSubview:item];
//    }
//    // height == 0 代表 禁止垂直方向滚动
//    self.mainScorllView.contentSize = CGSizeMake(2 * SCREEN_WIDTH, 0);
//    self.mainScorllView.showsHorizontalScrollIndicator = NO;
//    self.mainScorllView.pagingEnabled = YES;
//    self.mainScorllView.delegate = self;
//    [headerview addSubview:self.mainScorllView];
//    // 添加PageControl
//    UIPageControl *pageControl = [[UIPageControl alloc] init];
//    pageControl.center = CGPointMake(SCREEN_WIDTH * 0.5, headerview.frame.size.height*0.95);
//    pageControl.bounds = CGRectMake(0, 0, 150, 50);
//    pageControl.numberOfPages = 2; // 一共显示多少个圆点（多少页）
//    // 设置非选中页的圆点颜色
//    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    // 设置选中页的圆点颜色
//    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
//    
//    // 禁止默认的点击功能
//    pageControl.enabled = NO;
//    [headerview addSubview:pageControl];
//    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, headerview.frame.size.height-5, headerview.frame.size.width, 5)];
//    fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
//    [headerview addSubview:fenge];
//    _pageControl = pageControl;
    _mainTableView.tableHeaderView=headerview;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
   
    
}
-(void)JumpToTypeVC:(UIButton *)sender
{
    ShopListViewController * shopListVC=[[ShopListViewController alloc] init];
    shopListVC.type=ZY_NSStringFromFormat(@"%ld",(long)sender.tag);
    [self.navigationController pushViewController:shopListVC animated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (shopListData) {
        return shopListData.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 100;
    }
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        if (!mnueIsShow) {
            return 270;
        }
        return 40;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
//        if (!menu) {
//            menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
//            menu.delegate = self;
//            menu.dataSource = self;
//        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, mnueIsShow?70:300)];
        view.backgroundColor = RGB(236, 234, 241);
        [self.view addSubview:view];
//        [view addSubview:menu];
        
        if (!menu) {
            menu = [[WJDropdownMenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            menu.delegate = self;         //  设置代理
            
            
            // 设置属性(可不设置)
            menu.caverAnimationTime = 0.2;             //  增加了展开动画时间设置   不设置默认是  0.15
            menu.hideAnimationTime = 0.2;              //  增加了缩进动画时间设置   不设置默认是  0.15
            menu.menuTitleFont = 12;                   //  设置menuTitle字体大小    不设置默认是  11
            menu.tableTitleFont = 11;                  //  设置tableTitle字体大小   不设置默认是  10
            menu.cellHeight = 38;                      //  设置tableViewcell高度   不设置默认是  40
            menu.menuArrowStyle = menuArrowStyleSolid; //  旋转箭头的样式(空心箭头 or 实心箭头)
            menu.tableViewMaxHeight = 200;             //  tableView的最大高度(超过此高度就可以滑动显示)
            menu.menuButtonTag = 100;                  //  menu定义了一个tag值如果与本页面的其他button的值有冲突重合可以自定义设置
            menu.CarverViewColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];//设置遮罩层颜色
            menu.selectedColor = [UIColor redColor];   //  选中的字体颜色
            menu.unSelectedColor = [UIColor grayColor];//  未选中的字体颜色
            

            // 第一种方法一次性导入所有菜单数据
            [self createAllMenuData];
            
            // 第二中方法net网络请求一级一级导入数据，先在此导入菜单数据，然后分别再后面的net开头的代理方法中导入一级一级子菜单的数据
            //[menu netCreateMenuTitleArray:threeMenuTitleArray];
            
            // 设置rightItem点击收缩menu
            [self createRightNav];
        }
        
        [view addSubview:menu];
//        UILabel *dreLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, view.frame.size.height-20, SCREEN_WIDTH-50, 20)];
//        dreLabel.text = get_sp(@"addressString");
////        [dreLabel sizeToFit];
//        dreLabel.font=[UIFont systemFontOfSize:14];
//        dreLabel.textColor = RGB(158, 158, 156);
//        dreLabel.tag = 102;
//        [view addSubview:dreLabel];
//        
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width-20-10, view.frame.size.height-20, 24, 20)];
//        [view addSubview:btn];
//        [btn setBackgroundImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }
    else
    {
        return nil;
    }
}
-(void)refreshClick
{
    [self GetShopData];
}


- (void)createAllMenuData{
    
    NSArray *threeMenuTitleArray =  @[@"全部",@"附近",@"智能排序"];
    //  创建第一个菜单的first数据second数据
    NSArray *firstArrOne = [NSArray arrayWithObjects:@"A一级菜单1",@"A一级菜单2",@"A一级菜单3", nil];
    NSArray *firstMenu = [NSArray arrayWithObject:firstArrOne];
    
    //  创建第二个菜单的first数据second数据
    NSArray *firstArrTwo = [NSArray arrayWithObjects:@"B一级菜单1",@"B一级菜单2", nil];
    NSArray *secondArrTwo = @[@[@"B二级菜单11",@"B二级菜单12"],@[@"B二级菜单21",@"B二级菜单22"]];
    NSArray *thirdArrTwo = @[@[@"B三级菜单11-1",@"B三级菜单11-2",@"B三级菜单11-3"],@[@"B三级菜单12-1",@"B三级菜单12-2"],@[@"B三级菜单21-1",@"B三级菜单21-2"],@[]];
    NSArray *secondMenu = [NSArray arrayWithObjects:firstArrTwo,secondArrTwo,thirdArrTwo, nil];
    
    //  创建第三个菜单的first数据second数据
    NSArray *firstArrThree = [NSArray arrayWithObjects:@"C一级菜单1",@"C一级菜单2", nil];
    NSArray *secondArrThree = @[@[@"C二级菜单11",@"C二级菜单12"],@[]];
    NSArray *threeMenu = [NSArray arrayWithObjects:firstArrThree,secondArrThree, nil];
    
    [menu createThreeMenuTitleArray:threeMenuTitleArray FirstArr:firstMenu SecondArr:secondMenu threeArr:threeMenu];
    
}

- (void)createRightNav{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:@"收缩menu" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)hideMenu{
    //  点击收缩menu
    [menu drawBackMenu];
    mnueIsShow=YES;
    [self.mainTableView reloadData];
}
- (void)moreClick{
    NSLog(@"更多选项");
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellerCell *cell = [SellerCell cellWithTableView:tableView];
    [cell.logoView sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,shopListData[indexPath.section][@"PhotoPath"])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    cell.nameLabel.text=shopListData[indexPath.section][@"Name"];
    cell.score.text=[NSString stringWithFormat:@"人均%@", Zy_JudgeIsNull(shopListData[indexPath.section][@"RenJun"])];
    cell.price.text=ZY_NSStringFromFormat(@"已售%@",shopListData[indexPath.section][@"SeleNum"]);
    cell.distance.text=[NSString stringWithFormat:@"%.2fkm",[shopListData[indexPath.section][@"Length"] floatValue]];
    cell.other.text=shopListData[indexPath.section][@"CategoryName"];
    cell.dress.text=[NSString stringWithFormat:@"消费100送%@", Zy_JudgeIsNull(shopListData[indexPath.section][@"JifenRate"])];
    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,80,12) numberOfStars:5];
    weisheng.scorePercent =[shopListData[indexPath.section][@"AvgScore"] floatValue]/5;
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
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    Index_ShopInfoViewController * index_shopInfoVC=[[Index_ShopInfoViewController alloc] init];
    index_shopInfoVC.shopID=shopListData[indexPath.section][@"Id"];
    [self.navigationController pushViewController:index_shopInfoVC animated:YES];
}


-(void)GetShopData
{
    pageNo=0;
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetShopDataCallBack:" setFailBackFunctionName:nil];
    
    
    
    [dataproviderother SelectShopIndexNewRowIndex:ZY_NSStringFromFormat(@"%ld",pageSize*pageNo) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:@"" andcategoryid:fenleiID andlength:length andorder:orderID andareaid:areaID andisallcity:@"1" andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
}
-(void)GetFootShopData
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetFootShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectShopIndexNewRowIndex:ZY_NSStringFromFormat(@"%ld",pageSize*pageNo) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:@"" andcategoryid:fenleiID andlength:length andorder:orderID andareaid:areaID andisallcity:@"1" andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
}
-(void)GetShopDataCallBack:(id)dict
{
    [self.mainTableView.mj_header endRefreshing];
    if (RequestSuccess(dict)) {
        shopListData=[[NSArray alloc] initWithArray:dict[@"data"]];
        [self.mainTableView reloadData];
        pageNo++;
    }
    
}
-(void)GetFootShopDataCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        NSMutableArray * itemMutableArray=[[NSMutableArray alloc] initWithArray:shopListData];
        for (NSDictionary * itemDict in dict[@"data"]) {
            [itemMutableArray addObject:itemDict];
        }
        shopListData=[[NSArray alloc] initWithArray:itemMutableArray];
        [self.mainTableView reloadData];
        pageNo++;
        
    }
    
    [_mainTableView.mj_footer endRefreshing];
    
}





-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
        _mainTableView.dataSource=self;
        _mainTableView.delegate=self;
        
        [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 100, 0, 0)];
        _mainTableView.showsVerticalScrollIndicator=NO;
        [_mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//去掉多余cell的线
        __unsafe_unretained __typeof(self) weakSelf = self;
        // 上拉刷新
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf GetFootShopData];
        }];
    }
    return _mainTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self GetAllFenLei];
    [self GetCityNext];
    [_app_ hiddenTabBar];
}

@end
