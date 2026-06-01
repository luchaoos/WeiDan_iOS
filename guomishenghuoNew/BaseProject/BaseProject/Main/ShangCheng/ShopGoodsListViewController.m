//
//  ShopGoodsListViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/6/17.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "ShopGoodsListViewController.h"
#import "ShopGoodsListCell.h"
#import "GoodDetialViewController.h"
#import "IMChatViewController.h"

@interface ShopGoodsListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSArray *imgURLs;
@property (nonatomic, strong) NSArray *imgTitles;

@end

@implementation ShopGoodsListViewController

- (NSMutableArray *)list {
    if (!_list) {
        _list = @[].mutableCopy;
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _lblTitle.text=@"店铺详情";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    MJWeakSelf
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.list removeAllObjects];
        [weakSelf getData];
    }];
//    header.ignoredScrollViewContentInsetTop = 24.f;
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    
    [self.tableView.mj_header beginRefreshing];
    
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getImageDataFinish:" setFailBackFunctionName:nil];
    [dataProvider ShopIndexGetPointPictureWithShopid:[NSString stringWithFormat:@"%@", self.shopId]];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"客服" style:UIBarButtonItemStylePlain target:self action:@selector(kefu:)];
    [_btnRight setTitle:@"客服" forState:UIControlStateNormal];
    [_btnRight addTarget:self action:@selector(kefu:) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)kefu:(id)sender {
    IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
    conversationVC.conversationType = 1;
    conversationVC.targetId = self.shopId;
    conversationVC.title = @"客服";
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)getImageDataFinish:(NSDictionary *)data {
    if (RequestSuccess(data)) {
        NSArray *arr = data[@"data"];
        NSMutableArray *arrImg = @[].mutableCopy;
        NSMutableArray *arrTitle = @[].mutableCopy;
        
        for (NSDictionary *obj in arr) {
            [arrImg addObject:obj[@"ImagePath"]];
            [arrTitle addObject:obj[@"Name"]];
        }
        
        self.imgURLs = arrImg.copy;
        self.imgTitles = arrTitle.copy;
        [self.tableView reloadData];
    }
}

- (void)getData {
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getDataFinish:" setFailBackFunctionName:nil];
    [dataProvider shopIndexServiceGetPointProductWithShopid:[NSString stringWithFormat:@"%@", self.shopId] startRowIndex:[NSString stringWithFormat:@"%ld", self.list.count] maximumRows:@"10"];
}



- (void)getDataFinish:(NSDictionary *)data {
    if (RequestSuccess(data)) {
        [self.list addObjectsFromArray:data[@"data"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([data[@"data"] count] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } else {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID1 = @"ShopGoodsTopCell";
    static NSString *ID2 = @"ShopGoodsListCell";
    if (indexPath.section == 0) {
        ShopGoodsTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (!cell) {
            cell = [[ShopGoodsTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
        }
        cell.imgURLs = self.imgURLs;
//        cell.imgTitles = self.imgTitles;
        return cell;
    } else if (indexPath.section == 1) {
        ShopGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        if (!cell) {
            cell = [[ShopGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID2];
        }
        cell.data = self.list[indexPath.row];
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180.f * SCREEN_WIDTH / 375;
    } else if (indexPath.section == 1) {
        
        return 175.f * SCREEN_WIDTH / 375;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodDetialViewController *vc = [[GoodDetialViewController alloc] init];
    vc.goodId = self.list[indexPath.row][@"Id"];
    [self.navigationController pushViewController:vc animated:YES];
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
