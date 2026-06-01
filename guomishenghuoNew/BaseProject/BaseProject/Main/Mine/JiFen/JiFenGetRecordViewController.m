//
//  JiFenGetRecordViewController.m
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/14.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "JiFenGetRecordViewController.h"
#import "JiFenTableViewCell.h"

#define CellHeight 50

@interface JiFenGetRecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)UITableView *tableView;

@end

@implementation JiFenGetRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navtitle = @"我的购物券获取记录";
    [self addLeftButton:@"fanhui"];
    
    [self createViews];
}
-(void)createViews{
 
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT-Header_Height)];
    _tableView.delegate = self;
    _tableView.dataSource= self; 
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_tableView];
}
#pragma mark ----- number of sections and rows -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
#pragma mark ----- height for section and row -----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}
#pragma mark ----- setting for cell -----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"cell";
    JiFenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[JiFenTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.jifenWay.text = @"充值（支付宝支付）";
    cell.jifentime.text = @"2016-01-23";
    cell.jifendetail.text = @"金额：100";
    cell.jifenmoney.text = @"+100";
    
    return cell;
}
#pragma mark ----- did selected row at indexPath -----
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

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
