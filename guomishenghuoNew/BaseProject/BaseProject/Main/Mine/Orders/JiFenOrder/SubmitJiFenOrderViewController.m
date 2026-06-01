//
//  SubmitOrderViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "SubmitJiFenOrderViewController.h"
#import "GoodDetailCellTableViewCell.h"
#import "DataProviderOther.h"
#import "AddressManagerViewController.h"
#import "AddressModel.h"
#import "TXTradePasswordView.h"

@interface SubmitJiFenOrderViewController ()<UITableViewDataSource,UITableViewDelegate,TXTradePasswordViewDelegate>
@property(nonatomic) UITableView *mainTableView;

@end

@implementation SubmitJiFenOrderViewController
{
    TXTradePasswordView*TXView;
    NSString *jifenNow;
    NSString * addressid;
    
    AddressModel * address_model_dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    addressid=@"0";
    jifenNow=@"0";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SelectAddress:) name:@"SelectAddress" object:nil];
    
    address_model_dict=[AddressModel AddressModelWithDict:[self.orderDetial[@"AddressList"] firstObject]];
    _lblTitle.text=@"确认订单";
    [self buildTestData];
    [self initViews];
    
}
-(void)SelectAddress:(NSNotification *)notification
{
    address_model_dict=(AddressModel *)notification.object;
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
}
-(void)buildTestData
{
    if (self.goodArr == nil) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        NSArray * pruductArray=[[NSArray alloc] initWithArray:[_orderDetial[@"BillList"] firstObject][@"BillDetailList"]];
        
        for (NSDictionary * productDict in pruductArray) {
            GoodDetailModel *goodDetail = [[GoodDetailModel alloc] init];
            goodDetail.goodID = ZY_NSStringFromFormat(@"%@",productDict[@"ProductId"]);
            goodDetail.goodName = productDict[@"ProductName"];
            goodDetail.goodCount = ZY_NSStringFromFormat(@"%@",productDict[@"ProductNum"]);
            goodDetail.goodPrice = productDict[@"ProductPrice"];
            goodDetail.goodImgUrl = ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,productDict[@"ProductImage"]);
            GoodSpecsModel *specs1 = [[GoodSpecsModel alloc] init];
            specs1.specsName = productDict[@"ProductPriceName"];
            specs1.specsSelected = ZY_NSStringFromFormat(@"%@",productDict[@"ProductPriceId"]);
            
//            GoodSpecsModel *specs2 = [[GoodSpecsModel alloc] init];
//            specs2.specsName = @"";
//            specs2.specsSelected = @"";
            
            goodDetail.goodSpecs = @[specs1];
            
            [tempArr addObject:goodDetail];
        }
        
        
                self.goodArr = tempArr;
    }
}


-(void)initViews
{
    [self.view addSubview:self.mainTableView];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1 + self.goodArr.count;
        case 2:
            return 2;
        case 3:
            return 3;
        case 4:
            return 1;

    }
    return 1;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier = ZY_NSStringFromFormat(@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row);
    
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        
        
        GoodDetailCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodDetailCell"];
        
        GoodDetailModel *goodModel = self.goodArr[indexPath.row - 1];
        cell.goodName.text = goodModel.goodName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *specs = ZY_NSStringFromFormat(@"%@:%@",goodModel.goodSpecs[0].specsName,goodModel.goodSpecs[0].specsSelected);
        
        cell.goodSpecs.text = specs;
        cell.goodPrice.text = ZY_NSStringFromFormat(@"¥%@",goodModel.goodPrice);
        cell.goodCountLib.text =ZY_NSStringFromFormat(@"x%@",goodModel.goodCount);
        cell.canChangeGoodNumber = NO;
        
        [cell.goodImg sd_setImageWithURL:[NSURL URLWithString:goodModel.goodImgUrl] placeholderImage:[UIImage imageNamed:@"tianjiatupian"]];
        return cell;

    }

    if (indexPath.section == 0) {
        
        addressid=address_model_dict.Address_Id;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = ZY_NSStringFromFormat(@"%@   %@",address_model_dict.Address_name,address_model_dict.Address_phone);
        cell.detailTextLabel.text = address_model_dict.Address_addr;
        cell.detailTextLabel.numberOfLines = 2;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"shangjiatubiao"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"果米自营店";
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"运费";
            cell.detailTextLabel.textColor = NAVBAR_COLOR;
            cell.detailTextLabel.text = @"到付";//ZY_NSStringFromFormat(@"到付¥%@",self.orderDetial[@"TransportationFee"]);
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"服务费";
            cell.detailTextLabel.textColor = NAVBAR_COLOR;
            cell.detailTextLabel.text = @"到付";//ZY_NSStringFromFormat(@"到付¥%.2f",[self.orderDetial[@"ServiceFeeRate"] floatValue]*[[self.orderDetial[@"BillList"] firstObject][@"TotalPrice"] floatValue]);
        }
       
    }
    
    if (indexPath.section == 3) {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"当前购物券";
            cell.detailTextLabel.text = jifenNow;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"使用购物券";
            cell.detailTextLabel.text = ZY_NSStringFromFormat(@"使用果米购物券 ¥%.2f",[jifenNow floatValue]<[[self.orderDetial[@"BillList"] firstObject][@"TotalPrice"] floatValue]?[jifenNow floatValue]:[[self.orderDetial[@"BillList"] firstObject][@"TotalPrice"] floatValue]);
        }
        else
        {
            cell.textLabel.text = @"总价";
            cell.detailTextLabel.textColor = NAVBAR_COLOR;
            cell.detailTextLabel.text = ZY_NSStringFromFormat(@"￥%.2f",[[self.orderDetial[@"BillList"] firstObject][@"TotalPrice"] floatValue]);
        }
    }

    if(indexPath.section == 4)
    {
        cell.textLabel.text = ZY_NSStringFromFormat(@"%@",get_sp(@"Phone"));
        cell.detailTextLabel.text = @"绑定的手机号";
    }
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 70;
    }
    if (indexPath.section == 1 && indexPath.row >0) {
        return  GoodDetailHeight;
    }
    
    return  45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section==0) {
        AddressManagerViewController * addressmanagerVC=[[AddressManagerViewController alloc] init];
        [self.navigationController pushViewController:addressmanagerVC animated:YES];
    }
}


#pragma mark - setting for section

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}



//设置section footer的高度

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 1;
    }
    
    return 10;
    
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
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height , SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height )];
        _mainTableView.backgroundColor = BACKGROUND_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _mainTableView.tableFooterView = [self tableFooterView];
        
        [_mainTableView registerNib:[UINib nibWithNibName:@"GoodDetailCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodDetailCell"];
    }
    
    
    return _mainTableView;
}

-(UIView *)tableFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footerView.backgroundColor = BACKGROUND_COLOR;
    
    RoundButton *submitBtn = [[RoundButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 40)];
    submitBtn.center = CGPointMake(SCREEN_WIDTH/2, footerView.frame.size.height/2);
    submitBtn.myTintColor = NAVBAR_COLOR;
    [submitBtn addTarget:self action:@selector(SaveBill) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [footerView addSubview:submitBtn];
    
    
    return footerView;
}
-(void)SaveBill
{
    if ([jifenNow floatValue]<[[self.orderDetial[@"BillList"] firstObject][@"TotalPrice"] floatValue]) {
        [YJXStatusHUD showError:@"积分不足,请消费或充值后再来"];
        return;
    }
    
    [YJXStatusHUD showLoading:@"正在获取支付信息..."];
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"SaveBillCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther SaveBillWithbillid:ZY_NSStringFromFormat(@"%@",[self.orderDetial[@"BillList"] firstObject][@"Id"]) andaddressid:addressid andtype:@"1" andbuyermessage:@"" andtotalprice:ZY_NSStringFromFormat(@"%.2f",[[self.orderDetial[@"BillList"] firstObject][@"TotalPrice"] floatValue])];
    
//    TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, 100,SCREEN_WIDTH, 200) WithTitle:@"请输入支付密码"];
//    TXView.backgroundColor=[UIColor whiteColor];
//    TXView.TXTradePasswordDelegate = self;
//    if (![TXView.TF becomeFirstResponder])
//    {
//        //成为第一响应者。弹出键盘
//        [TXView.TF becomeFirstResponder];
//    }
//    [self.view addSubview:TXView];
}

#pragma mark  密码输入结束后调用此方法
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password
{
    NSLog(@"密码 = %@",Password);
    if ([view isEqual:TXView]) {
        [TXView removeFromSuperview];
        DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
        [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"VerifyPWDCallBack:" setFailBackFunctionName:nil];
        [mainrequest CheckPayPasswordWithpaypassword:Password];
        [YJXStatusHUD showLoading:@"正在验证支付密码..."];
    }
}
-(void)VerifyPWDCallBack:(id)dict
{
    [YJXStatusHUD hideLoading];
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showLoading:@"正在获取支付信息..."];
        DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
        [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"SaveBillCallBack:" setFailBackFunctionName:nil];
        [dataproviderOther SaveBillWithbillid:ZY_NSStringFromFormat(@"%@",[self.orderDetial[@"BillList"] firstObject][@"Id"]) andaddressid:addressid andtype:@"1" andbuyermessage:@"" andtotalprice:ZY_NSStringFromFormat(@"%.2f",[[self.orderDetial[@"BillList"] firstObject][@"TotalPrice"] floatValue])];
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}
-(void)SaveBillCallBack:(id)dict
{
    [YJXStatusHUD hideLoading];
    if (RequestSuccess(dict)) {
        [SVProgressHUD showSuccessWithStatus:@"订单提交成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
}
-(void)GetMyJifen
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetMyJifenCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:@"0" andmaximumRows:@"1" andtype:@"8"];
}

-(void)GetMyJifenCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        jifenNow=[NSString stringWithFormat:@"%.2f",[dict[@"data"][@"TotalPoint"] floatValue]];
        [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self GetMyJifen];
}

@end
