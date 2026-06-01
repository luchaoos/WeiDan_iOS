//
//  AddressManagerViewController.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/7.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "AddressManagerViewController.h"

#define CellHeight 60

@interface AddressManagerViewController ()<UITableViewDataSource,UITableViewDelegate,AddressTableViewCellDelegate>
{
    int defaultIndex;
}
@property(nonatomic) UITableView *mainTableView;
@property(nonatomic) NSMutableArray <AddressModel *>*addressArr;
@property(nonatomic) BOOL EditMode;
@property(nonatomic) UIButton *addAddrBtn;
@end

@implementation AddressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    _app_.hiddenTabBar;
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSelfData) name:AddressVCRefresh object:nil];
}
-(void)refreshSelfData{
    [_mainTableView.mj_header beginRefreshing];
}

-(void)initView
{
    self.navtitle = @"我的收货地址";
    [self addRightbuttontitle:@"管理"];
    [self addLeftButton:@"fanhui"];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.addAddrBtn];
}

//-(void)buildTestData
//{
//    for (int i = 0; i < 4; i++) {
//        AddressModel *model = [[AddressModel alloc] init];
//        model.Address_addr = @"山东省临沂市兰山区金一路与通达路交汇处某某某某大厦";
//        model.Address_name = @"王大仙";
//        model.Address_phone = @"18810375188";
//        model.Address_sex = @"男";
//        [self.addressArr addObject:model];
//    }
//}

#pragma mark - self data source

-(void)loadData
{
    [self getAddressList];
    
}

-(void)getAddressList
{
//    AddressRequest *request = [[AddressRequest alloc] init];
//    [request setDelegateObject:self setSucceedBackFunctionName:@"getAddressCallBack:" setFailBackFunctionName:nil];
//    [request addressList];
}

-(void)getAddressCallBack:(id)dict
{
    ELog(dict);
    if (RequestSuccess(dict)) {
        NSArray *tempArr = dict[@"data"];
        [self.addressArr removeAllObjects];
        for (NSDictionary *tempDict in tempArr) {
            
            [self.addressArr addObject:[AddressModel AddressModelWithDict:tempDict]];
        }
        
        [self.mainTableView reloadData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    }
}

-(void)delAddressByID:(NSString *)addrid
{
//    AddressRequest *request = [[AddressRequest alloc] init];
//    [request setDelegateObject:self setSucceedBackFunctionName:@"delAddCallBack:" setFailBackFunctionName:nil];
//    [request delAddressWithID:addrid];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"deleteAddressCallBack:" setFailBackFunctionName:nil];
    [dataProvider deleteAddressByAddressid:addrid];
}
-(void)deleteAddressCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"删除地址成功"];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
    [self.mainTableView.mj_header beginRefreshing];
}

-(void)delAddCallBack:(id)dict
{
    ELog(dict);
    if (RequestSuccess(dict)) {
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [self getAddressList];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    }
}

#pragma mark - action

-(void)clickRightButton:(UIButton *)sender
{
    self.EditMode = !self.EditMode;
    [self.mainTableView reloadData];
    
    if ([_lblRight.text isEqualToString:@"管理"]) {
        [self addRightbuttontitle:@"完成"];
        [self addAddrBtnDismiss];
    }
    else if ([_lblRight.text isEqualToString:@"完成"])
    {
        [self addRightbuttontitle:@"管理"];
        [self addAddrBtnShow];
    }
}

-(void)addBtnClick:(UIButton *)sender
{
    EditAddressViewController *editViewCtl = [[EditAddressViewController alloc] init];
    [self.navigationController pushViewController:editViewCtl animated:YES];
}

#pragma mark - address cell delegate

-(void)addressCell:(AddressTableViewCell *)cell editBtnClick:(UIButton *)sender
{
    EditAddressViewController *editViewCtl = [[EditAddressViewController alloc] init];
    editViewCtl.isEdit = YES;
    editViewCtl.addressModel = self.addressArr[cell.tag];
    [self.navigationController pushViewController:editViewCtl animated:YES];
}

-(void)addressCell:(AddressTableViewCell *)cell DelBtnClick:(UIButton *)sender
{
    [self delAddressByID:self.addressArr[cell.tag].Address_Id];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.addressArr.count;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

#pragma mark - setting for cell

#define ViewsGaptoLine 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = ZY_NSStringFromFormat(@"Cell%ld",(long)indexPath.section);
    
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = ZY_NSStringFromFormat(@"%@    %@",self.addressArr[indexPath.section].Address_name,self.addressArr[indexPath.section].Address_phone);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.detailTextLabel.text = self.addressArr[indexPath.section].Address_addr;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.numberOfLines=2;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30-15, (CellHeight-30)/2, 30, 30)];
    imageView.image = [UIImage imageNamed:@"xuanzhong"];
    [cell.contentView addSubview:imageView];
    
    if (defaultIndex == indexPath.section) {
        imageView.hidden = NO;
    }
    else{
        imageView.hidden = YES;
    }
    
    cell.tag = indexPath.section;
    cell.editMode = self.EditMode;
    cell.delegate = self;
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectAddress" object:self.addressArr[indexPath.section]];
    //选中的时候 xuanzhong
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"setDefaultAddressCallBack:" setFailBackFunctionName:nil];
    [dataProvider setDefaultAddressWithAddressid:self.addressArr[indexPath.section].Address_Id userid:[Toolkit getUserDefaultByKey:user_ID]];
}
-(void)setDefaultAddressCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [SVProgressHUD showSuccessWithStatus:@"默认地址设置成功"];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
    [self.mainTableView.mj_header beginRefreshing];
}


#pragma mark - setting for section
//设置section footer的高度

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
    
}

#pragma mark - 去掉粘连
- (void)scrollViewDidScroll:(UIScrollView *)scrollView//取消tableview的粘连
{
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark - property
-(UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height , SCREEN_WIDTH, SCREEN_HEIGHT -Header_Height - self.addAddrBtn.frame.size.height )];
        _mainTableView.backgroundColor = BACKGROUND_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        [_mainTableView.mj_header beginRefreshing];
    }
    
    return _mainTableView;
}
-(void)refreshData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"refreshCallBack:" setFailBackFunctionName:nil];
    [dataProvider getAddressListWithUserid:[Toolkit getUserDefaultByKey:user_ID]];
}
-(void)refreshCallBack:(id)dict{
    NSLog(@"%@",dict);
    [_mainTableView.mj_header endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        
        [self.addressArr removeAllObjects];
        
        NSArray *arr = dict[@"data"];
        for (NSDictionary *dictionary in arr) {
            AddressModel *model = [[AddressModel alloc] initWithDict:dictionary];
            [_addressArr addObject:model];
        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
    [self defaultIndex];
    [_mainTableView reloadData];
}

-(NSMutableArray<AddressModel *> *)addressArr{

    if (_addressArr == nil) {
        _addressArr = [NSMutableArray array];
    }
    
    return _addressArr;
}

-(UIButton *)addAddrBtn
{
    if (_addAddrBtn == nil) {
        _addAddrBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        [_addAddrBtn setTitle:@"添加收货地址" forState:UIControlStateNormal];
        [_addAddrBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addAddrBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _addAddrBtn.backgroundColor = [UIColor whiteColor];
        [_addAddrBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addAddrBtn;
}

-(void)addAddrBtnShow
{
    [UIView animateWithDuration:0.3 animations:^{
        self.addAddrBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    } completion:^(BOOL finished) {
        self.mainTableView.frame = CGRectMake(0, Header_Height , SCREEN_WIDTH, SCREEN_HEIGHT -Header_Height - self.addAddrBtn.frame.size.height );
    }];
}

-(void)addAddrBtnDismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.addAddrBtn.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 50);
    } completion:^(BOOL finished) {
        self.mainTableView.frame = CGRectMake(0, Header_Height , SCREEN_WIDTH, SCREEN_HEIGHT -Header_Height );
    }];
}

-(void)defaultIndex{
    //找出默认地址的下标 以便tableView加载数据时显示默认地址
    NSLog(@"%d",defaultIndex);
    defaultIndex = -1;
    for (int i = 0 ; i<self.addressArr.count ; i++) {
        if ([self.addressArr[i].IsDefault isEqualToString:@"1"]) {
            defaultIndex = i;
        }
    }
}

@end
