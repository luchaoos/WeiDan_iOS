//
//  JiFenShopingCarViewController.m
//  BaseProject
//
//  Created by 陆超 on 2017/7/10.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "JiFenShopingCarViewController.h"
#import "JiFenShopingCarCell.h"
#import "DataProviderOther.h"
#import "JiFenOrderEnterViewController.h"


@interface JiFenShopingCarEn : NSObject

@property (nonatomic, copy) NSString *ShopId;
@property (nonatomic, copy) NSString *ShopName;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *ProductImage;
@property (nonatomic, copy) NSString *ProductPriceName;
@property (nonatomic, copy) NSString *BillId;
@property (nonatomic, copy) NSString *ProductId;
@property (nonatomic, copy) NSString *ProductName;
@property (nonatomic, copy) NSString *ProductNum;
@property (nonatomic, copy) NSString *DetailPrice;
@property (nonatomic, copy) NSString *ProductPrice;


@end

@implementation JiFenShopingCarEn

//+ (instancetype)enWithDictionary:(NSDictionary *)dict {
//    JiFenShopingCarEn *en = [[JiFenShopingCarEn alloc] init];
////    en.ShopId =
//    return en;
//}

@end

@interface JiFenShopingCarViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) CGFloat sumPrice;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UIButton *allSelBtn;

@property (nonatomic, strong) NSArray *list_billid;
@end

@implementation JiFenShopingCarViewController
/*SubmitBasketNew
 SelectBasket*/

static NSString *const cellId = @"JiFenShopingCarCell";


static NSString *const headerId = @"JiFenShopingCarHeader";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_app_ hiddenTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.text = @"购物车";
    
    self.data = @[].mutableCopy;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100.f;
    self.tableView.sectionHeaderHeight = 30.f;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JiFenShopingCarCell class]) bundle:nil] forCellReuseIdentifier:cellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"JiFenShopingCarHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:headerId];
    
    [self getData];
}

- (IBAction)jiesuan:(id)sender {
    
    NSMutableArray *list_billdetail = @[].mutableCopy;
    NSMutableArray *list_billid = @[].mutableCopy;
    for (NSMutableDictionary *obj in self.data) {
        for (NSMutableDictionary *dict in obj[@"list"]) {
            if ([dict[@"isSel"] boolValue] == YES) {
                [list_billid addObject:obj[@"BillId"]];
                [list_billdetail addObject:dict];
                self.list_billid = list_billid;
            }
        }
    }
    
    [SVProgressHUD show];
    DataProviderOther *dataProvider = [[DataProviderOther alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"BuildBillNewFinish:" setFailBackFunctionName:nil];
    [dataProvider BuildBillNewWithDetail:[Toolkit NSArrayToJsonString:list_billdetail] andtype:@"1" list_billid:[Toolkit NSArrayToJsonString:list_billid] pointprice:[NSString stringWithFormat:@"%.2lf", self.sumPrice]];
}

- (void)BuildBillNewFinish:(NSDictionary *)data {
    
    [SVProgressHUD dismiss];
    
    if (RequestSuccess(data)) {
        
        NSLog(@"%@", data);
        
        JiFenOrderEnterViewController *vc = [[JiFenOrderEnterViewController alloc] init];
        vc.data = data[@"data"];
        vc.list_basketbillid = self.list_billid;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:data[@"error"]];
    }
}

- (void)getData {
    DataProviderOther *dataProvider = [[DataProviderOther alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getDataFinish:" setFailBackFunctionName:nil];
    [dataProvider GetShoppingCarDataWithUserId:get_sp(user_ID)];
}



- (void)getDataFinish:(NSDictionary *)data {
    if (RequestSuccess(data)) {
        NSLog(@"%@", data);
        
        NSMutableArray *sectionIds = @[].mutableCopy;
        for (NSDictionary *dict in data[@"data"]) {
            [sectionIds addObject:dict[@"Shop"][0][@"Id"]];
        }
        NSArray *secIds = [sectionIds valueForKeyPath:@"@distinctUnionOfObjects.self"];
        NSLog(@"%@", secIds);
        
        NSMutableArray *arr = @[].mutableCopy;
        for (int i = 0; i < secIds.count; i++) {
            NSInteger secId = [secIds[i] integerValue];
            NSMutableDictionary *obj = @{}.mutableCopy;
            obj[@"isSel"] = @NO;
            obj[@"list"] = @[].mutableCopy;
            for (int j = 0; j < [data[@"data"] count]; j++) {
                NSDictionary *dict = data[@"data"][j][@"Shop"][0];
                if ([dict[@"Id"] integerValue] == secId) {
                    [obj setValuesForKeysWithDictionary:dict];
                    [obj removeObjectForKey:@"DetailList"];
                    if ([dict[@"DetailList"] count] > 0) {
                        NSMutableDictionary *good = [dict[@"DetailList"][0] mutableCopy];
                        good[@"isSel"] = @NO;
                        [(NSMutableArray *)obj[@"list"] addObject:good];
                    }
                }
            }
            [arr addObject:obj];
        }
        
        NSLog(@"%@", arr);
        self.data = arr;
        
        [self.tableView reloadData];
    } else {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍候再试"];
    }
}


- (IBAction)allSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    for (NSMutableDictionary *obj in self.data) {
        obj[@"isSel"] = @(sender.selected);
        for (NSMutableDictionary *dict in obj[@"list"]) {
            dict[@"isSel"] = @(sender.selected);
        }
    }
    [self.tableView reloadData];
    [self displaySumPrice];
}

- (void)displaySumPrice {
    
    self.sumPrice = 0;
    
    BOOL flag = YES;
    for (NSMutableDictionary *obj in self.data) {
        for (NSMutableDictionary *dict in obj[@"list"]) {
            if ([dict[@"isSel"] boolValue] == YES) {
                self.sumPrice += [dict[@"ProductPrice"] doubleValue] * [dict[@"ProductNum"] doubleValue];
            } else {
                flag = NO;
            }
        }
    }
    self.allSelBtn.selected = flag;
    self.sumLabel.text = [NSString stringWithFormat:@"总价：%.2lf", self.sumPrice];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data[section][@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JiFenShopingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    __block NSMutableDictionary *obj = [self.data[indexPath.section][@"list"][indexPath.row] mutableCopy];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", obj[@"ProductName"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", [obj[@"ProductPrice"] doubleValue]];
    NSString *stockNum = @"";
    if ([obj[@"StockNum"] integerValue] == 0) {
        stockNum = @"暂时无货";
    } else if ([obj[@"StockNum"] integerValue] == -1) {
        stockNum = @"库存:无限";
    } else {
        stockNum = [NSString stringWithFormat:@"库存:%@", obj[@"StockNum"]];
    }
    cell.detailLabel.text = [NSString stringWithFormat:@"规格:%@ %@", obj[@"ProductPriceName"], stockNum];
    cell.numTxt.text = [NSString stringWithFormat:@"%@", obj[@"ProductNum"]];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.40.189.165/%@", obj[@"ProductImage"]]] placeholderImage:nil];
    cell.selBtn.selected = [obj[@"isSel"] boolValue];
    if ([obj[@"StockNum"] integerValue] == 0) {
        cell.selBtn.enabled = NO;
    } else {
        cell.selBtn.enabled = YES;
    }
    
    MJWeakSelf
    [cell setSelectBlock:^ (BOOL isSel) {
        obj[@"isSel"] = @(isSel);
        [(NSMutableArray *)weakSelf.data[indexPath.section][@"list"] replaceObjectAtIndex:indexPath.row withObject:obj];
        
        BOOL flag = YES;
        for (NSMutableDictionary *dict in weakSelf.data[indexPath.section][@"list"]) {
            if ([dict[@"isSel"] boolValue] == NO) {
                flag = NO;
                break;
            }
        }
        
        NSMutableDictionary *d = weakSelf.data[indexPath.section];
        d[@"isSel"] = @(flag);
        
        [weakSelf.tableView reloadData];
        [weakSelf displaySumPrice];
    }];
    
    [cell setPlusNumBlock:^{
        NSInteger num = [obj[@"ProductNum"] integerValue];
        num += 1;
        obj[@"ProductNum"] = [NSString stringWithFormat:@"%li", num];
        [(NSMutableArray *)self.data[indexPath.section][@"list"] replaceObjectAtIndex:indexPath.row withObject:obj];
        [weakSelf.tableView reloadData];
        
        [weakSelf changeNumWithId:obj[@"Id"] num:obj[@"ProductNum"]];
    }];
    
    [cell setSubNumBlock:^{
        NSInteger num = [obj[@"ProductNum"] integerValue];
        if (num == 1) return;
        num -= 1;
        obj[@"ProductNum"] = [NSString stringWithFormat:@"%li", num];
        [(NSMutableArray *)self.data[indexPath.section][@"list"] replaceObjectAtIndex:indexPath.row withObject:obj];
        [weakSelf.tableView reloadData];
        
        [weakSelf changeNumWithId:obj[@"Id"] num:obj[@"ProductNum"]];
    }];
    
    [cell setDeleteBlock:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除该商品" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf deleteGoodWithDetaillist:[Toolkit NSArrayToJsonString:@[obj[@"Id"]]] idx:indexPath];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
    
    return cell;
}

- (void)deleteGoodWithDetaillist:(NSString *)detaillist idx:(NSIndexPath *)idx{
    
    [SVProgressHUD show];
    DataProviderOther *dataProvider = [[DataProviderOther alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"deleteGoodFinish:" setFailBackFunctionName:nil];
    [dataProvider DeleteForBasketWithlist_detail:detaillist];
    
    [(NSMutableArray *)self.data[idx.section][@"list"] removeObjectAtIndex:idx.row];
    if ([self.data[idx.section][@"list"] count] <= 0) {
        [self.data removeObjectAtIndex:idx.section];
    }
    [self.tableView reloadData];
}

- (void)deleteGoodFinish:(NSDictionary *)data {
    [SVProgressHUD dismiss];
    if (!RequestSuccess(data)) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }
}

- (void)changeNumWithId:(NSString *)Id num:(NSString *)num {
    
    [SVProgressHUD show];
    DataProviderOther *dataProvider = [[DataProviderOther alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"changeNumFinish:" setFailBackFunctionName:nil];
    [dataProvider ChangeProductNumForBasketWithdetailid:Id andnum:num];
}

- (void)changeNumFinish:(NSDictionary *)data {
    [SVProgressHUD dismiss];
    if (!RequestSuccess(data)) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }
    NSLog(@"%@", data);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JiFenShopingCarHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];//[[NSBundle mainBundle] loadNibNamed:@"JiFenShopingCarHeader" owner:nil options:nil][0];
    __block NSMutableDictionary *obj = self.data[section];
    header.nameLabel.text = [NSString stringWithFormat:@"%@", obj[@"Name"]];
    header.selBtn.selected = [obj[@"isSel"] boolValue];
    MJWeakSelf
    [header setSelectBlock:^(BOOL isSel){
        obj[@"isSel"] = @(isSel);
        if (isSel == YES) {
            for (NSMutableDictionary *dict in obj[@"list"]) {
                dict[@"isSel"] = @YES;
            }
        }
        else {
            for (NSMutableDictionary *dict in obj[@"list"]) {
                dict[@"isSel"] = @NO;
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf displaySumPrice];
    }];
    return header;
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
