//
//  PanicBuyViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PanicBuyViewController.h"
#import "PanBuyTableViewCell.h"


#import "BranchViewController.h"

@interface PanicBuyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *panTabelView;
@end

@implementation PanicBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self.view addSubview:self.panTabelView];
}
- (UITableView *)panTabelView{
    if (!_panTabelView) {
        _panTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
        _panTabelView.delegate = self;
        _panTabelView.dataSource = self;
        _panTabelView.separatorColor = RGB(221, 221, 221);
        _panTabelView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _panTabelView.showsVerticalScrollIndicator = NO;
        _panTabelView.rowHeight = 95;
    }
    return _panTabelView;
}
#pragma mark tabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *panIdent = @"panIden";
    PanBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:panIdent];
    if (!cell) {
        cell = [[PanBuyTableViewCell alloc]init];
    }
    return cell;
}
#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BranchViewController *bvc = [[BranchViewController alloc]init];
    [self.navigationController pushViewController:bvc animated:YES];
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
