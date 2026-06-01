//
//  NewsCenterViewController.m
//  BaseProject
//
//  Created by 于金祥 on 16/11/12.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "NewsCenterViewController.h"
#import "DataProviderOther.h"

@interface NewsCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * mainTableView;

@end

@implementation NewsCenterViewController
{
    NSInteger page;
    NSInteger pageSize;
    NSArray * shopListData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"消息中心";
    page=0;
    pageSize=10;
    
    [self.view addSubview:self.mainTableView];
    
    [self GetShopData];
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
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UILabel * lbl_left=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, (SCREEN_WIDTH), 90)];
    lbl_left.text=[NSString stringWithFormat:@"%@    %@\n%@",shopListData[indexPath.row][@"Name"],shopListData[indexPath.row][@"PublishTime"],shopListData[indexPath.row][@"Content"]];
    lbl_left.numberOfLines=3;
    [cell.contentView addSubview:lbl_left];
    
//    UILabel * lbl_right=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl_left.frame), 0, (SCREEN_WIDTH-30)/2, 60)];
//    
//    lbl_right.font=[UIFont systemFontOfSize:16];
//    lbl_right.text=[NSString stringWithFormat:@"\n时间"];
//    lbl_right.textAlignment=NSTextAlignmentRight;
//    lbl_right.numberOfLines=2;
//    [cell.contentView addSubview:lbl_right];
    
    return cell;
}
-(void)GetShopData
{
    page=0;
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectMessage:get_sp(@"city_Id") andstartRowIndex:ZY_NSStringFromFormat(@"%ld",page*pageSize) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize)];
}
-(void)GetFootShopData
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetFootShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectMessage:get_sp(@"city_Id") andstartRowIndex:ZY_NSStringFromFormat(@"%ld",page*pageSize) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize)];
}
-(void)GetShopDataCallBack:(id)dict
{
    [self.mainTableView.mj_header endRefreshing];
    if (RequestSuccess(dict)) {
        shopListData=[[NSArray alloc] initWithArray:dict[@"data"]];
        [self.mainTableView reloadData];
        page++;
    }
    else
    {
        [YJXStatusHUD showError:@"未获取到数据"];
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
-(UITableView * )mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
        
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
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_app_ hiddenTabBar];
}

@end
