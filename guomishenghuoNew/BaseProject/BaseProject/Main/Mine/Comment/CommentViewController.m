//
//  CommentViewController.m
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "DataProviderOther.h"

#define CellHeight 320

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat btnWidth;
    CGFloat btnHeight;
    
    UIButton *groupBuyTicket;
    UIButton *guomiMall;
    
    NSArray * dataarray;
}
@property(nonatomic)UITableView *tableView;

@end

@implementation CommentViewController
{
    int pageNo;
    int pageSize;
    NSString * istuangou;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageNo=0;
    pageSize=10;
    istuangou=@"1";
    self.navtitle = @"评价";
    
    [self addLeftButton:@"fanhui"];
    [self createViews];
    
    [_tableView.mj_header beginRefreshing];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate hiddenTabBar];
}

-(void)GetAllData
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetAllDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther GetCommentWithUserid:get_sp(user_ID) andstartRowIndex:[NSString stringWithFormat:@"%d",pageSize*pageNo] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andtype:istuangou];
}
-(void)GetAllDataCallBack:(id)dict
{
    [_tableView.mj_header endRefreshing];
    if (RequestSuccess(dict)) {
        dataarray=[[NSArray alloc] initWithArray:dict[@"data"]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(void)GetAllDatafoot
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetAllDatafootCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther GetCommentWithUserid:get_sp(user_ID) andstartRowIndex:[NSString stringWithFormat:@"%d",pageSize*pageNo] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andtype:istuangou];
}
-(void)GetAllDatafootCallBack:(id)dict
{
    [_tableView.mj_footer endRefreshing];
    if (RequestSuccess(dict)) {
        NSMutableArray * itemmutableArray=[[NSMutableArray alloc] initWithArray:dataarray];
        for (NSDictionary * itemdict in dict[@"data"]) {
            [itemmutableArray addObject:itemdict];
        }
        
        
        if (itemmutableArray.count>dataarray.count) {
            dataarray=[[NSArray alloc] initWithArray:itemmutableArray];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
}
-(void)createViews{
    btnWidth = SCREEN_WIDTH/2;
    btnHeight = 45;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT-Header_Height)];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    
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
        if (dataarray) {
            return dataarray.count;
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
        
        groupBuyTicket = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
        [groupBuyTicket setTitle:[NSString stringWithFormat:@"团购"] forState:UIControlStateNormal];
        [groupBuyTicket setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [groupBuyTicket setTitleColor:ORANGE_COLOR forState:UIControlStateSelected];
        groupBuyTicket.tag = 101;
        [groupBuyTicket addTarget:self action:@selector(buttonChanged:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:groupBuyTicket];
        groupBuyTicket.selected = YES;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, 5, 1, btnHeight-10)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineView];
        
        guomiMall = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth, 0, btnWidth, btnHeight)];
        [guomiMall setTitle:[NSString stringWithFormat:@"商家"] forState:UIControlStateNormal];
        [guomiMall setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [guomiMall setTitleColor:ORANGE_COLOR forState:UIControlStateSelected];
        guomiMall.tag = 102;
        [guomiMall addTarget:self action:@selector(buttonChanged:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:guomiMall];
        
        return cell;
    }
    else{
        NSString *identifier = @"cell";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (dataarray) {
                cell.nameLbl.text=[Toolkit judgeIsNull:dataarray[indexPath.row][@"UserName"]];
                NSString * time=[Toolkit judgeIsNull:dataarray[indexPath.row][@"PayTime"]];
                cell.timeLbl.text=time.length>10?[time substringToIndex:10]:time;
                cell.commentLbl.text=[Toolkit judgeIsNull:dataarray[indexPath.row][@"Content"]];
                [cell.headImage sd_setImageWithURL:dataarray[indexPath.row][@"PhotoPath"] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                [cell.goodImage sd_setImageWithURL:[NSURL URLWithString:dataarray[indexPath.row][@"ImagePath"] ]placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                cell.guigeLbl.text=[Toolkit judgeIsNull:dataarray[indexPath.row][@"ProductName"]];
            }
        }
        return cell;
    }
}

-(void)buttonChanged:(UIButton *)button{
    //    button.selected = !button.selected;
    if (button.tag == 101) {
        groupBuyTicket.selected = YES;
        guomiMall.selected = NO;
        istuangou=@"1";
    }
    else{
        groupBuyTicket.selected = NO;
        guomiMall.selected = YES;
        istuangou=@"0";
    }
    [_tableView.mj_header beginRefreshing];
}

#pragma mark ----- did selected row at indexPath -----
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

@end
