//
//  MingDianListViewController.m
//  BaseProject
//
//  Created by 于金祥 on 16/11/2.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MingDianListViewController.h"
#import "DataProviderOther.h"
#import "MingDianTableViewCell.h"
#import "CWStarRateView.h"
#import "Index_ShopInfoViewController.h"

@interface MingDianListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * mainTableView;
@end

@implementation MingDianListViewController
{
    int pageNo;
    int pageSize;
    NSArray * goodlist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"名店抢购";
    pageSize=10;
    pageNo=0;
    [self.view addSubview:self.mainTableView];
    goodlist=[[NSArray alloc] init];
    [self getGoodList];
}




#pragma mark - self datasource
-(void)getGoodList
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"getGoodlistCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther GetMingDianList:get_sp(@"city_Id") andstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
}

-(void)getGoodlistCallBack:(id)dict
{
    ELog(dict);
//    [_mainTableView.mj_header endRefreshing];
    [_mainTableView.mj_footer endRefreshing];
    if (RequestSuccess(dict)) {
        NSArray * dataarray=[[NSArray alloc] initWithArray:dict[@"data"]];
        if (dataarray.count>0) {
            pageNo++;
        }
        NSMutableArray * itemMutableArray=[[NSMutableArray alloc] initWithArray:goodlist];
        for (NSDictionary * itemdict in dict[@"data"]) {
            [itemMutableArray addObject:itemdict];
        }
        goodlist=[[NSArray alloc] initWithArray:itemMutableArray];
        
        [self.mainTableView reloadData];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    }
    
}




-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (goodlist) {
        return goodlist.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MingDianTableViewCell *cell = [MingDianTableViewCell cellWithTableView:tableView];
    
    [cell.logoView sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,goodlist[indexPath.row][@"PhotoPath"])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    cell.nameLabel.text=goodlist[indexPath.row][@"Name"];
    cell.score.text=[NSString stringWithFormat:@"人均%@", Zy_JudgeIsNull(goodlist[indexPath.row][@"RenJun"])];
    cell.price.text=ZY_NSStringFromFormat(@"已售%@",Zy_JudgeIsNull(goodlist[indexPath.row][@"SeleNum"]));
    cell.distance.text=[NSString stringWithFormat:@"%.2fkm",[goodlist[indexPath.row][@"Length"] floatValue]];
    cell.other.text=goodlist[indexPath.row][@"CategoryName"];
    cell.dress.text=[NSString stringWithFormat:@"消费100送%@", Zy_JudgeIsNull(goodlist[indexPath.row][@"JifenRate"])];
    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,80,12) numberOfStars:5];
    weisheng.scorePercent = [goodlist[indexPath.row][@"AvgScore"] floatValue]/5;
    weisheng.allowIncompleteStar = NO;
    weisheng.hasAnimation = YES;
    [cell.starView addSubview:weisheng];
    cell.price.textColor=[UIColor redColor];
    cell.dress.textColor=[UIColor redColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Index_ShopInfoViewController * index_goodInfoVC=[[Index_ShopInfoViewController alloc] init];
    index_goodInfoVC.shopID=goodlist[indexPath.row][@"Id"];
    [self.navigationController pushViewController:index_goodInfoVC animated:YES];

}










-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
        
         [_mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//去掉多余cell的线
        __unsafe_unretained __typeof(self) weakSelf = self;
        
//        _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            
//            [_mainTableView.mj_footer setState:MJRefreshStateIdle];
//            pageNo = 0;
//            [weakSelf getGoodList];
//            
//        }];
//        [_mainTableView.mj_header beginRefreshing];
        
        // 上拉刷新
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf getGoodList];
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
    [_app_ hiddenTabBar];
}


@end
