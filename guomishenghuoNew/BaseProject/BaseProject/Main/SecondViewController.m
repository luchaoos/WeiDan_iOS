//
//  SecondViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/6/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "SecondViewController.h"
#import "SDCycleScrollView.h"
#import "IndexCollectionViewCell.h"
#import "FL_Button.h"
#import "ShopDetialViewController.h"
#import "DataProviderOther.h"
#import "SellerCell.h"
#import "CWStarRateView.h"
#import "GoodDetialViewController.h"
#import "LoginViewController.h"
#import "SelectCityViewController.h"
#import "MenuView.h"
#import "JiFenHelpViewController.h"
#import "ShangChengShoppingCarViewController.h"
#import "JiFenShopingCarViewController.h"

#define CELL_ID @"cell_id"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UITableView * mainTableView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;//轮播图
@property (nonatomic,strong) UIScrollView *mainScorllView;//分类
@property (nonatomic,strong) UICollectionView * mainCollectionView;

@property (nonatomic,assign) BOOL flag;

@end

@implementation SecondViewController

{
    UIPageControl *_pageControl;
    
    UIView * headerview;
    
    NSInteger pageNo;
    NSInteger pageSize;
    NSArray * shopListData;
    NSString * areaID;
    
    FL_Button * btn_city;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startGetIndexData) name:@"ChangeCity" object:nil];
    [self.view addSubview:self.mainTableView];
    pageSize=10;
    _imgLeft.hidden=YES;
    [self BuildheaderView];
    _lblTitle.text=@"商城";
//    [self addRightbuttontitle:@"帮助"];
    [self.view bringSubviewToFront:_topView];
    [self.view bringSubviewToFront:_lblTitle];
    _topView.alpha=0;
    [self BuildTopView];
    [self startGetIndexData];
}

-(void)clickRightButton:(UIButton *)sender
{
    ShangChengShoppingCarViewController * shangchengshoppingcarVC=[[ShangChengShoppingCarViewController alloc] init];
    [self presentViewController:shangchengshoppingcarVC animated:YES completion:^{
        
    }];
    

    
    
    
    
}

-(void)startGetIndexData
{
    [btn_city setTitle:get_sp(@"city_Name") forState:UIControlStateNormal];
    areaID=get_sp(@"city_Id");
    [self GetLunBoTu];
    [self GetFenLei];
    [self GetShopData];
}
-(void)GetLunBoTu
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetLunbotuCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetLunBoTuSecond:get_sp(@"city_Id") andtype:@"6"];
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
            [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeHolderlong"] ];
            [images addObject:@""];
        }
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerview.frame.size.height*0.45) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
    [dataproviderother GetShopFenLei];
}
-(void)GetFenLeiCallBack:(id)dict
{
    DLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        [self.mainScorllView removeFromSuperview];
        NSMutableArray * mDataArray=[[NSMutableArray alloc] initWithArray:dict[@"data"]];
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

-(void)BuildTopView
{
    
    [self.view bringSubviewToFront:_lblRight];
    [self.view bringSubviewToFront:_btnRight];
    /**
     *  rightBarButton的点击标记，每次点击更改flag值。
     *  如果您用普通的button就不需要设置flag，通过按钮的seleted属性来控制即可
     */
    self.flag = YES;
    
    /**
     *  这些数据是菜单显示的图片和文字，写在这里，不知合不合理，请各位大牛指教，如果有更好的方法：
     *  e-mail : KongPro@163.com
     *  喜欢请砸github上点颗星星，多谢！
     */
    NSDictionary *dict1 = @{@"imageName" : @"",
                            @"itemName" : @"如何购买"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"",
                            @"itemName" : @"如何获取购物券"
                            };
    NSDictionary *dict3 = @{@"imageName" : @"",
                            @"itemName" : @"服务费与配送费"
                            };
    NSArray *dataArray = @[dict1,dict2,dict3];
    // 计算菜单frame
    CGFloat x = self.view.bounds.size.width / 3 * 2;
    CGFloat y = 64 - 10;
    CGFloat width = self.view.bounds.size.width * 0.3;
    CGFloat height = dataArray.count * 40;  // 40 -> tableView's RowHeight
    __weak __typeof(&*self)weakSelf = self;
    /**
     *  创建menu
     */
    [MenuView createMenuWithFrame:CGRectMake(x, y, width, height) target:self.navigationController dataArray:dataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        // do something
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag];
        
    } backViewTap:^{
        // 点击背景遮罩view后的block，可自定义事件
        // 这里的目的是，让rightButton点击，可再次pop出menu
        weakSelf.flag = YES;
    }];
//        
//    btn_city=[FL_Button fl_shareButton];
//    btn_city.status=FLAlignmentStatusRight;
//    [btn_city setImage:[UIImage imageNamed:@"chenshidingwei"] forState:UIControlStateNormal];
//    [btn_city setTitle:@"临沂市" forState:UIControlStateNormal];
//    btn_city.titleLabel.font=[UIFont systemFontOfSize:13];
//    btn_city.center=CGPointMake(45, 42);
//    btn_city.bounds=CGRectMake(0, 0,60, 30);
//    [btn_city setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn_city addTarget:self action:@selector(JumpToLocation) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn_city];
    
//    UIButton * btn_MessageVC=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, btn_search.frame.origin.y, 25, 30)];
//    [btn_MessageVC setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
//    [self.view addSubview:btn_MessageVC];
//    
//    
//    UIButton * btn_scanVC=[[UIButton alloc] initWithFrame:CGRectMake(btn_MessageVC.frame.origin.x-25, btn_search.frame.origin.y, 25, 30)];
//    [btn_scanVC setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
//    [self.view addSubview:btn_scanVC];
    
    
}
-(void)JumpToLocation
{
    //    LocationViewController * locationVC=[[LocationViewController alloc] init];
    //    [self.navigationController pushViewController:locationVC animated:YES];
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    [self.navigationController pushViewController:selectCityVC animated:YES];
}
-(void)BuildheaderView
{
    //410*(SCREEN_HEIGHT/568)
    headerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.7)];
    headerview.backgroundColor=[UIColor whiteColor];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    UIImageView * img=[[UIImageView alloc] init];
    [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"] ];
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
            //NSString *img = mDataArray.count == 0?@"":[mDataArray valueForKey:@"iconList"][i*8 + j][@"imgpath"]?[mDataArray valueForKey:@"iconList"][i*8 + j][@"imgpath"]:@"";
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
}
- (void)JumpToTypeVC:(UIButton *)clickBtn{
    NSLog(@"暂未开发");
    ShopDetialViewController * shopDetialVC=[[ShopDetialViewController alloc] init];
    shopDetialVC.parentid=ZY_NSStringFromFormat(@"%ld",(long)clickBtn.tag);
    [self.navigationController pushViewController:shopDetialVC animated:YES];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
   
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (shopListData) {
        return shopListData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return SCREEN_HEIGHT*0.2-20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 44;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        sectionHeaderView.backgroundColor=AppMainColor;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-2-50, 7, 50, 30)];
        [sectionHeaderView addSubview:btn];
        [btn setTitle:@"更多" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        
        return sectionHeaderView;
    }
    else
    {
        return nil;
    }
}
- (void)moreClick{
    NSLog(@"更多选项");
    ShopDetialViewController * shopDetialVC=[[ShopDetialViewController alloc] init];
    [self.navigationController pushViewController:shopDetialVC animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellerCell *cell = [SellerCell cellWithTableView:tableView];
    [cell.logoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImgUrl,shopListData[indexPath.row][@"ImagePath"]]] placeholderImage:[UIImage imageNamed:@"beijing"]];
    cell.nameLabel.text=shopListData[indexPath.row][@"Name"];
    cell.price.text=[NSString stringWithFormat:@"￥%@",shopListData[indexPath.row][@"Price"]];
    cell.other.text=Zy_JudgeIsNull(shopListData[indexPath.row][@"CategoryName"]);
    cell.distance.text=[Toolkit judgeIsNull:[NSString stringWithFormat:@"%.2fkm",[shopListData[indexPath.row][@"Length"] floatValue]]];
    cell.dress.text=@"";
    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,80,12) numberOfStars:5];
    weisheng.scorePercent = 1;
    weisheng.allowIncompleteStar = NO;
    weisheng.hasAnimation = YES;
    [cell.starView addSubview:weisheng];
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
    GoodDetialViewController * goodDetialVC=[[GoodDetialViewController alloc] init];
    goodDetialVC.goodId=shopListData[indexPath.row][@"Id"];
    [self.navigationController pushViewController:goodDetialVC animated:YES];
}

-(void)GetShopData
{
    pageNo=0;
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetShopDataCallBack:" setFailBackFunctionName:nil];
     [dataproviderother SelectRecommendForJifen:areaID andstartRowIndex:ZY_NSStringFromFormat(@"%d",pageNo*pageSize) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize)];
}
-(void)GetFootShopData
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetFootShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectRecommendForJifen:areaID andstartRowIndex:ZY_NSStringFromFormat(@"%d",pageNo*pageSize) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize)];
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
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(TabBar_HEIGHT*(SCREEN_WIDTH/320)))];
        _mainTableView.dataSource=self;
        _mainTableView.delegate=self;
        
        [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 80, 0, 0)];
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

- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    DLog(@"%@",[NSString stringWithFormat:@"点击了第%ld个菜单项",tag]);
    
    JiFenHelpViewController * jifenHelpVC=[[JiFenHelpViewController alloc] init];
    jifenHelpVC.navtitle=str;
    [self.navigationController pushViewController:jifenHelpVC animated:YES];
    
    [MenuView hidden];  // 隐藏菜单
    self.flag = YES;
}

- (void)dealloc{
    [MenuView clearMenu];   // 移除菜单
}

-(void)viewWillAppear:(BOOL)animated
{
    [_app_ showTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
