//
//  SubmitTuanGouOrderViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/8.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "SubmitTuanGouOrderViewController.h"
#import "GoodDetailCellTableViewCell.h"
#import "DataProviderOther.h"
#import "JSONKit.h"
#import "Pingpp.h"
#import "TXTradePasswordView.h"

@interface SubmitTuanGouOrderViewController ()<UITableViewDataSource,UITableViewDelegate,TXTradePasswordViewDelegate>
@property(nonatomic) UITableView *mainTableView;
@property(nonatomic) NSMutableArray *selectPayBtnArr;
@end

@implementation SubmitTuanGouOrderViewController
{
    TXTradePasswordView*TXView;
    NSArray * ShopList;
    float lastPrice;
    NSString * mymoney;
    NSMutableArray * billIdArray;
    NSString * channel;
    
    RoundButton *submitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"确认订单";
    channel=@"";
    billIdArray=[[NSMutableArray alloc] init];
    ShopList=[[NSArray alloc] initWithArray:self.orderDetial[@"BillList"]];
    lastPrice=0.00;
    for (NSDictionary * itemdict in ShopList) {
        lastPrice+=[itemdict[@"TotalPrice"] floatValue];
        [billIdArray addObject:ZY_NSStringFromFormat(@"%@",itemdict[@"Id"])];
    }
    mymoney=@"0.00";
    [self buildTestData];
    [self initViews];
    
    [self selectBtnClick:self.selectPayBtnArr[1]];
}

-(void)buildTestData
{
    if (self.goodArr == nil) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        for (int j = 0; j<3; j++) {
            GoodDetailModel *goodDetail = [[GoodDetailModel alloc] init];
            goodDetail.goodID = ZY_NSStringFromFormat(@"%d",j);
            goodDetail.goodName = @"一岁宝宝拖车";
            goodDetail.goodCount = ZY_NSStringFromFormat(@"%d",j);
            goodDetail.goodPrice = @"50.00";
            goodDetail.goodImgUrl = @"http://n.sinaimg.cn/comic/crawl/20160811/ENHF-fxutsmv0315920.png";
            GoodSpecsModel *specs1 = [[GoodSpecsModel alloc] init];
            specs1.specsName = @"颜色";
            specs1.specsSelected = @"蓝色";
            
            GoodSpecsModel *specs2 = [[GoodSpecsModel alloc] init];
            specs2.specsName = @"型号";
            specs2.specsSelected = @"大号";
            
            goodDetail.goodSpecs = @[specs1,specs2];
            
            [tempArr addObject:goodDetail];
        }
        self.goodArr = tempArr;
    }
}


-(void)initViews
{
    for (int i = 0; i<3; i++) {
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 -20, 12.5, 20, 20)];
        selectBtn.tag = i;
        [selectBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectPayBtnArr addObject:selectBtn];
    }
    
    [self.view addSubview:self.mainTableView];
}

#pragma mark - action

-(void)selectBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    
    for (UIButton *btn in self.selectPayBtnArr) {
        if (btn != sender) {
            btn.selected = NO;
        }
    }
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([mymoney floatValue]<lastPrice) {
        return ShopList.count+3;
    }
    else
    {
        return ShopList.count+2;
    }

}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section<ShopList.count) {
        NSArray * itemarray=[[NSArray alloc] initWithArray:ShopList[section][@"BillDetailList"]];
        return itemarray.count+1;
    }
    if (section==ShopList.count) {
        if (_fandian!=100.00) {
            return 1;
        }
        return 3;
    }
    if (section==(ShopList.count+1)) {
        return 1;
    }
    if (section==(ShopList.count+2)) {
//         if (_fandian==100.00) {
             return 3;
//         }
//        return 2;
    }
    return 0;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier = ZY_NSStringFromFormat(@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row);
    
    
    if (indexPath.section <ShopList.count && indexPath.row > 0) {
        NSDictionary * goodModel=[[NSDictionary alloc] initWithDictionary:ShopList[indexPath.section][@"BillDetailList"][indexPath.row-1]];
        
        GoodDetailCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodDetailCell"];
        
        cell.goodName.text = [Toolkit judgeIsNull:goodModel[@"ProductName"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *specs = ZY_NSStringFromFormat(@"%@",[Toolkit judgeIsNull:goodModel[@"ProductPriceName"]]);
        
        cell.goodSpecs.text = specs;
        cell.goodPrice.text = ZY_NSStringFromFormat(@"¥%.2f",[[Toolkit judgeIsNull:goodModel[@"DetailPrice"]] floatValue]);
        cell.goodCountLib.text =ZY_NSStringFromFormat(@"x%@",[Toolkit judgeIsNull:goodModel[@"ProductNum"]]);
        cell.canChangeGoodNumber = NO;
        
        [cell.goodImg sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,[Toolkit judgeIsNull:goodModel[@"ProductImage"]])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
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
    
    if (indexPath.section <ShopList.count && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"shangjiatubiao"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [Toolkit judgeIsNull:ShopList[indexPath.section][@"ShopName"]];
    }
    
    
    if (indexPath.section == ShopList.count) {
         if (_fandian==100.00) {
             if(indexPath.row == 0)
             {
                 cell.textLabel.text = @"我的钱包";
                 cell.detailTextLabel.text = ZY_NSStringFromFormat(@"¥%@",mymoney);
             }
             else if (indexPath.row == 1) {
                 cell.textLabel.text = @"使用余额";
                 cell.detailTextLabel.text = [NSString stringWithFormat:@"使用钱包 ¥%@",[mymoney floatValue]<lastPrice?mymoney:ZY_NSStringFromFormat(@"%.2f",lastPrice)];
             }
             else
             {
                 cell.textLabel.text = @"总价";
                 cell.detailTextLabel.textColor = NAVBAR_COLOR;
                 
                 //            lastPrice+=[self.orderDetial[@"TransportationFee"] floatValue];
                 cell.detailTextLabel.text = ZY_NSStringFromFormat(@"¥%.2f",lastPrice);
             }
         }
        else
        {
            cell.textLabel.text = @"总价";
            cell.detailTextLabel.textColor = NAVBAR_COLOR;
            
            //            lastPrice+=[self.orderDetial[@"TransportationFee"] floatValue];
            cell.detailTextLabel.text = ZY_NSStringFromFormat(@"¥%.2f",lastPrice);
        }
        
    }
    
    if(indexPath.section == (ShopList.count+1))
    {
        cell.textLabel.text = ZY_NSStringFromFormat(@"%@",get_sp(@"Phone"));
        cell.detailTextLabel.text = @"绑定的手机号";
    }
    
    if(indexPath.section == (ShopList.count+2))
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.selectPayBtnArr[indexPath.row]];
        switch (indexPath.row) {
            case 0:
            {
                cell.imageView.image = [UIImage imageNamed:@"weixinzhifu"];
                cell.textLabel.text = @"微信支付";
                cell.detailTextLabel.text = @"推荐微信5.0以上版本使用";
                
            }
                break;
            case 1:
            {
                cell.imageView.image = [UIImage imageNamed:@"zhifubaozhifu"];
                cell.textLabel.text = @"支付宝支付";
                cell.detailTextLabel.text = @"推荐有支付宝账号的使用";
            }
                break;
            case 2:
            {
                cell.imageView.image = [UIImage imageNamed:@"yinlianzhifu"];
                cell.textLabel.text = @"银联支付";
                cell.detailTextLabel.text = @"";
            }
                break;
            default:
                break;
        }
        
        
        return cell;
    }
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.section <ShopList.count && indexPath.row >0) {
        return  GoodDetailHeight;
    }
    
    return  45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section==(ShopList.count+2)) {
        [self selectBtnClick:self.selectPayBtnArr[indexPath.row]];
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
    
    submitBtn = [[RoundButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 40)];
    submitBtn.center = CGPointMake(SCREEN_WIDTH/2, footerView.frame.size.height/2);
    submitBtn.myTintColor = NAVBAR_COLOR;
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(SaveBill) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    
    
    return footerView;
}

-(NSMutableArray *)selectPayBtnArr
{
    if (_selectPayBtnArr == nil) {
        _selectPayBtnArr = [NSMutableArray array];
    }
    
    return _selectPayBtnArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)GetDetialList
{
    if (_fandian==100.00) {
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetDetitlListCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:@"0" andmaximumRows:@"1" andtype:@"9"];
    }
}

-(void)GetDetitlListCallBack:(id)dict
{
    ELog(dict);
    
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    
    if (RequestSuccess(dict)) {
        mymoney=[NSString stringWithFormat:@"%.2f",[dict[@"data"][@"TotalMoney"] floatValue]];
//        [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:ShopList.count],[NSIndexPath indexPathForRow:1 inSection:ShopList.count]] withRowAnimation:UITableViewRowAnimationNone];
        [self.mainTableView reloadData];
    }
    //    else
    //    {
    //        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    //    }
}

-(void)SaveBill
{
    
    
    for (int i=0; i<self.selectPayBtnArr.count; i++) {
        UIButton *btn=(UIButton *)self.selectPayBtnArr[i];
        if (btn.selected) {
            switch (i) {
                case 0:
                    channel=@"wx";
                    break;
                case 1:
                    channel=@"alipay";
                    break;
                case 2:
                    channel=@"upacp";
                    break;
                default:
                    [YJXStatusHUD showError:@"请选择支付方式"];
                    return;
                    break;
            }
        }
    }
//    if ([channel isEqualToString:@"wx"]) {
//        [YJXStatusHUD showError:@"微信支付尚未开通"];
//        return;
//    }
    
    submitBtn.enabled=NO;
    
    if(_fandian==100.00&&[mymoney floatValue]>=0.01)
    {
        TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, 100,SCREEN_WIDTH, 200) WithTitle:@"请输入支付密码"];
        TXView.backgroundColor=[UIColor whiteColor];
        TXView.TXTradePasswordDelegate = self;
        if (![TXView.TF becomeFirstResponder])
        {
            //成为第一响应者。弹出键盘
            [TXView.TF becomeFirstResponder];
        }
        [self.view addSubview:TXView];
    }
    else
    {
        if (_fandian!=100.00) {
            DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
            [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"SaveBillCallBack:" setFailBackFunctionName:nil];
            [dataproviderOther TuanGouSaveBillWithlist_billid:[Toolkit NSArrayToJsonString:billIdArray] andqianbao:@"0.00" andchannel:channel andbuyermessage:@"" andtotalprice:ZY_NSStringFromFormat(@"%.2f",lastPrice)];
        }
        else
        {
            DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
            [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"SaveBillCallBack:" setFailBackFunctionName:nil];
            [dataproviderOther TuanGouSaveBillWithlist_billid:[Toolkit NSArrayToJsonString:billIdArray] andqianbao:[mymoney floatValue]<lastPrice?ZY_NSStringFromFormat(@"%.2f",[mymoney floatValue]):ZY_NSStringFromFormat(@"%.2f",lastPrice) andchannel:channel andbuyermessage:@"" andtotalprice:ZY_NSStringFromFormat(@"%.2f",lastPrice)];
        }
        
    }
    
    
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
//        [YJXStatusHUD showLoading:@"正在验证支付密码..."];
        [SVProgressHUD showWithStatus:@"正在验证支付密码..."];
    }
    
}
-(void)VerifyPWDCallBack:(id)dict
{
    submitBtn.enabled=YES;
    [SVProgressHUD dismiss];
//    [YJXStatusHUD hideLoading];
    if (RequestSuccess(dict)) {
        if ([dict[@"data"][@"Result"] intValue]==0) {
            [YJXStatusHUD showError:@"支付密码验证失败,支付取消"];
            return;
        }
        [YJXStatusHUD showLoading:@"正在获取支付信息..."];
//        DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
//        [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"SaveBillCallBack:" setFailBackFunctionName:nil];
//        [dataproviderOther TuanGouSaveBillWithlist_billid:[Toolkit NSArrayToJsonString:billIdArray] andqianbao:[mymoney floatValue]<lastPrice?ZY_NSStringFromFormat(@"%.2f",[mymoney floatValue]):ZY_NSStringFromFormat(@"%.2f",lastPrice) andchannel:channel andbuyermessage:@"" andtotalprice:ZY_NSStringFromFormat(@"%.2f",lastPrice)];
        if (_fandian!=100.00) {
            DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
            [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"SaveBillCallBack:" setFailBackFunctionName:nil];
            [dataproviderOther TuanGouSaveBillWithlist_billid:[Toolkit NSArrayToJsonString:billIdArray] andqianbao:@"0.00" andchannel:channel andbuyermessage:@"" andtotalprice:ZY_NSStringFromFormat(@"%.2f",lastPrice)];
        }
        else
        {
            DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
            [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"SaveBillCallBack:" setFailBackFunctionName:nil];
            [dataproviderOther TuanGouSaveBillWithlist_billid:[Toolkit NSArrayToJsonString:billIdArray] andqianbao:[mymoney floatValue]<lastPrice?ZY_NSStringFromFormat(@"%.2f",[mymoney floatValue]):ZY_NSStringFromFormat(@"%.2f",lastPrice) andchannel:channel andbuyermessage:@"" andtotalprice:ZY_NSStringFromFormat(@"%.2f",lastPrice)];
        }
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}
-(void)SaveBillCallBack:(id)dict
{
    submitBtn.enabled=YES;
    [YJXStatusHUD hideLoading];
    if (RequestSuccess(dict)) {
        
        if (!dict[@"error"]) {
            if ([[NSString stringWithFormat:@"%@",dict[@"data"]] length]>5) {
                [Pingpp createPayment:dict[@"data"]
                       viewController:self
                         appURLScheme:kUrlScheme
                       withCompletion:^(NSString *result, PingppError *error) {
                           if ([result isEqualToString:@"success"]) {
                               // 支付成功
                               [SVProgressHUD showSuccessWithStatus:@"订单提交成功"];
                               [self.navigationController popToRootViewControllerAnimated:YES];
                           } else {
                               // 支付失败或取消
                               NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                           }
                       }];
            }
            else
            {
                [YJXStatusHUD showSuccess:@"已使用钱包支付"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        else
        {
            [YJXStatusHUD showError:@"订单支付失败"];
        }
        
        
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self GetDetialList];
}
@end
