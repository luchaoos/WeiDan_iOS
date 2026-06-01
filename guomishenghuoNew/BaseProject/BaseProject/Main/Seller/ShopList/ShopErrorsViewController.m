//
//  ShopErrorsViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/17.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShopErrorsViewController.h"
#import "ShopErrorCell.h"

@interface ShopErrorsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property(nonatomic, strong)UITableView *errTableView;
@property(nonatomic, strong)UIView *bottomView;
@end

@implementation ShopErrorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.errTableView];

    [self setupView];
}
- (void)setupView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:_errTableView Direction:@"Y"], SCREEN_WIDTH, SCREEN_HEIGHT-[Util ReturnViewFrame:_errTableView Direction:@"Y"])];
    [self.view addSubview:view];
    view.backgroundColor = RGB(232, 238, 241);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(35);
    }];
    
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.tintColor = [UIColor whiteColor];
    _errTableView.tableFooterView = view;
}

- (UITableView *)errTableView{
    if (!_errTableView) {
        _errTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-49-64)];
        _errTableView.delegate = self;
        _errTableView.dataSource = self;
        _errTableView.rowHeight = 50;
        _errTableView.scrollEnabled = NO;
        if ([_errTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_errTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_errTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_errTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _errTableView;
}
#pragma mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopErrorCell *cell = [ShopErrorCell tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell;
}
#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = RGB(232, 238, 241);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 30)];
        [view addSubview:label];
        label.text = @"纠错信息";
        return view;
    }
    return nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
