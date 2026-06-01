//
//  IMAddFriendsViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/31.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "IMAddFriendsViewController.h"
#import "LCNetworkManager.h"
#import "IMRecentCell.h"
#import "IMFriendInfoViewController.h"
//#import "IMNewFriendListViewController.h"

@interface IMAddFriendsViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (nonatomic, strong) NSMutableArray *list;
@end


@implementation IMAddFriendsViewController

static NSString *addFriendCellId = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text = @"添加好友";
    
    self.tableVIew.tableFooterView = [UIView new];
    self.tableVIew.dataSource = self;
    self.tableVIew.delegate = self;
    self.searchBar.delegate = self;
    self.list = @[].mutableCopy;
    self.tableVIew.rowHeight = 60.f;
    [self.tableVIew registerNib:[UINib nibWithNibName:NSStringFromClass([IMRecentCell class]) bundle:nil] forCellReuseIdentifier:addFriendCellId];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [SVProgressHUD show];
    [[LCNetworkManager sharedManager]
     requestWithURL:kFriendService
     function:@"GetFriendBySearch"
     params:@{@"nicName" : searchBar.text,
              @"userid" : get_sp(user_ID),
              @"startRowIndex" : @"0",
              @"maximumRows" : @"100"}
     success:^(id responseData) {
         [SVProgressHUD dismiss];
         
         self.list = [responseData mutableCopy];
         [self.tableVIew reloadData];
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
    cell.label1.text = [NSString stringWithFormat:@"%@", dict[@"UserName"]];
    NSString *photo = dict[@"PhotoPath"];
    if (![photo hasPrefix:@"http"]) {
        photo = [@"http://121.40.189.165/" stringByAppendingString:photo];
    }
    [cell.image sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.list[indexPath.row];
    
    IMFriendInfoViewController *vc = [[IMFriendInfoViewController alloc] init];
    vc.userInfoDict = dict;
    vc.userId = dict[@"Id"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_app_ hiddenTabBar];
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
