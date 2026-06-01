//
//  IMSearchFriendViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/31.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "IMSearchFriendViewController.h"
#import "LCNetworkManager.h"
#import "IMRecentCell.h"
#import "IMFriendInfoViewController.h"
#import "IMNewFriendListViewController.h"

@interface IMSearchFriendViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation IMSearchFriendViewController

static NSString *addFriendCellId = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text = @"搜索好友";
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    self.list = @[].mutableCopy;
    self.tableView.rowHeight = 60.f;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([IMRecentCell class]) bundle:nil] forCellReuseIdentifier:addFriendCellId];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_app_ hiddenTabBar];
    
    [self getAllFriends];
}

- (IBAction)newFriends:(id)sender {
    IMNewFriendListViewController *vc = [[IMNewFriendListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getAllFriends {
    [SVProgressHUD show];
    [[LCNetworkManager sharedManager]
     requestWithURL:kFriendService
     function:@"SelectFriended"
     params:@{@"userid" : get_sp(user_ID),}
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [SVProgressHUD show];
    [[LCNetworkManager sharedManager]
     requestWithURL:kFriendService
     function:@"SearchFriendByPhone"
     params:@{@"phone" : searchBar.text,
              @"userid" : get_sp(user_ID),}
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMRecentCell *cell = [tableView dequeueReusableCellWithIdentifier:addFriendCellId];
    NSDictionary *dict = self.list[indexPath.row];
    cell.label1.text = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    cell.label2.text = [NSString stringWithFormat:@"%@", dict[@"RemarkName"]];
    NSString *photo = dict[@"PhotoPath"];
    if (![photo hasPrefix:@"http"]) {
        photo = [@"http://121.40.189.165/" stringByAppendingString:photo];
    }
    [cell.image sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = [self.list[indexPath.row] mutableCopy];
    dict[@"IsFriend"] = @1;
    IMFriendInfoViewController *vc = [[IMFriendInfoViewController alloc] init];
    vc.userInfoDict = dict;
    vc.userId = dict[@"UserId"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
