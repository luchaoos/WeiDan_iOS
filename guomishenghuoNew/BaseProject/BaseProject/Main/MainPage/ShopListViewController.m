//
//  ShopListViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShopListViewController.h"
#import "SellerCell.h"
#import "CWStarRateView.h"
#import "Index_ShopInfoViewController.h"
#import "DataProviderOther.h"
#import "LoginViewController.h"

@interface ShopListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * mainTableView;

@end

@implementation ShopListViewController
{
    NSInteger page;
    NSInteger pageSize;
    NSString * fenleiID;
    NSString * length;
    NSString * areaID;
    NSString * orderID;
    NSArray * shopListData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageSize=10;
    areaID=get_sp(@"city_Id");
    orderID=@"1";
    length=@"-1";
    fenleiID=self.type;
    [self.view addSubview:self.mainTableView];
    [self BuildTopView];
    [self GetShopData];
}
-(void)BuildTopView
{
    _lblTitle.text=@"商家列表";
//    UIButton * btn_search=[[UIButton alloc] init];
//    btn_search.bounds=CGRectMake(0, 0, SCREEN_WIDTH-120, 30);
//    btn_search.center=CGPointMake(SCREEN_WIDTH/2, 42);
//    btn_search.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
//    [btn_search setTitle:@"     请输入商家名、品类或商圈" forState:UIControlStateNormal];
//    btn_search.titleLabel.font=[UIFont systemFontOfSize:14];
//    UIImageView * img_search=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
//    img_search.image=[UIImage imageNamed:@"sousuo"];
//    [btn_search addSubview:img_search];
//    [self.view addSubview:btn_search];
//    
//    
//    UIButton * btn_MessageVC=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, btn_search.frame.origin.y, 25, 30)];
//    [btn_MessageVC setImage:[UIImage imageNamed:@"ditu"] forState:UIControlStateNormal];
//    [self.view addSubview:btn_MessageVC];
    
    //
    //    UIButton * btn_scanVC=[[UIButton alloc] initWithFrame:CGRectMake(btn_MessageVC.frame.origin.x-25, btn_search.frame.origin.y, 25, 30)];
    //    [btn_scanVC setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
    //    [self.view addSubview:btn_scanVC];
    
    
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
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section==1) {
//        UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//        sectionHeaderView.backgroundColor=AppMainColor;
//
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-2-50, 7, 50, 30)];
//        [sectionHeaderView addSubview:btn];
//        [btn setTitle:@"更多" forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
//
//        return sectionHeaderView;
//    }
//    else
//    {
//        return nil;
//    }
//}
- (void)moreClick{
    NSLog(@"更多选项");
}
-(void)GetShopData
{
    page=0;
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectShopIndexNewRowIndex:ZY_NSStringFromFormat(@"%ld",(pageSize*page)) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:@"" andcategoryid:fenleiID andlength:length andorder:orderID andareaid:areaID andisallcity:@"1" andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
}
-(void)GetFootShopData
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetFootShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectShopIndexNewRowIndex:ZY_NSStringFromFormat(@"%ld",(pageSize*page)) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:@"" andcategoryid:fenleiID andlength:length andorder:orderID andareaid:areaID andisallcity:@"1" andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
}
-(void)GetShopDataCallBack:(id)dict
{
    [self.mainTableView.mj_header endRefreshing];
    if (RequestSuccess(dict)) {
        shopListData=[[NSArray alloc] initWithArray:dict[@"data"]];
        [self.mainTableView reloadData];
        page++;
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
        page++;
        
    }
    
    [_mainTableView.mj_footer endRefreshing];
    
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
    weisheng.scorePercent = [shopListData[indexPath.section][@"AvgScore"] floatValue]/5;
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
    Index_ShopInfoViewController * index_shopInfoVC=[[Index_ShopInfoViewController alloc] init];
    index_shopInfoVC.shopID=shopListData[indexPath.section][@"Id"];
    [self.navigationController pushViewController:index_shopInfoVC animated:YES];
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


@end
