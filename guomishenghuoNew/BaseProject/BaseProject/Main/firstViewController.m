//
//  firstViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/6/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "firstViewController.h"
#import "SellerCell.h"
#import "FL_Button.h"
#import "DataProviderOther.h"
#import "ReportMapViewController.h"
#import "AppraiseViewController.h"
#import "Index_ShopInfoViewController.h"
#import "LoginViewController.h"
#import "WJDropdownMenu.h"
#import "CWStarRateView.h"
#import "NewsCenterViewController.h"
#import "NearlyMapViewController.h"
#import "SelectCityViewController.h"
#import "NeighbourMapViewController.h"
#import "CCLocationManager.h"
#import "PhotoLibraryViewController.h"
#import "SearchViewController.h"
#import "IndexShopDetailViewController.h"


@interface firstViewController ()<UITableViewDelegate, UITableViewDataSource,WJMenuDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *classifys;
@property (nonatomic, strong) NSMutableArray *areas;
@property (nonatomic, strong) NSMutableArray *sorts;
@property (nonatomic, strong) NSMutableArray *shaixuan;

@property (nonatomic, strong) NSMutableArray *juliArray;

@property (nonatomic,strong)NSMutableArray *data;

@property (nonatomic,weak)WJDropdownMenu *menu;
@end

@implementation firstViewController
{
    NSArray * fenLeiArray;
    NSArray * xianquArray;
    NSInteger page;
    NSInteger pageSize;
    
    NSArray * FirstMMMMM;//全部分类菜单数据
    NSArray * SecondMMMMM;//县区菜单数据
    NSArray * ThirdMMMMM;//排序数据
    
    NSString * fenleiID;
    NSString * length;
    NSString * areaID;
    NSString * orderID;
    
    NSArray * shopListData;
    
    FL_Button * btn_city;
    
    NSArray * naberArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startGetIndexData) name:@"ChangeCity" object:nil];
    page=0;
    pageSize=10;
    orderID=@"1";
    length=@"-1";
    fenleiID=@"0";
    
    
    [self startGetIndexData];
    
    
    NSDictionary *firstobject =@{@"Id":@"0",@"Name":@"全部",@"Id":@"0"};
    self.classifys =[[NSMutableArray alloc] initWithObjects:firstobject, nil];
    NSDictionary *secondobject =@{@"cityid":@"0",@"cityname":@"附近",@"type":@"0"};
    self.areas = [[NSMutableArray alloc] initWithObjects:secondobject, nil];
    
    self.juliArray=[[NSMutableArray alloc]initWithObjects:@"全部",@"500米",@"1000米",@"2000米",@"3000米", nil];

//    _imgLeft.hidden=YES;
    [self.view addSubview:self.tableView];
//    [self headerView];
    [self BuildTopView];
    
    [self GetNaiberAround];
    
}
-(void)GetNaiberAround
{
//    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
        [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetNaiberAroundCallBack:" setFailBackFunctionName:nil];
        [dataproviderother SelectShopListForFujinWithlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
//    }];
    
}
-(void)GetNaiberAroundCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        naberArray=[[NSArray alloc] initWithArray:dict[@"data"]];
    }
}
-(void)clickRightButton:(UIButton *)sender
{
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    if (naberArray) {
        NeighbourMapViewController * mapVC=[[NeighbourMapViewController alloc] initWithNibName:@"NeighbourMapViewController" bundle:[NSBundle mainBundle]];
        mapVC.shopArray = naberArray;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
    else
    {
        [self GetNaiberAround];
        [YJXStatusHUD showError:@"正在获取附近商铺请稍后。。。"];
    }
    
}
-(void)startGetIndexData
{
    [btn_city setTitle:get_sp(@"city_Name") forState:UIControlStateNormal];
    areaID=get_sp(@"city_Id");
    [self GetAllFenLei];
    [self GetCityNext];
    [self GetShopData];
}


- (void)createAllMenuData{
    //  创建第三个菜单的first数据second数据
    NSArray *firstArrThree = [NSArray arrayWithObjects:@"智能排序",@"离我最近",@"好评优先", nil];
    ThirdMMMMM = [NSArray arrayWithObjects:firstArrThree, nil];
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
    [self.menu drawBackMenu];
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
    [self.tableView reloadData];
    
};











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
            
            // 创建menu
            WJDropdownMenu *menu1 = [[WJDropdownMenu alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
            menu1.delegate = self;         //   设置代理
            [self.view addSubview:menu1];
            self.menu = menu1;
            
            // 设置属性(可不设置)
            menu1.caverAnimationTime = 0.2;             //  增加了展开动画时间设置   不设置默认是  0.15
            menu1.hideAnimationTime = 0.2;              //  增加了缩进动画时间设置   不设置默认是  0.15
            menu1.menuTitleFont = 12;                   //  设置menuTitle字体大小    不设置默认是  11
            menu1.tableTitleFont = 11;                  //  设置tableTitle字体大小   不设置默认是  10
            menu1.cellHeight = 38;                      //  设置tableViewcell高度   不设置默认是  40
            menu1.menuArrowStyle = menuArrowStyleSolid; //  旋转箭头的样式(空心箭头 or 实心箭头)
            menu1.tableViewMaxHeight = 200;             //  tableView的最大高度(超过此高度就可以滑动显示)
            menu1.menuButtonTag = 100;                  //  menu定义了一个tag值如果与本页面的其他button的值有冲突重合可以自定义设置
            menu1.CarverViewColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];//设置遮罩层颜色
            menu1.selectedColor = [UIColor redColor];   //  选中的字体颜色
            menu1.unSelectedColor = [UIColor grayColor];//  未选中的字体颜色
            
            
            
            
            
            //  创建第一个菜单的first数据second数据
            
            NSMutableArray * firstArrayM=[[NSMutableArray alloc] init];
            NSMutableArray * firstArrayyiji=[[NSMutableArray alloc] init];
            
            
            
            for (NSDictionary * itemdict in fenLeiArray) {
                NSMutableArray * itemArray1=[[NSMutableArray alloc] init];
                for (NSDictionary * itemitemdict in itemdict[@"Children"]) {
                    [itemArray1 addObject:itemitemdict[@"Name"]];
                }
                //            if (itemArray1.count==0) {
                //                [itemArray1 addObject:@"全部"];
                //            }
                [firstArrayM addObject:itemArray1];
                [firstArrayyiji addObject:itemdict[@"Name"]];
            }
            FirstMMMMM=[[NSArray alloc] initWithObjects:firstArrayyiji,firstArrayM, nil];
            
            
            
            //        //  创建第二个菜单的first数据second数据
            //        NSArray *firstArrTwo = [NSArray arrayWithObjects:@"B一级菜单1",@"B一级菜单2", nil];
            //        NSArray *secondArrTwo = @[@[@"B二级菜单11",@"B二级菜单12"],@[@"B二级菜单21",@"B二级菜单22"]];
            //        //    NSArray *thirdArrTwo = @[@[@"B三级菜单11-1",@"B三级菜单11-2",@"B三级菜单11-3"],@[@"B三级菜单12-1",@"B三级菜单12-2"],@[@"B三级菜单21-1",@"B三级菜单21-2"],@[@"B三级菜单22-1",@"B三级菜单22-2"]];
            //        NSArray *thirdArrTwo = @[@[@"B三级菜单11-1",@"B三级菜单11-2",@"B三级菜单11-3"],@[@"B三级菜单12-1",@"B三级菜单12-2"],@[@"B三级菜单21-1",@"B三级菜单21-2"],@[]];
            //        NSArray *secondMenu = [NSArray arrayWithObjects:firstArrTwo,secondArrTwo,thirdArrTwo, nil];
            
            //  创建第三个菜单的first数据second数据
            NSArray *firstArrThree = [NSArray arrayWithObjects:@"智能排序",@"离我最近",@"好评优先", nil];
            ThirdMMMMM = [NSArray arrayWithObjects:firstArrThree, nil];
            
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
        [self.menu createThreeMenuTitleArray:threeMenuTitleArray FirstArr:firstcolom SecondArr:secondcolom threeArr:thirdcolom];
        
        // 设置rightItem点击收缩menu
        [self createRightNav];
    }
    
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
-(void)GetShopData
{
    page=0;
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectShopIndexNewRowIndex:ZY_NSStringFromFormat(@"%ld",(pageSize*page)) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:@"" andcategoryid:fenleiID andlength:length andorder:orderID andareaid:areaID andisallcity:@"1" andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
//    [dataproviderother GetShopListstartRowIndex:ZY_NSStringFromFormat(@"%ld",page*pageSize) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:@"" andcategoryid:fenleiID andlength:length andorder:orderID andareaid:areaID];
}
-(void)GetFootShopData
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetFootShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectShopIndexNewRowIndex:ZY_NSStringFromFormat(@"%ld",(pageSize*page)) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:@"" andcategoryid:fenleiID andlength:length andorder:orderID andareaid:areaID andisallcity:@"1" andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
//    [dataproviderother GetShopListstartRowIndex:ZY_NSStringFromFormat(@"%ld",page*pageSize) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:@"" andcategoryid:fenleiID andlength:length andorder:orderID andareaid:areaID];
}
-(void)GetShopDataCallBack:(id)dict
{
    [self.tableView.mj_header endRefreshing];
    if (RequestSuccess(dict)) {
        shopListData=[[NSArray alloc] initWithArray:dict[@"data"]];
        [self.tableView reloadData];
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
        [self.tableView reloadData];
        page++;
        
    }
    
    [_tableView.mj_footer endRefreshing];
    
}
-(void)BuildTopView
{
    UIButton * btn_search=[[UIButton alloc] init];
    btn_search.bounds=CGRectMake(0, 0, SCREEN_WIDTH-160, 30);
    btn_search.center=CGPointMake(SCREEN_WIDTH/2, 42);
    [btn_search addTarget:self action:@selector(jumpToSearch) forControlEvents:UIControlEventTouchUpInside];
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
//    _lblTitle.text=@"商家";
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
    
//    UIButton * btn_MessageVC=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, btn_city.frame.origin.y, 25, 30)];
//    [btn_MessageVC setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
//    [btn_MessageVC addTarget:self action:@selector(JumpToMessage) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn_MessageVC];
//    
//    
//    UIButton * btn_scanVC=[[UIButton alloc] initWithFrame:CGRectMake(btn_MessageVC.frame.origin.x-25, btn_city.frame.origin.y, 25, 30)];
//    [btn_scanVC setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
//    [self.view addSubview:btn_scanVC];
    
    [self addRightButton:@"ditu"];
}
-(void)jumpToSearch
{
    SearchViewController * searchVC=[[SearchViewController alloc] init];
    searchVC.type=2;
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)JumpToLocation
{
    //    LocationViewController * locationVC=[[LocationViewController alloc] init];
    //    [self.navigationController pushViewController:locationVC animated:YES];
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    [self.navigationController pushViewController:selectCityVC animated:YES];
}
#pragma mark createUI
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 65+40, SCREEN_WIDTH, SCREEN_HEIGHT-65-40) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        __unsafe_unretained __typeof(self) weakSelf = self;
        
        _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
             [weakSelf GetShopData];
            
        }];
        
        // 上拉刷新
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf GetFootShopData];
        }];

    }
    return _tableView;
}

- (void)headerView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 70)];
    view.backgroundColor = RGB(236, 234, 241);
    
    UILabel *dreLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40+5, SCREEN_WIDTH-50, 20)];
    dreLabel.text = get_sp(@"addressString");
//    [dreLabel sizeToFit];
    dreLabel.font=[UIFont systemFontOfSize:14];
    dreLabel.textColor = RGB(158, 158, 156);
    dreLabel.tag = 102;
    [view addSubview:dreLabel];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width-20-10, 40+5, 24, 20)];
    [view addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:view];
}
- (void)refreshClick{
    NSLog(@"刷新");
    [YJXStatusHUD showSuccess:@"正在刷新"];
    [self GetShopData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (shopListData) {
        return shopListData.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

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
#pragma mark UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    AppraiseViewController *tvc = [[AppraiseViewController alloc]init];
//    [self.navigationController pushViewController:tvc animated:YES];
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
//    Index_ShopInfoViewController * index_shopInfoVC=[[Index_ShopInfoViewController alloc] init];
//    index_shopInfoVC.shopID=shopListData[indexPath.row][@"Id"];
//    [self.navigationController pushViewController:index_shopInfoVC animated:YES];
    IndexShopDetailViewController * index_shopInfoVC=[[IndexShopDetailViewController alloc] init];
    index_shopInfoVC.shopId=shopListData[indexPath.row][@"Id"];
    [self.navigationController pushViewController:index_shopInfoVC animated:YES];
    
//    PhotoLibraryViewController * photoListVC=[[PhotoLibraryViewController alloc] init];
//    photoListVC.shopID=shopListData[indexPath.row][@"Id"];
//    [self.navigationController pushViewController:photoListVC animated:YES];
  
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_app_ hiddenTabBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
