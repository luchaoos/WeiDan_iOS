//
//  HealthMoneyViewController.m
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "HealthMoneyViewController.h"
#import "HealthMoneyTableViewCell.h"
#import "DataProviderOther.h"

@interface HealthMoneyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)UITableView *tableView;

@end

@implementation HealthMoneyViewController
{
    
    NSInteger pageNo;
    NSInteger pageSize;
    
    NSArray * dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageSize=10;
    self.navtitle = @"健康储蓄金";
    [self addLeftButton:@"fanhui"];
    
    [self createViews];
}

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate hiddenTabBar];
}

-(void)createViews{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT-Header_Height)];
//    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [_tableView.mj_footer setState:MJRefreshStateIdle];
        pageNo = 0;
        [weakSelf GetDetialList];
        
    }];
    [_tableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf GetDetialList1];
    }];
    
    [self.view addSubview:self.tableView];
}
#pragma mark ----- number of sections and rows -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray) {
        return dataArray.count;
    }
    return 0;
}

#pragma mark ----- heigth for row -----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark ----- setting for cell -----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    HealthMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HealthMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.usedWay.text=ZY_NSStringFromFormat(@"%@",dataArray[indexPath.row][@"Description"]);
        cell.usedMoney.text=ZY_NSStringFromFormat(@"%@",dataArray[indexPath.row][@"Amount"]);
        cell.time.text=[[NSString stringWithFormat:@"%@",dataArray[indexPath.row][@"OperateTime"] ] substringToIndex:10];
        cell.integration.text=ZY_NSStringFromFormat(@"购物券+%@",dataArray[indexPath.row][@"Amount"]);
    }
    return cell;
}
-(void)GetDetialList
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetDetitlListCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andtype:@"10"];
}

-(void)GetDetitlListCallBack:(id)dict
{
    ELog(dict);
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (RequestSuccess(dict)) {
        dataArray=[[NSArray alloc] initWithArray:dict[@"data"][@"List"]];
        [self.tableView reloadData];
        pageNo ++;
        //
    }
    //    else
    //    {
    //        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    //    }
}

-(void)GetDetialList1
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetDetitlListCallBack1:" setFailBackFunctionName:nil];
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andtype:@"10"];
}

-(void)GetDetitlListCallBack1:(id)dict
{
    ELog(dict);
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (RequestSuccess(dict)) {
        @try {
            NSMutableArray * itemarray=[[NSMutableArray alloc] initWithArray:dataArray];
            for (NSDictionary * itemDict in dict[@"data"][@"List"]) {
                [itemarray addObject:itemDict];
            }
            dataArray=[[NSArray alloc] initWithArray:itemarray];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        //
        [self.tableView reloadData];
        pageNo ++;
        
    }
    //    else
    //    {
    //        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    //    }
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
@end
