//
//  JiFenOrderEnterViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/14.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "JiFenOrderEnterViewController.h"
#import "JiFenOrderEnterCell.h"
#import "DataProviderOther.h"

@interface JiFenOrderEnterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation JiFenOrderEnterViewController


- (IBAction)tijiao:(id)sender {
    DataProviderOther *dataProvider = [[DataProviderOther alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"SaveBasketBillFinish:" setFailBackFunctionName:nil];
    
    [self.view endEditing:YES];
    NSMutableArray *arr = @[].mutableCopy;
    for (NSDictionary *obj in self.list) {
        if (obj[@"type"] && [obj[@"type"] integerValue] == 1) {
            [arr addObject:[NSString stringWithFormat:@"%@,%@,%@", @"1", obj[@"Id"], obj[@"msg"] ? obj[@"msg"] : @" "]];
        } else {
            [arr addObject:[NSString stringWithFormat:@"%@,%@,%@", @"2", obj[@"Id"], obj[@"msg"] ? obj[@"msg"] : @" "]];
        }
    }
    [dataProvider SaveBasketBillWithlist_billid:[Toolkit NSArrayToJsonString:arr] addressid:[NSString stringWithFormat:@"%@", self.data[@"AddressList"][0][@"Id"]] totalprice:[NSString stringWithFormat:@"%.2lf", [self getSumPrice]] list_basketbillid:self.list_basketbillid ? [Toolkit NSArrayToJsonString:self.list_basketbillid] : @"[]"];

    [SVProgressHUD show];
}

- (void)SaveBasketBillFinish:(NSDictionary *)data {
    NSLog(@"%@", data);
    [SVProgressHUD dismiss];
    if (RequestSuccess(data)) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.text = @"提交订单";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.sectionHeaderHeight = 1.f;
    self.tableView.sectionFooterHeight = 15.f;
    
    
    self.list = @[].mutableCopy;
    for (NSDictionary *dict in self.data[@"BillList"]) {
        [self.list addObject:dict.mutableCopy];
    }
    
    self.sumLabel.text = [NSString stringWithFormat:@"合计:%.2lf", [self getSumPrice]];
}

- (CGFloat)getSumPrice {
    CGFloat sum = 0.0;
    for (NSDictionary *obj in self.list) {
//        if (obj[@"type"] && [obj[@"type"] integerValue] == 1) {
            sum += [obj[@"TotalPrice"] doubleValue];
//        } else {
//            sum += ([obj[@"TotalPrice"] doubleValue] + [obj[@"TransportationFee"] doubleValue]);
//        }
    }
    return sum;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 2) {
        return 1;
    }
    return [self.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 1) {
        return 50;
    }
    
    NSDictionary *obj = self.list[indexPath.row];

    return 30 + 100 + [obj[@"BillDetailList"] count] * 80 + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *iD = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iD];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iD];
        }
        NSDictionary *obj = self.data[@"AddressList"][0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@，%@", obj[@"Name"], obj[@"Phone"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", obj[@"AddressDetail"]];
        return cell;
    }
    else if(indexPath.section == 2) {
        static NSString *iD = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iD];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iD];
        }
        NSDictionary *obj = self.data[@"AddressList"][0];
        // 已绑定手机号:
        cell.textLabel.text = [NSString stringWithFormat:@"已绑定手机号:%@", obj[@"Phone"]];
        return cell;
    }
    
    static NSString *ID = @"JiFenOrderEnterCell";
    JiFenOrderEnterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JiFenOrderEnterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.data = self.list[indexPath.row];
    
    __block NSMutableDictionary *dict = self.list[indexPath.row];
    MJWeakSelf
    cell.msgEditBlock = ^(NSString *msg) {
        dict[@"msg"] = msg ? msg : @"";
        [weakSelf.tableView reloadData];
    };
    
    cell.peisongBlock = ^() {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//        [alert addAction:[UIAlertAction actionWithTitle:@"快递" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            dict[@"type"] = @"2";
//            [weakSelf.tableView reloadData];
//            weakSelf.sumLabel.text = [NSString stringWithFormat:@"合计:%.2lf", [self getSumPrice]];
//        }]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"到付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            dict[@"type"] = @"1";
//            [weakSelf.tableView reloadData];
//            weakSelf.sumLabel.text = [NSString stringWithFormat:@"合计:%.2lf", [self getSumPrice]];
//        }]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }]];
//        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
