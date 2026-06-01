//
//  HotGoodListViewController.m
//  BaseProject
//
//  Created by 于金祥 on 16/11/8.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "HotGoodListViewController.h"
#import "DataProviderOther.h"
#import "SellerCell.h"
#import "CWStarRateView.h"
#import "LoginViewController.h"
#import "Index_GoodInfoViewController.h"

@interface HotGoodListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;

@end

@implementation HotGoodListViewController
{
    NSArray *hotGoodArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"热销产品";
    [self.view addSubview:self.mainTableView];
    [self GetHotGood];
    
}

-(void)GetHotGood
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetHotGoodCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetFotGood:get_sp(@"city_Id")  andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
}
-(void)GetHotGoodCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        hotGoodArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        [self.mainTableView reloadData];
    }
}

#pragma mark ----- number of sections and rows -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (hotGoodArray) {
        return hotGoodArray.count;
    }
    return 0;
}

#pragma mark ----- heigth for row -----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark ----- setting for cell -----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SellerCell *cell = [SellerCell cellWithTableView:tableView];
    [cell.logoView sd_setImageWithURL:[NSURL URLWithString:hotGoodArray[indexPath.row][@"ImagePath"]] placeholderImage:[UIImage imageNamed:@"beijing"]];
    cell.nameLabel.text=hotGoodArray[indexPath.row][@"Name"];
    cell.price.text=[NSString stringWithFormat:@"￥%@",hotGoodArray[indexPath.row][@"Price"]];
    cell.distance.text=[NSString stringWithFormat:@"%.2fkm",[hotGoodArray[indexPath.row][@"Length"] floatValue]];
    cell.other.text=hotGoodArray[indexPath.row][@"CategoryName"];
    cell.dress.text=@"";
    cell.score.text=ZY_NSStringFromFormat(@"已售:%@",Zy_JudgeIsNull(hotGoodArray[indexPath.row][@"SeleNum"]));
    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,80,12) numberOfStars:5];
    weisheng.scorePercent = [hotGoodArray[indexPath.row][@"AvgScore"] floatValue]/5;
    weisheng.allowIncompleteStar = NO;
    weisheng.hasAnimation = YES;
    [cell.starView addSubview:weisheng];
    return cell;
}

//Setup your cell margins:
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    Index_GoodInfoViewController * index_goodInfoVC=[[Index_GoodInfoViewController alloc] init];
    index_goodInfoVC.goodID=hotGoodArray[indexPath.row][@"Id"];
    [self.navigationController pushViewController:index_goodInfoVC animated:YES];
}


-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
         [_mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//去掉多余cell的线
//        __unsafe_unretained __typeof(self) weakSelf = self;
//        // 上拉刷新
//        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            
//        }];
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
