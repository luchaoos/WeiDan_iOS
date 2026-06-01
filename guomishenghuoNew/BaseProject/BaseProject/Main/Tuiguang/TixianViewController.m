//
//  TixianViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/6/5.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "TixianViewController.h"

@interface TixianCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation TixianCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"TixianCell" owner:nil options:nil].lastObject;
    }
    return self;
}

@end

@interface TixianViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UILabel *backNoLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation TixianViewController

- (IBAction)tixian:(id)sender {
    if (!_moneyText.text || _moneyText.text.length == 0) {
        return [SVProgressHUD showErrorWithStatus:@"请填写金额"];
    }
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"shenqingtixianFinish:" setFailBackFunctionName:nil];
    [dataProvider commissionServiceWithDrawCashWithShopid:get_sp(user_ID) money:_moneyText.text];
}

- (void)shenqingtixianFinish:(NSDictionary *)data {
    if (RequestSuccess(data)) {
        [SVProgressHUD showSuccessWithStatus:@"申请成功"];
    } else  {
        [SVProgressHUD showErrorWithStatus:data[@"error"]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _list = @[].mutableCopy;
    
    self.tableView.tableFooterView = [UIView new];
    NSMutableString *str = @"".mutableCopy;
    [str appendString:[self.backNo substringToIndex:4]];
    [str appendString:@"********"];
    [str appendString:[self.backNo substringFromIndex:self.backNo.length - 4]];
    self.backNoLabel.text = str;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    MJWeakSelf
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [self.tableView.mj_footer beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)getData {
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getDataFinish:" setFailBackFunctionName:nil];
    [dataProvider shopIndexServiceGetWithDrawListWithShopid:get_sp(user_ID) startRowIndex:[NSString stringWithFormat:@"%li", _list.count] maximumRows:@"10"];
}

- (void)getDataFinish:(NSDictionary *)data {
    if (RequestSuccess(data)) {
        [_list addObjectsFromArray:data[@"data"]];
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
    static NSString *ID = @"TixianCell";
    TixianCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TixianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary *obj = _list[indexPath.row];
    cell.label1.text = [NSString stringWithFormat:@"%@", obj[@"Name"]];
    NSString *state;
    if ([obj[@"State"] integerValue] == 0) {
        state = @"待审核";
    } else if ([obj[@"State"] integerValue] == 1) {
        state = @"已通过";
    } else if ([obj[@"State"] integerValue] == 2) {
        state = @"未通过";
    }
    cell.label2.text = [NSString stringWithFormat:@"%@", state];
    cell.label3.text = [NSString stringWithFormat:@"%@", obj[@"WithDrawTime"]];
    cell.label4.text = [NSString stringWithFormat:@"%.2lf元", [obj[@"Amount"] doubleValue]];
    return cell;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
