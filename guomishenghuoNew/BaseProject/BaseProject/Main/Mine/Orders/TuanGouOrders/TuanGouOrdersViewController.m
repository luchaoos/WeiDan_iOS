//
//  TuanGouOrdersViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "TuanGouOrdersViewController.h"
#import "OrderView.h"
#import "MJRefresh.h"
#import "DataProviderOther.h"
#import "Pingpp.h"
#import "RatingsViewController.h"
#import "JCMineTableViewCell.h"
#import "JSONKit.h"
#import "Index_ShopInfoViewController.h"

#define JCMineTableViewCellName @"cell_mine"

@interface TuanGouOrdersViewController ()<UITableViewDataSource,UITableViewDelegate,OrderViewDelegate,UIActionSheetDelegate>
{
    // view
    UIView *_layerView;
    int index;
    
    // data
    NSMutableArray *orderArray;
    
    //订单请求变量
    NSInteger pageNo;
    NSInteger pageSize;
    OrderTuanGouState _orderState;
    BOOL _isTuiKuan;
    BOOL _isDaoDian;
    
    OrderDetailModel * orderSelectModel;
    
    NSString * cancelMessage;
}

@property(nonatomic) NSMutableArray <UIButton *>*orderStateBtnArr;
@property(nonatomic) UITableView *mainTableView;
@property(nonatomic) NSMutableArray <OrderDetailModel *>* orderArr;

@end

@implementation TuanGouOrdersViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate hiddenTabBar];
}

-(void)initViews
{
    self.navtitle = @"到店支付";
    cancelMessage=@"";
    pageNo = 0;
    pageSize = 5;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height +1, SCREEN_WIDTH, 35)];
    backView.backgroundColor = [UIColor whiteColor];
    
    NSArray *btnNameArr = @[@"待使用",@"待付款",@"待评价",@"退款",@"到店支付"];
    
    CGFloat btnGap = 8;
    CGFloat btnWidth = (SCREEN_WIDTH - (btnNameArr.count+1)*btnGap)/btnNameArr.count;
    _layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth, 1)];
    _layerView.backgroundColor = NAVBAR_COLOR;
    
    [backView addSubview:_layerView];
    
    for (int i = 0; i < btnNameArr.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake((i+1)*btnGap + btnWidth * i, 0, btnWidth, 35);
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        
        [btn setTitle:btnNameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:NAVBAR_COLOR forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
        
        [self.orderStateBtnArr addObject:btn];
    }
    
    [self stateBtnClick:self.orderStateBtnArr[4]];
    
//    [self.view addSubview:backView];
    [self.view addSubview:self.mainTableView];
    
    
    //测试btn
    
//    UIButton *submitOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
//    submitOrderBtn.backgroundColor =[UIColor redColor];
//    [submitOrderBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:submitOrderBtn];
}

-(void)buildTestDataWithType:(OrderState)orderState
{
    if (orderState > OrderStateCancel) {
        return;
    }
    
    [self.orderArr removeAllObjects];
    
    for (int i = 0; i < 5 ; i++) {
        OrderDetailModel *model = [[OrderDetailModel alloc] init];
        model.orderTime = ZY_NSStringFromFormat(@"2016-08-11 10:%02d",i);
        model.orderState = ZY_NSStringFromFormat(@"%ld",(long)orderState);
        model.orderId = ZY_NSStringFromFormat(@"%d",i);
        model.orderPrice = @"100";
        model.orderOwerShop = @"花随香店铺";
        model.orderNumber = @"1234567890";
        
        AddressModel *address =  [[AddressModel alloc] init];
        address.Address_phone = @"18810375184";
        address.Address_name = @"奇衡三";
        address.Address_addr = @"山东省临沂市兰山区沂蒙路与解放路交汇新华书店15楼1506室";
        
        model.orderCustomAddress = address;
        model.orderType = ZY_NSStringFromFormat(@"%ld",(long)OrderTypeTuanGou);
        
        if (orderState == 3) {
            model.orderTuiKuanState = ZY_NSStringFromFormat(@"%ld",(long)OrderTuanGouTuiKunStateApplyTuiKuan);
        }
        
        for (int j = 0; j<i+1; j++) {
            GoodDetailModel *goodDetail = [[GoodDetailModel alloc] init];
            goodDetail.goodID = ZY_NSStringFromFormat(@"%d",j);
            goodDetail.goodName = @"一岁宝宝拖车";
            goodDetail.goodCount = ZY_NSStringFromFormat(@"%d",j);
            goodDetail.goodPrice = @"50.00";
            goodDetail.goodImgUrl = @"http://n.sinaimg.cn/comic/crawl/20160811/ENHF-fxutsmv0315920.png";
            goodDetail.goodQuanMa = @"23874689324809324";
            GoodSpecsModel *specs1 = [[GoodSpecsModel alloc] init];
            specs1.specsName = @"颜色";
            specs1.specsSelected = @"蓝色";
            
            GoodSpecsModel *specs2 = [[GoodSpecsModel alloc] init];
            specs2.specsName = @"型号";
            specs2.specsSelected = @"大号";
            
            goodDetail.goodSpecs = @[specs1,specs2];
            
            [model.orderGoods addObject:goodDetail];
        }
        
        [self.orderArr addObject:model];
        
    }
    
    [self.mainTableView reloadData];
    
}


#pragma mark - self  data source

-(void)getOrderListWithState:(NSString *)state andTuiKuanState:(NSString *)tuikuan andIsDaoDian:(NSString *)daoDian
{
    DataProviderOther *provider = [[DataProviderOther alloc] init];
    [provider setDelegateObject:self setSucceedBackFunctionName:@"getOrderListCallBack:" setFailBackFunctionName:nil];
    [provider GetUserOrderListWithjifenstate:@"0"
                             andtuangoustate:state
                             andtuikuanstate:tuikuan
                                  andisjifen:@"0"
                                andisdaodian:daoDian
                            andstartRowIndex:ZY_NSStringFromFormat(@"%ld",pageSize*pageNo)
                              andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize)];
}

-(void)getOrderListCallBack:(id)dict
{
    ELog(dict);
    
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];

    if (RequestSuccess(dict)) {
        @try {
            
            if (pageNo == 0) {
                [self.orderArr removeAllObjects];
            }
            
            NSArray *tempOrderArr =dict[@"data"];
            
            [tempOrderArr enumerateObjectsUsingBlock:^(NSDictionary *tempDict, NSUInteger idx, BOOL * _Nonnull stop) {
                
                OrderDetailModel *model = [OrderDetailModel OrderDetailWithDict:tempDict];
                [self.orderArr addObject:model];
                
            }];
            
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
            
        }
        
        
        if (self.orderArr.count <= DataTotal(dict)) {
            [self.mainTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        
        [self.mainTableView reloadData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    }
    
}

#pragma mark - actions

-(void)submitBtnClick
{
    SubmitTuanGouOrderViewController *submitViewCtl = [[SubmitTuanGouOrderViewController alloc] init];
    [self.navigationController pushViewController:submitViewCtl animated:YES];
}

-(void)stateBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    
    for (UIButton *btn  in self.orderStateBtnArr) {
        if (btn != sender) {
            btn.selected = NO;
        }
    }
    [self setBtnLayerWithBtn:sender];
//    [self buildTestDataWithType:sender.tag];
    
    //更新状态
    if (sender.tag <= OrderTuanGouStateUnComment) {
        if (sender.tag==0) {
            _orderState=1;
        }
        else if (sender.tag==1) {
            _orderState=0;
        }
        else
        {
            _orderState = sender.tag;
        }
        
        _isDaoDian = NO;
        _isTuiKuan = NO;
    }
    else if (sender.tag == 3)
    {
        _isDaoDian = NO;
        _isTuiKuan = YES;
    }
    else if(sender.tag == 4)
    {
        _isDaoDian = YES;
        _isTuiKuan = NO;
    }
        
    
    [self.mainTableView.mj_header beginRefreshing];
    
    
}


-(void)setBtnLayerWithBtn:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        _layerView.center = CGPointMake(btn.center.x, 35-0.5);
    }];
}
#pragma mark - orderView delegate

-(void)OrderView:(OrderView *)orderView clickTableViewIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 )
    {
        Index_ShopInfoViewController * index_shopInfoVC=[[Index_ShopInfoViewController alloc] init];
        OrderDetailModel *orderModel = self.orderArr[indexPath.section];
        index_shopInfoVC.shopID=orderModel.orderShopId;
        [self.navigationController pushViewController:index_shopInfoVC animated:YES];
    }
    if (indexPath.row > 0 && indexPath.row < orderView.orderDetail.orderGoods.count + 1) {
        TuanGouOrderDetailViewController *tuanGouOrderDetailViewCtl = [[TuanGouOrderDetailViewController alloc] init];
        tuanGouOrderDetailViewCtl.orderDetail = orderView.orderDetail;
        [self.navigationController pushViewController:tuanGouOrderDetailViewCtl animated:YES];
    }
}
-(void)OrderView:(OrderView *)orderView LeftBtnClick:(UIButton *)sender
{
    orderSelectModel=orderView.orderDetail;
    NSInteger index = [orderView.orderDetail.orderState integerValue];
    switch (index) {
        case OrderTuanGouStateUnPay:
        {
            UIActionSheet * ac_alert=[[UIActionSheet alloc] initWithTitle:@"取消原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"商家停业/转让/装修",@"买多了/买错了",@"后悔/不想要了",@"联系不上商家", nil];
            ac_alert.tag=2;
            [ac_alert showInView:self.view];
//            [self CancelOrder:orderView.orderDetail.orderId];
        }
            break;
        case OrderTuanGouStateUnUse:
        {
            
        }
            break;
        case OrderTuanGouStateUnComment:
        {
            
        }
            break;
        default:
            if ([orderView.orderDetail.orderTuiKuanState integerValue]==1) {
                
            }
            break;
    }
    
    
    UIButton *tempBtn = self.orderStateBtnArr[index];
//    [self stateBtnClick:tempBtn];
}
-(void)OrderView:(OrderView *)orderView RightBtnClick:(UIButton *)sender
{
    orderSelectModel=orderView.orderDetail;
    NSInteger index = [orderView.orderDetail.orderState integerValue];
    if ([orderView.orderDetail.orderTuiKuanState integerValue] == OrderTuanGouTuiKunStateNormal ||
        [orderView.orderDetail.orderTuiKuanState integerValue] == OrderTuanGouTuiKunStateTuiKuanRejected) {
        switch (index) {
                
            case OrderTuanGouStateUnPay:
            {
                UIActionSheet * ac_alert=[[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信",@"银联", nil];
                ac_alert.tag=1;
                [ac_alert showInView:self.view];
            }
                break;
            case OrderTuanGouStateUnUse:
            {
                TuanGouOrderDetailViewController *tuanGouOrderDetailViewCtl = [[TuanGouOrderDetailViewController alloc] init];
                tuanGouOrderDetailViewCtl.orderDetail = orderView.orderDetail;
                [self.navigationController pushViewController:tuanGouOrderDetailViewCtl animated:YES];
            }
                break;
            case OrderTuanGouStateUnComment:
            {
                RatingsViewController * ratingsVC=[[RatingsViewController alloc] init];
                ratingsVC.orderDetail=orderView.orderDetail;
                [self.navigationController pushViewController:ratingsVC animated:YES];
            }
                break;
            default:
                if ([orderView.orderDetail.orderTuiKuanState integerValue]==1) {
                    //                [self CancelOrder:orderView.orderDetail.orderId];
                    UIActionSheet * ac_alert=[[UIActionSheet alloc] initWithTitle:@"取消原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"商家停业/转让/装修",@"买多了/买错了",@"后悔/不想要了",@"联系不上商家", nil];
                    ac_alert.tag=2;
                    [ac_alert showInView:self.view];
                }
                break;
                
        }
    }
    
    
    UIButton *tempBtn = self.orderStateBtnArr[index];
//    [self stateBtnClick:tempBtn];
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1) {
//        if (buttonIndex==1) {
//            [YJXStatusHUD showError:@"暂未开通微信支付"];
//            return;
//        }
        NSString * payWay=@"";
        if (buttonIndex==0) {
            payWay=@"alipay";
        }
        if (buttonIndex==1) {
            payWay=@"wx";
        }
        if (buttonIndex==2) {
            payWay=@"upacp";
        }
        DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
        [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"GetChargeCallBack:" setFailBackFunctionName:nil];
        //    [mainrequest ChongZhiGetChargeWithchannel:payWay andamount:[NSString stringWithFormat:@"%d",[orderSelectModel.orderPrice intValue]]];
        NSArray * itemarray=[[NSArray alloc] initWithObjects:orderSelectModel.orderId, nil];
        [mainrequest TuanGouSaveBillWithlist_billid:[Toolkit NSArrayToJsonString:itemarray] andqianbao:@"0" andchannel:payWay andbuyermessage:@"" andtotalprice:ZY_NSStringFromFormat(@"%.0f",[orderSelectModel.orderPrice floatValue])];
    }
    else
    {
        switch (buttonIndex) {
            case 0:
                cancelMessage=@"商家停业/转让/装修";
                [self CancelOrder:orderSelectModel.orderId];
                break;
            case 1:
                cancelMessage=@"买多了/买错了";
                [self CancelOrder:orderSelectModel.orderId];
                break;
            case 2:
                cancelMessage=@"后悔/不想要了";
                [self CancelOrder:orderSelectModel.orderId];
                break;
            case 3:
                cancelMessage=@"联系不上商家";
                [self CancelOrder:orderSelectModel.orderId];
                break;
            default:
                break;
        }
    }
    
}


-(void)GetChargeCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        DLog(@"%@",dict);
        
        [Pingpp createPayment:dict[@"data"]
               viewController:self
                 appURLScheme:kUrlScheme
               withCompletion:^(NSString *result, PingppError *error) {
                   if ([result isEqualToString:@"success"]) {
                       // 支付成功
                       [YJXStatusHUD showSuccess:@"支付成功"];
                       [self.navigationController popToRootViewControllerAnimated:YES];
                       
                   } else {
                       // 支付失败或取消
                       NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                       [YJXStatusHUD showError:@"支付失败"];
                   }
               }];
    }
    else
    {
        [YJXStatusHUD showError:@"请求失败"];
    }
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderArr.count;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isDaoDian) {
        return 2;
    }
    return 1;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isDaoDian) {
        if (indexPath.row==0) {
            JCMineTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:JCMineTableViewCellName forIndexPath:indexPath];
            cell.name.text = self.orderArr[indexPath.section].orderOwerShop;
            cell.image.image = [UIImage imageNamed:@"wodedingdan"];
            cell.arrows_switch.hidden = YES;
            cell.arrows.hidden=YES;
            return cell;
        }
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        DLog(@"%@",_orderArr);
        UILabel * lbl_left=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, (SCREEN_WIDTH-30)/2-30, 60)];
        lbl_left.text=[NSString stringWithFormat:@"到店支付\n金额￥%.2f",[self.orderArr[indexPath.section].orderPrice floatValue]];
        lbl_left.numberOfLines=2;
        lbl_left.font=[UIFont systemFontOfSize:13];
        [cell.contentView addSubview:lbl_left];
        
        UILabel * lbl_right=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl_left.frame), 0, (SCREEN_WIDTH-30)/2+30, 60)];
        
        lbl_right.font=[UIFont systemFontOfSize:16];
        lbl_right.text=[NSString stringWithFormat:@"%@\n%@",_orderArr[indexPath.section].orderPayTime,ZY_NSStringFromFormat(@"订单号:%@",_orderArr[indexPath.section].orderNumber)];
        lbl_right.textAlignment=NSTextAlignmentRight;
        lbl_right.font=[UIFont systemFontOfSize:13];
        lbl_right.numberOfLines=2;
        [cell.contentView addSubview:lbl_right];
        
        
        
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderDetailModel *orderModel = self.orderArr[indexPath.section];
    
    OrderView *orderView = [cell.contentView viewWithTag:123];
    if (orderView != nil) {
        [orderView removeFromSuperview];
        orderView = nil;
    }
    orderView = [OrderView OrderViewWithOrderDetail:orderModel];
    orderView.tag = 123;
    
    orderView.delegate = self;
    orderView.tag = indexPath.section;
    [cell.contentView addSubview:orderView];
    
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isDaoDian) {
        if (indexPath.row==0) {
            return 40;
        }
        return 60;
    }
    OrderDetailModel *orderModel = self.orderArr[indexPath.section];
    return  [OrderView CalculateViewHeightWithOrderDetail:orderModel];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    DLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
}


#pragma mark - setting for section

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isDaoDian) {
        return 10;
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isTuiKuan) {
        return YES;
    }
    if(_isDaoDian)
    {
        if (indexPath.row==1) {
            return YES;
        }
        return NO;
    }
    if (_orderState!=1) {
        return YES;
    }
    return NO;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.orderArr removeObjectAtIndex:indexPath.section];
//        // Delete the row from the data source.
//        [self.mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        DataProviderOther * dataprovider=[[DataProviderOther alloc] init];
        [dataprovider setDelegateObject:self setSucceedBackFunctionName:@"DELWithBillIDCallBack:" setFailBackFunctionName:nil];
//        if (_isDaoDian) {
             [dataprovider DELWithBillID:self.orderArr[indexPath.section].orderId];
//        }
//        else
//        {
//             [dataprovider DELWithBillID:orderSelectModel.orderId];
//        }
       
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


-(void)DELWithBillIDCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"订单删除成功"];
        [self.mainTableView.mj_header beginRefreshing];
    }
    else
    {
        [YJXStatusHUD showError:@"订单删除失败"];
    }
}


#pragma mark - property

-(UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 10 )];
        _mainTableView.backgroundColor = BACKGROUND_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        
        //注册
        [_mainTableView registerClass:[JCMineTableViewCell class] forCellReuseIdentifier:JCMineTableViewCellName];
        __unsafe_unretained __typeof(self) weakSelf = self;
        
        _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [_mainTableView.mj_footer setState:MJRefreshStateIdle];
            pageNo = 0;
            [weakSelf getOrderListWithState:ZY_NSStringFromFormat(@"%ld",_orderState)
                            andTuiKuanState:ZY_NSStringFromFormat(@"%d",_isTuiKuan)
                               andIsDaoDian:ZY_NSStringFromFormat(@"%d",_isDaoDian)];
            
        }];
        [_mainTableView.mj_header beginRefreshing];
        
        // 上拉刷新
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            pageNo++;
            [weakSelf getOrderListWithState:ZY_NSStringFromFormat(@"%ld",(long)_orderState)
                            andTuiKuanState:ZY_NSStringFromFormat(@"%d",_isTuiKuan)
                               andIsDaoDian:ZY_NSStringFromFormat(@"%d",_isDaoDian)];
        }];

     
    }
    
    
    return _mainTableView;
}


-(NSMutableArray<OrderDetailModel *> *)orderArr
{
    if (_orderArr == nil) {
        _orderArr = [NSMutableArray array];
    }
    
    return _orderArr;
}

-(NSMutableArray<UIButton *> *)orderStateBtnArr
{
    if (_orderStateBtnArr == nil) {
        _orderStateBtnArr = [NSMutableArray array];
    }
    
    return _orderStateBtnArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CancelOrder:(NSString *)billID
{
    DataProviderOther *provider = [[DataProviderOther alloc] init];
    [provider setDelegateObject:self setSucceedBackFunctionName:@"CancelBillWithbillidCallBack:" setFailBackFunctionName:nil];
    [provider CancelBillWithbillid:billID andreason:cancelMessage];

}
-(void)CancelBillWithbillidCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"订单取消成功"];
        [self.mainTableView.mj_header beginRefreshing];
    }
    else
    {
        [YJXStatusHUD showError:@"未能取消订单"];
    }
}
-(void)DelOrder:(NSString *)billID
{
    DataProviderOther *provider = [[DataProviderOther alloc] init];
    [provider setDelegateObject:self setSucceedBackFunctionName:@"DelBillWithbillidCallBack:" setFailBackFunctionName:nil];
    [provider DeleteBillWithbillid:billID];
    
}
-(void)DelBillWithbillidCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"订单删除成功"];
        [self.mainTableView.mj_header beginRefreshing];
    }
}
-(void)ReceiveOrder:(NSString *)billID
{
    DataProviderOther *provider = [[DataProviderOther alloc] init];
    [provider setDelegateObject:self setSucceedBackFunctionName:@"ReceiveBillWithbillidCallBack:" setFailBackFunctionName:nil];
    [provider ReceiveBillWithbillid:billID];
    
}
-(void)ReceiveBillWithbillidCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"订单删除成功"];
        [self.mainTableView.mj_header beginRefreshing];
    }
}
@end
