//
//  TiXianJiLuViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/5/12.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "TiXianJiLuViewController.h"
#import "DataProviderOther.h"
#import "ProjectTools.h"

@interface TiXianJiLuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * mainTableView;

@end

@implementation TiXianJiLuViewController
{
    NSInteger pageNo;
    NSInteger pageSize;
    
    NSArray * dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"提现记录";
    pageSize=10;
    [self addLeftButton:@"fanhui"];
//    self.view.backgroundColor=RGB(235, 235, 235);
    [self.view addSubview:self.mainTableView];
}


-(void)GetDetialList
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetDetitlListCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andtype:@"9"];
}

-(void)GetDetitlListCallBack:(id)dict
{
    ELog(dict);
    
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    
    if (RequestSuccess(dict)) {
        dataArray=[[NSArray alloc] initWithArray:dict[@"data"][@"List"]];
        [self.mainTableView reloadData];
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
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:[NSString stringWithFormat:@"%ld",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%ld",(long)pageSize] andtype:@"9"];
}

-(void)GetDetitlListCallBack1:(id)dict
{
    ELog(dict);
    
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    
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
        [self.mainTableView reloadData];
        pageNo ++;
        
    }
    //    else
    //    {
    //        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    //    }
}












-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray!=nil?dataArray.count:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UILabel * lbl_left=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, (SCREEN_WIDTH-30)/2, 60)];
    lbl_left.text=[NSString stringWithFormat:@"%@\n",dataArray[indexPath.row][@"Description"]];
    lbl_left.numberOfLines=2;
    [cell.contentView addSubview:lbl_left];
    
    UILabel * lbl_right=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl_left.frame), 0, (SCREEN_WIDTH-30)/2, 60)];
    
    lbl_right.font=[UIFont systemFontOfSize:16];
    lbl_right.text=[NSString stringWithFormat:@"%@\n金额￥%@",[[NSString stringWithFormat:@"%@",dataArray[indexPath.row][@"OperateTime"] ] substringToIndex:10],[NSString stringWithFormat:@"%.2f",[dataArray[indexPath.row][@"Amount"] floatValue]]];
    lbl_right.textAlignment=NSTextAlignmentRight;
    lbl_right.numberOfLines=2;
    [cell.contentView addSubview:lbl_right];
    
    
    
    return cell;
}





-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
        _mainTableView.dataSource=self;
        _mainTableView.delegate=self;
        
        
        _mainTableView.showsVerticalScrollIndicator=NO;
        __unsafe_unretained __typeof(self) weakSelf = self;
        _mainTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [_mainTableView.mj_footer setState:MJRefreshStateIdle];
            pageNo = 0;
            [weakSelf GetDetialList];
            
        }];
        [_mainTableView.mj_header beginRefreshing];
        
        // 上拉刷新
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf GetDetialList1];
        }];
        
    }
    return _mainTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
