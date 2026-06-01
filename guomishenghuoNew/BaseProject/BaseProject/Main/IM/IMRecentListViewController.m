//
//  IMRecentListViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/29.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "IMRecentListViewController.h"
#import "IMRecentCell.h"
#import "IMRecentViewController.h"
#import "IMAddFriendsViewController.h"
#import "IMSearchFriendViewController.h"
#import "TuiguangViewController.h"

@interface IMRecentListViewController () //<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation IMRecentListViewController

static NSString *kRecentCellId = @"kRecentCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    _lblLeft.text = @"推广";
    [_btnLeft setTitle:@"推广" forState:UIControlStateNormal];
    [_btnLeft addTarget:self action:@selector(tuiguang:) forControlEvents:UIControlEventTouchUpInside];
    _imgLeft.hidden = YES;
    _lblTitle.text = @"朋友";
    
    UIButton * btn_MessageVC=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 30, 25, 25)];
    [btn_MessageVC setImage:[UIImage imageNamed:@"tianjiahaoyou"] forState:UIControlStateNormal];
    [btn_MessageVC addTarget:self action:@selector(tianjiahaoyou:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_MessageVC];
    
    
    UIButton * btn_scanVC=[[UIButton alloc] initWithFrame:CGRectMake(btn_MessageVC.frame.origin.x-50, 30, 25, 25)];
    [btn_scanVC setImage:[UIImage imageNamed:@"sousuohaoyou"] forState:UIControlStateNormal];
    //    [btn_scanVC addTarget:self action:@selector(JumpToScan) forControlEvents:UIControlEventTouchUpInside];
    [btn_scanVC addTarget:self action:@selector(sousuohaoyou:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_scanVC];
    
//    self.list = @[].mutableCopy;
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([IMRecentCell class]) bundle:nil] forCellReuseIdentifier:kRecentCellId];
    
    
    IMRecentViewController *vc = [[IMRecentViewController alloc] init];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.view addSubview:vc.view];
}

- (void)tuiguang:(UIButton *)sender {
     TuiguangViewController *vc=[[TuiguangViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sousuohaoyou:(UIButton *)sender {
    IMSearchFriendViewController *vc = [[IMSearchFriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tianjiahaoyou:(UIButton *)sender {
    IMAddFriendsViewController *vc = [[IMAddFriendsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.list.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    IMRecentCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecentCellId];
//    
//    
//    return cell;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_app_ showTabBar];
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
