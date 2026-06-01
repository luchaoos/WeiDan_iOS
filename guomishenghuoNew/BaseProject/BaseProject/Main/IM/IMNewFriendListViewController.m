//
//  IMNewFriendListViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/31.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "IMNewFriendListViewController.h"
#import "IMRecentCell.h"
#import "LCNetworkManager.h"

@interface IMNewFriendListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation IMNewFriendListViewController
static NSString *addFriendCellId = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.text = @"新的朋友";
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.list = @[].mutableCopy;
    self.tableView.rowHeight = 60.f;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([IMRecentCell class]) bundle:nil] forCellReuseIdentifier:addFriendCellId];
    
    [self getdata];

}

- (void)getdata {
    [SVProgressHUD show];
    [[LCNetworkManager sharedManager]
     requestWithURL:kFriendService
     function:@"SelectApplyList"
     params:@{
              @"userid" : get_sp(user_ID),
              @"startRowIndex" : @"0",
              @"maximumRows" : @"100"}
     success:^(id responseData) {
         [SVProgressHUD dismiss];
         
         self.list = [responseData mutableCopy];
         [self.tableView reloadData];
         NSLog(@"%@", responseData);
     } failure:^(NSError *error) {
         NSLog(@"%@", error.localizedDescription);
         [SVProgressHUD dismiss];
         [SVProgressHUD showErrorWithStatus:error.domain];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMRecentCell *cell = [tableView dequeueReusableCellWithIdentifier:addFriendCellId];
    NSDictionary *dict = self.list[indexPath.row];
    cell.label1.text = [NSString stringWithFormat:@"用户名:%@", dict[@"NicName"]];
    cell.label2.text = [NSString stringWithFormat:@"申请时间:%@", dict[@"JoinTime"]];
    NSString *photo = dict[@"PhotoPath"];
    if (![photo hasPrefix:@"http"]) {
        photo = [@"http://121.40.189.165/" stringByAppendingString:photo];
    }
    [cell.image sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    cell.btn1.hidden = NO;
    cell.btn2.hidden = NO;
    MJWeakSelf
    cell.btn1Block = ^{
        [SVProgressHUD show];
        [[LCNetworkManager sharedManager]
         requestWithURL:kFriendService
         function:@"AgreeFriendAndSaveFriend"
         params:@{@"applyid" : dict[@"Id"]}
         success:^(id responseData) {
             [SVProgressHUD dismiss];
             [SVProgressHUD showSuccessWithStatus:@"添加朋友成功"];
             [weakSelf getdata];
             NSLog(@"%@", responseData);
         } failure:^(NSError *error) {
             NSLog(@"%@", error.localizedDescription);
             [SVProgressHUD dismiss];
             [SVProgressHUD showErrorWithStatus:error.domain];
         }];
    };
    cell.btn2Block = ^{
        
    };
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
