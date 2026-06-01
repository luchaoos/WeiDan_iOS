//
//  ShangChengGoodListViewController.m
//  BaseProject
//
//  Created by 于金祥 on 17/3/21.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "ShangChengGoodListViewController.h"
#import "GoodDetialViewController.h"
#import "LoginViewController.h"
#import "DataProviderOther.h"
#import "ShangChengGoodTwoCell.h"
#import "LCNetworkManager.h"
#import "DZNSegmentedControl.h"

@interface ShangChengGoodListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * mainTableView;
@property (nonatomic, strong) DZNSegmentedControl *segment;

@property (nonatomic, assign) NSInteger orderType;
@end

@implementation ShangChengGoodListViewController
{
    NSInteger page;
    NSInteger pageSize;
    NSString * fenleiID;
    NSString * length;
    NSString * areaID;
    NSString * orderID;
    NSArray * shopListData;
}

- (DZNSegmentedControl *)segment {
    if (!_segment) {
        _segment = [[DZNSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 35)];
        _segment.items = @[@"价格", @"销量", @"综合"];
        _segment.showsCount = NO;
        _segment.tintColor = [UIColor orangeColor];
        [_segment addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (void)selectedSegment:(DZNSegmentedControl *)sender {
    self.orderType  = sender.selectedSegmentIndex;
    NSLog(@"%@", @(self.orderType));
    [self.mainTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageSize=10;
    areaID=get_sp(@"city_Id");
    orderID=@"1";
    length=@"-1";
    fenleiID=self.type;
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.segment];
    [self BuildTopView];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 上拉刷新
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getList];
    }];
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf->shopListData = @[];
        [weakSelf getList];
    }];
    
    shopListData = @[];
//    [self GetShopData];
    [self.mainTableView.mj_header beginRefreshing];
}
-(void)BuildTopView
{
    _lblTitle.text=@"产品列表";
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
    if (shopListData && self.flag.integerValue == 2) {
        return shopListData.count / 2 + shopListData.count % 2;
    }
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
    return SCREEN_WIDTH*0.5+40;
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
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther GetJiFenShopAllProductWithareaid:get_sp(@"city_Id") andparentid:self.type];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_flag integerValue] == 2) {
        ShangChengGoodTwoCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ShangChengGoodTwoCell" owner:nil options:nil][0];
        NSInteger idx = indexPath.section * 2;
        NSDictionary *dict1 = shopListData[idx];
        NSDictionary *dict2;
        if (idx + 1 <= shopListData.count - 1) {
            dict2 = shopListData[idx + 1];
            
            [cell.image2 sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,dict2[@"ImagePath"])] placeholderImage:img(@"placeHolderlong")];
            cell.labelR1.text = [NSString stringWithFormat:@"%@", dict2[@"Name"]];
            cell.labelR2.text = [NSString stringWithFormat:@"%@米币", dict2[@"Price"]];
            cell.labelL3.text = [NSString stringWithFormat:@"库存:%@\n销量:%@", dict1[@"StockNum"], dict1[@"SaleNum"]];
            cell.labelR3.text = [NSString stringWithFormat:@"库存:%@\n销量:%@", dict2[@"StockNum"], dict2[@"SaleNum"]];
            cell.btnR.tag = [dict2[@"Id"] integerValue];
            [cell.btnR addTarget:self action:@selector(btnRClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            cell.image2.hidden = YES;
            cell.labelR1.hidden = YES;
            cell.labelR2.hidden = YES;
            cell.btnR.hidden = YES;
        }
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,dict1[@"ImagePath"])] placeholderImage:img(@"placeHolderlong")];
        cell.labelL1.text = [NSString stringWithFormat:@"%@", dict1[@"Name"]];
        cell.labelL2.text = [NSString stringWithFormat:@"%@米币", dict1[@"Price"]];
        
        cell.btnL.tag = [dict1[@"Id"] integerValue];
        [cell.btnL addTarget:self action:@selector(btnLClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.5)];
    UIImageView * img_image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.5)];
    [img_image sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,shopListData[indexPath.section][@"ImagePath"])] placeholderImage:img(@"placeHolderlong")];
    [cell addSubview:img_image];
    UIView * V_bottom=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img_image.frame), SCREEN_WIDTH, 40)];
    V_bottom.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-120, 40)];
    lbl_title.numberOfLines=2;
    lbl_title.text=ZY_NSStringFromFormat(@"%@\n%@  米币",shopListData[indexPath.section][@"Name"],shopListData[indexPath.section][@"Price"]);
    lbl_title.font=[UIFont systemFontOfSize:14];
    [V_bottom addSubview:lbl_title];
//    UIButton * btn_share=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl_title.frame), 5, 30, 30)];
//    [btn_share setImage:[UIImage imageNamed:@"fenxiang-1"] forState:UIControlStateNormal];
//    [btn_share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
//    [V_bottom addSubview:btn_share];
    [cell addSubview:V_bottom];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl_title.frame) + 20, 5, 120, 40)];
    label2.textAlignment = NSTextAlignmentLeft;
//    label2.textColor = [UIColor grayColor];
    label2.text = [NSString stringWithFormat:@"库存:%@\n已售:%@", shopListData[indexPath.section][@"StockNum"], shopListData[indexPath.section][@"SaleNum"]];
    label2.font = [UIFont systemFontOfSize:13];
    label2.numberOfLines = 0;
    [label2 sizeToFit];
    [V_bottom addSubview:label2];
    
    return cell;
}

- (void)btnLClick:(UIButton *)sender {
    GoodDetialViewController * goodDetialVC=[[GoodDetialViewController alloc] init];
    goodDetialVC.goodId=[NSString stringWithFormat:@"%ld", sender.tag];
    [self.navigationController pushViewController:goodDetialVC animated:YES];
}

- (void)btnRClick:(UIButton *)sender {
    GoodDetialViewController * goodDetialVC=[[GoodDetialViewController alloc] init];
    goodDetialVC.goodId=[NSString stringWithFormat:@"%ld", sender.tag];
    [self.navigationController pushViewController:goodDetialVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    if ([_flag integerValue] == 2) {
        return;
    }
    GoodDetialViewController * goodDetialVC=[[GoodDetialViewController alloc] init];
    goodDetialVC.goodId=shopListData[indexPath.section][@"Id"];
    [self.navigationController pushViewController:goodDetialVC animated:YES];
}
-(void)share
{
    [Toolkit ShareForProject];
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
        _mainTableView.dataSource=self;
        _mainTableView.delegate=self;
        
        [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 100, 0, 0)];
        _mainTableView.showsVerticalScrollIndicator=NO;
        [_mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//去掉多余cell的线
        
        
    }
    return _mainTableView;
}

- (void)getList {
    [[LCNetworkManager sharedManager]
     requestWithURL:@"IndexService.asmx/Entry"
     function:@"SelectProductByCategoryId"
     params:@{@"startRowIndex" : @(shopListData.count),
              @"maximumRows" : @10,
              @"search" : @"",
              @"categoryid" : fenleiID,
              @"ordertype" : @(self.orderType)}
     success:^(id responseData) {
         NSMutableArray * itemMutableArray=[[NSMutableArray alloc] initWithArray:shopListData];
//         for (NSDictionary * itemDict in responseData) {
//             [itemMutableArray addObject:itemDict];
//         }
         [itemMutableArray addObjectsFromArray:responseData];
         shopListData=[[NSArray alloc] initWithArray:itemMutableArray];
         [self.mainTableView reloadData];
         [self.mainTableView.mj_header endRefreshing];
         [self.mainTableView.mj_footer endRefreshing];
         
     } failure:^(NSError *error) {
         NSLog(@"%@", error.localizedDescription);
         [SVProgressHUD showErrorWithStatus:error.domain];
     }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_app_ hiddenTabBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
