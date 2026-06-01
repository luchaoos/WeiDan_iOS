//
//  BranchViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/17.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BranchViewController.h"
#import "BranchCell.h"


#import "ShopErrorsViewController.h"


@interface BranchViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *braTableView;
@end

@implementation BranchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.braTableView];
    [self drawUI];
}
- (UITableView *)braTableView{
    if (!_braTableView) {
        _braTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
        _braTableView.delegate = self;
        _braTableView.dataSource = self;
        _braTableView.backgroundColor = [UIColor whiteColor];
        _braTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _braTableView.rowHeight = 80;
        if ([_braTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_braTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_braTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_braTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
    return _braTableView;
}
- (void)drawUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    view.backgroundColor = RGB(232, 238, 241);
    [self.view addSubview:view];
    CustomLabel *headLable = [[CustomLabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40) withContent:@"3店通用" font:18.0 andRGBr:181 RGBg:186 RGBb:187 adaptive:NO];
    [view addSubview:headLable];
    _braTableView.tableHeaderView = view;
}

#pragma mark tableViewDasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [BranchCell cellForTableView:_braTableView];
    
}
#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopErrorsViewController *svc = [[ShopErrorsViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
