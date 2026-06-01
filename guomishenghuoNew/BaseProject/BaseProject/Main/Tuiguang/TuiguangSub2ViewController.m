//
//  TuiguangSub2ViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/6/5.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "TuiguangSub2ViewController.h"

@interface TuiguangSub2Cell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;


@end

@implementation TuiguangSub2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"TuiguangSub1Cell" owner:nil options:nil].lastObject;
    }
    return self;
}

@end

@interface TuiguangSub2ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation TuiguangSub2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _list = @[].mutableCopy;
    _lblTitle.text=@"推广佣金";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60.f;

    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_list removeAllObjects];
        [self getData];
    }];
    header.ignoredScrollViewContentInsetTop = 24.f;
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)getData {
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getDataFinish:" setFailBackFunctionName:nil];
    [dataProvider shopIndexServiceGetCommissionListWithShopid:get_sp(user_ID) startRowIndex:[NSString stringWithFormat:@"%ld", self.list.count] maximumRows:@"10"];
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
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"TuiguangSub1Cell";
    TuiguangSub2Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TuiguangSub2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.label1.text = self.list[indexPath.row][@"Name"];
    if (!cell.label1.text || cell.label1.text.length == 0) {
        cell.label1.text = @"(未设置)";
    }
    cell.label2.text = [NSString stringWithFormat:@"%@", self.list[indexPath.row][@"Description"]] ;
    cell.label3.text = [NSString stringWithFormat:@"%@", self.list[indexPath.row][@"OperateTime"]];
    cell.label4.text = [NSString stringWithFormat:@"%.2lf元", [self.list[indexPath.row][@"Amount"] doubleValue]];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
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
