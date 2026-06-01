//
//  ShouCangViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShouCangViewController.h"
#import "CollectionTableViewCell.h"
#import "SellerCell.h"
#import "DataProviderOther.h"
#import "CWStarRateView.h"
#import "Index_GoodInfoViewController.h"
#import "Index_ShopInfoViewController.h"
#import "GoodDetialViewController.h"

#define CellHeight 100

@interface ShouCangViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat btnWidth;
    CGFloat btnHeight;
    
    UIButton *groupBuy;
    UIButton *shop;
    UIButton *good;
    
    NSInteger selectedIndex;//1:团购 2:商家 3:购物券商品
    
    NSInteger rowNum;
    
    NSArray * dataArray;
}
@property(nonatomic)UITableView *tableView;

@end

@implementation ShouCangViewController
{
    int pageNo;
    int pageSize;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    pageNo=0;
    pageSize=10;
    self.navtitle = @"收藏";
    [self addLeftButton:@"fanhui"];
    selectedIndex=1;
    [self createViews];
    [self GetAllData];
//    [_tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [_app_ hiddenTabBar];
}


-(void)GetAllData
{
    pageNo=0;
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetAllDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther GetShouCangWithUserid:get_sp(user_ID) andstartRowIndex:[NSString stringWithFormat:@"%d",pageSize*pageNo] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andtype:[NSString stringWithFormat:@"%d",selectedIndex-1]];
}
-(void)GetAllDataCallBack:(id)dict
{
//    ELog(dict);
    [_tableView.mj_header endRefreshing];
    if (RequestSuccess(dict)) {
        dataArray=[[NSArray alloc] initWithArray:dict[@"data"]];
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
        pageNo++;
        
    }
    else
    {
        [YJXStatusHUD showError:@"未获取到有效数据"];
    }
}
-(void)GetAllDatafoot
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetAllDatafootCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther GetShouCangWithUserid:get_sp(user_ID) andstartRowIndex:[NSString stringWithFormat:@"%d",pageSize*pageNo] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andtype:[NSString stringWithFormat:@"%ld",(long)selectedIndex]];
}
-(void)GetAllDatafootCallBack:(id)dict
{
    [_tableView.mj_footer endRefreshing];
    if (RequestSuccess(dict)) {
        NSMutableArray * itemmutableArray=[[NSMutableArray alloc] initWithArray:dataArray];
        for (NSDictionary * itemdict in dict[@"data"]) {
            [itemmutableArray addObject:itemdict];
        }
        
        if (itemmutableArray.count>dataArray.count) {
            dataArray=[[NSArray alloc] initWithArray:itemmutableArray];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            pageNo++;
        }
    }
    else
    {
        [YJXStatusHUD showError:@"没有更多数据了哦"];
    }
}

-(void)createViews{
    btnWidth = SCREEN_WIDTH/3;
    btnHeight = 45;
    
    selectedIndex = 1;
    rowNum = 5;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT-Header_Height)];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _tableView.backgroundColor = BACKGROUND_COLOR;
//    [_tableView registerClass:[CollectionTableViewCell class] forCellReuseIdentifier:@"cell1"];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [_tableView.mj_footer setState:MJRefreshStateIdle];
        pageNo = 0;
        [weakSelf GetAllData];
        
    }];
    
    
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf GetAllDatafoot];
    }];
    [self.view addSubview:_tableView];
}

#pragma mark ----- number of sections and rows -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else{
        if (dataArray) {
            return dataArray.count;
        }
        return 0;
    }
}
#pragma mark ----- height for section and row -----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return btnHeight;
    }
    else{
        return CellHeight;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    else{
        return 5;
    }
}
#pragma mark ----- setting for cell -----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        groupBuy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
        [groupBuy setTitle:[NSString stringWithFormat:@"团购"] forState:UIControlStateNormal];
        [groupBuy setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [groupBuy setTitleColor:ORANGE_COLOR forState:UIControlStateSelected];
        groupBuy.tag = 101;
        if (selectedIndex == 1) {
            groupBuy.selected = YES;
        }else
        {
            groupBuy.selected = NO;
        }
        [groupBuy addTarget:self action:@selector(buttonChanged:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:groupBuy];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, 5, 1, btnHeight-10)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineView];
        
        shop = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth, 0, btnWidth, btnHeight)];
        [shop setTitle:[NSString stringWithFormat:@"商家"] forState:UIControlStateNormal];
        [shop setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [shop setTitleColor:ORANGE_COLOR forState:UIControlStateSelected];
        shop.tag = 102;
        if (selectedIndex == 2) {
            shop.selected = YES;
        }else
        {
            shop.selected = NO;
        }
        [shop addTarget:self action:@selector(buttonChanged:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:shop];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*2, 5, 1, btnHeight-10)];
        lineView2.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineView2];
        
        good = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth*2, 0, btnWidth, btnHeight)];
        [good setTitle:[NSString stringWithFormat:@"商城商品"] forState:UIControlStateNormal];
        [good setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [good setTitleColor:ORANGE_COLOR forState:UIControlStateSelected];
        good.tag = 103;
        if (selectedIndex == 3) {
            good.selected = YES;
        }else
        {
            good.selected = NO;
        }
        [good addTarget:self action:@selector(buttonChanged:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:good];
        
        return cell;
    }
    else{
        if (selectedIndex == 1) {
//            CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
                CollectionTableViewCell *cell = [CollectionTableViewCell cellWithTableView:tableView];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //            }
            cell.goodName.text=dataArray[indexPath.row][@"ProductName"];
            cell.goodDetail.text=dataArray[indexPath.row][@"AddressDetail"];
            cell.goodPrice.text=[NSString stringWithFormat:@"￥%.2f",[dataArray[indexPath.row][@"Price"] floatValue]];
            [cell.goodImage sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,dataArray[indexPath.row][@"ProductImage"])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
            cell.goodDistance.text=ZY_NSStringFromFormat(@"%.2fkm",[dataArray[indexPath.row][@"Length"] floatValue]);
            cell.goodDistance.hidden=YES;
            return cell;
        }
        else if (selectedIndex == 2){
            SellerCell *cell = [SellerCell cellWithTableView:tableView];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                if (dataArray) {
            [cell.logoView sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,dataArray[indexPath.row][@"ProductImage"])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                    cell.nameLabel.text=dataArray[indexPath.row][@"Name"];
//                    cell.price.text=[NSString stringWithFormat:@"￥%.2f",[dataArray[indexPath.row][@"Price"] floatValue]];
                    cell.distance.text=[NSString stringWithFormat:@"%.2fkm",[dataArray[indexPath.row][@"Length"] floatValue]];
            CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,80,12) numberOfStars:5];
            weisheng.scorePercent = [dataArray[indexPath.row][@"AvgScore"] floatValue]/5;
            weisheng.allowIncompleteStar = NO;
            weisheng.hasAnimation = YES;
            [cell.starView addSubview:weisheng];
//                }
//            }
            return cell;
        }
        else{
            SellerCell *cell = [SellerCell cellWithTableView:tableView];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                if (dataArray) {
                    [cell.logoView sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,dataArray[indexPath.row][@"ProductImage"])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                    cell.nameLabel.text=dataArray[indexPath.row][@"Name"];
                    cell.price.text=[NSString stringWithFormat:@"￥%@",dataArray[indexPath.row][@"Price"]];
                    cell.distance.text=[NSString stringWithFormat:@"%.2fkm",[dataArray[indexPath.row][@"Length"] floatValue]];
            CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,80,12) numberOfStars:5];
            weisheng.scorePercent = [dataArray[indexPath.row][@"AvgScore"] floatValue]/5;
            weisheng.allowIncompleteStar = NO;
            weisheng.hasAnimation = YES;
            [cell.starView addSubview:weisheng];
//                }
            
            return cell;
        }
    }
}

-(void)buttonChanged:(UIButton *)button{
    
    if (button.tag == 101) {
        groupBuy.selected = YES;
        shop.selected = NO;
        good.selected = NO;
    }
    else if (button.tag == 102){
        groupBuy.selected = NO;
        shop.selected = YES;
        good.selected = NO;
    }
    else{
        groupBuy.selected = NO;
        shop.selected = NO;
        good.selected = YES;
    }
    selectedIndex = button.tag%100;
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark ----- did selected row at indexPath -----
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section!=0) {
        if (groupBuy.selected) {
            Index_GoodInfoViewController * index_goodInfoVC=[[Index_GoodInfoViewController alloc] init];
            index_goodInfoVC.goodID=dataArray[indexPath.row][@"ProductId"];
            [self.navigationController pushViewController:index_goodInfoVC animated:YES];
        }
        if (shop.selected) {
            Index_ShopInfoViewController * index_goodInfoVC=[[Index_ShopInfoViewController alloc] init];
            index_goodInfoVC.shopID=dataArray[indexPath.row][@"ShopId"];
            [self.navigationController pushViewController:index_goodInfoVC animated:YES];
        }
        if (good.selected) {
            GoodDetialViewController * goodDetialVC=[[GoodDetialViewController alloc] init];
            goodDetialVC.goodId=dataArray[indexPath.row][@"ProductId"];
            [self.navigationController pushViewController:goodDetialVC animated:YES];
        }
    }
    
}
//cell的分割线紧贴两边
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (rowNum>0) {
            rowNum --;
        }
        [self.tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

@end
