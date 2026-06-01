//
//  LocationViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "LocationViewController.h"
#import "PullView.h"
#import "GrayView.h"


@interface LocationViewController ()<UISearchBarDelegate, PullViewDelegate, GrayViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
//    NSMutableArray *_tempArr;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)PullView *pview;
@property (nonatomic, strong)GrayView *gview;
@property (nonatomic, strong)UIView *tview;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//
    [self loadData];
    [self headerView];

}
-(void)loadData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getCityCallBack:" setFailBackFunctionName:nil];
    [dataProvider getAllCity];
}
-(void)getCityCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:dict[@"error"]];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
}


#pragma mark 数据输入
- (void)headerView{
//    [_tempArr removeAllObjects];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"北京市", @"上海市", @"香港", @"澳门", @"深圳", @"广州", @"厦门", @"台湾", @"北京市", @"北京市"]];
    _pview = [[PullView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 30)withCurrentCity:@"当前: 临沂" andCityArr:arr];
    [self.view addSubview:_pview];
    _pview.delegate = self;
    
    
    NSMutableArray *recentlyArr = [NSMutableArray arrayWithArray:@[@"海南", @"呼和浩特", @"钓鱼岛", @"台湾", @"临沂", @"临沂", @"🇭🇰"]];
    NSMutableArray *historyArr = [NSMutableArray arrayWithArray:@[@"呼和浩特", @"临沂", @"呼和浩特", @"临沂", @"临沂", @"呼和浩特", @"临沂"]];
    
//    [_tempArr addObjectsFromArray:recentlyArr];
//    [_tempArr addObjectsFromArray:historyArr];
    NSInteger line2 = (recentlyArr.count-1)/3 +1;
    NSInteger line3 = (historyArr.count-1)/3+1;
    
    CGFloat height = (30+10)*3+(25+5)*(line2+line3+1)+5;
    _gview = [[GrayView alloc]initWithFrame:CGRectMake(0, [Util ReturnViewFrame:_pview Direction:@"Y"], SCREEN_WIDTH, height) currentCity:@"齐齐哈尔" recentlyCity:recentlyArr historyCity:historyArr andNum:arr.count];
    _gview.delegate = self;
    [self.view addSubview:_gview];
    
    [self.view addSubview:self.tableView];
    
}
#pragma mark tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30+64, SCREEN_WIDTH, SCREEN_HEIGHT-30-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = _gview;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
#pragma mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"ident";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    CustomLabel *label = [[CustomLabel alloc]initWithFrame:CGRectMake(10, 5, 150, 50) withContent:@"鞍山" font:15.0 andRGBr:0 RGBg:0 RGBb:0 adaptive:NO];
    [cell.contentView addSubview:label];
    return cell;
}
#pragma mark 响应事件
// 点击城市响应事件
- (void)pickCity:(UIButton *)btn{
    // 发送通知

    NSLog(@"被点了%ld", (long)btn.tag);
    [UIView animateWithDuration:0.2 animations:^{
        CGRect gFrame = _tableView.frame;
        gFrame.origin.y = [Util ReturnViewFrame:_pview Direction:@"Y"];
        _tableView.frame = gFrame;
    }];
}
- (void)grayClicl:(UIButton *)btn{
    NSLog(@"摩擦摩擦%ld", (long)btn.tag);
    
    if (_pview.frame.size.height != 30) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newFrame = _pview.frame;
            newFrame.size.height = 30;
            _pview.frame = newFrame;
    
            CGRect gFrame = _tableView.frame;
            gFrame.origin.y = [Util ReturnViewFrame:_pview Direction:@"Y"];
            _tableView.frame = gFrame;
        }];
    }
}
// 选择县区下拉相应事件
- (void)pickCityClick{

    [UIView animateWithDuration:0.2 animations:^{
        CGRect gFrame = _tableView.frame;
        gFrame.origin.y = [Util ReturnViewFrame:_pview Direction:@"Y"];
        _tableView.frame = gFrame;
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
