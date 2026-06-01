//
//  JiFenOrderViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "JiFenOrderViewController.h"
#import "OrderView.h"
#import "MJRefresh.h"
#import "SubmitJiFenOrderViewController.h"
#import "DataProviderOther.h"
#import "JCMineTableViewCell.h"
#import "AppraiseViewController.h"

#define JCMineTableViewCellName @"cell_mine"

@interface JiFenOrderViewController ()<UITableViewDataSource,UITableViewDelegate,OrderViewDelegate,UIActionSheetDelegate>
{
    
    NSInteger pageNo;
    NSInteger pageSize;
    OrderState _orderState;
    BOOL _isTuiKuan;
    BOOL _isDaoDian;
    // view
    UIView *_layerView;
    int index;
    OrderDetailModel * orderSelectModel;
    
    NSString *cancelMessage;
}

@property(nonatomic) NSMutableArray <UIButton *>*orderStateBtnArr;
@property(nonatomic) UITableView *mainTableView;
@property(nonatomic) NSMutableArray <OrderDetailModel *>* orderArr;

@end

@implementation JiFenOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cancelMessage=@"";
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate hiddenTabBar];
}

-(void)initViews
{
    self.navtitle = @"购物券商城订单";
    pageSize = 5;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height + 1, SCREEN_WIDTH, 35)];
    backView.backgroundColor = [UIColor whiteColor];
    
    NSArray *btnNameArr = @[@"待付款",@"待发货",@"待收货",@"待评价",@"到店支付"];
    
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
    
    [self stateBtnClick:self.orderStateBtnArr[0]];
    
    
    
    [self.view addSubview:backView];
    [self.view addSubview:self.mainTableView];
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
        model.orderState = ZY_NSStringFromFormat(@"%ld",orderState);
        model.orderId = ZY_NSStringFromFormat(@"%d",i);
        model.orderPrice = @"100";
        model.orderOwerShop = @"花随香店铺";
        model.orderNumber = @"1234567890";
        model.orderType = ZY_NSStringFromFormat(@"%ld",OrderTypeJiFen);
        
        
        AddressModel *address =  [[AddressModel alloc] init];
        address.Address_phone = @"18810375184";
        address.Address_name = @"奇衡三";
        address.Address_addr = @"山东省临沂市兰山区沂蒙路与解放路交汇新华书店15楼1506室";
        
        model.orderCustomAddress = address;
        
        for (int j = 0; j<i+1; j++) {
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
    [provider GetUserOrderListWithjifenstate:state
                             andtuangoustate:@"0"
                             andtuikuanstate:@"0"
                                  andisjifen:@"2"
                                andisdaodian:daoDian
                            andstartRowIndex:ZY_NSStringFromFormat(@"%ld",pageSize*pageNo)
                              andmaximumRows:ZY_NSStringFromFormat(@"%ld",pageSize)];
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
-(void)SaveBill
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"SaveBillCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther SaveBillWithbillid:orderSelectModel.orderId andaddressid:orderSelectModel.orderCustomAddress.Address_Id andtype:@"1" andbuyermessage:@"" andtotalprice:orderSelectModel.orderPrice];
    
}
-(void)SaveBillCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [SVProgressHUD showSuccessWithStatus:@"订单支付成功"];
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}


#pragma mark - actions
-(void)submitBtnClick
{
    SubmitJiFenOrderViewController *submitViewCtl = [[SubmitJiFenOrderViewController alloc] init];
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
    if (sender.tag <= OrderStateUnRecv) {
        
        _orderState = sender.tag;
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

#pragma mark - OrderViewDelegate

-(void)OrderView:(OrderView *)orderView clickTableViewIndexPath:(NSIndexPath *)indexPath
{
    JiFenOrderDetailViewController *jifeDetailViewCtl = [[JiFenOrderDetailViewController alloc] init];
    jifeDetailViewCtl.orderDetail = orderView.orderDetail;
    [self.navigationController pushViewController:jifeDetailViewCtl animated:YES];
}

-(void)OrderView:(OrderView *)orderView LeftBtnClick:(UIButton *)sender
{
    orderSelectModel=orderView.orderDetail;
    NSInteger index1 = [orderView.orderDetail.orderState integerValue];
    switch (index1) {
        case OrderStateUnPay:
        {
//            [self CancelOrder:orderView.orderDetail.orderId];
            
            UIActionSheet * ac_alert=[[UIActionSheet alloc] initWithTitle:@"取消原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"商家停业/转让/装修",@"买多了/买错了",@"后悔/不想要了",@"联系不上商家", nil];
            ac_alert.tag=2;
            [ac_alert showInView:self.view];
        }
            break;
        case OrderStateUnRecv:
        {
//            [Toolkit makeCall:@"123"];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",@"",@""]]];
//            [leftBtn setTitle:@"联系商家" forState:UIControlStateNormal];
//            [rightBtn setTitle:@"收货" forState:UIControlStateNormal];
            
            
        }
            break;
        case OrderStateWaitSend:
        {
//            [self CancelOrder:orderView.orderDetail.orderId];
            UIActionSheet * ac_alert=[[UIActionSheet alloc] initWithTitle:@"取消原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"商家停业/转让/装修",@"买多了/买错了",@"后悔/不想要了",@"联系不上商家", nil];
            ac_alert.tag=2;
            [ac_alert showInView:self.view];
        }
            break;
            
//            1;
////            
////                            case OrderStateAlreadySend:
////                            {
////                                [leftBtn setTitle:@"换货" forState:UIControlStateNormal];
////                                [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
////                            }
////                                break;
        case OrderStateUnComment:
        case OrderStateFinish:
        {
            [self DelOrder:orderView.orderDetail.orderId];
            
        }
            break;
            
        case OrderStateCancel:
        {
            [self DelOrder:orderView.orderDetail.orderId];
        }
            break;
            
            
        default:
            break;
    }
    
    
    UIButton *tempBtn = self.orderStateBtnArr[index];
    [self stateBtnClick:tempBtn];
}
-(void)OrderView:(OrderView *)orderView RightBtnClick:(UIButton *)sender
{
    orderSelectModel=orderView.orderDetail;
    NSInteger index1 = [orderView.orderDetail.orderState integerValue];
    switch (index1) {
            
        case OrderStateUnPay:
        {
            [self SaveBill];
        }
            break;
        case OrderStateUnRecv:
        {
            
            [self ReceiveOrder:orderView.orderDetail.orderId];
            
        }
            break;
        case OrderStateWaitSend:
        {
            //            [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            //            [rightBtn setTitle:@"等待发货" forState:UIControlStateNormal];
            
        }
            break;
            
            
//                                        case OrderStateAlreadySend:
//                                        {
//                                            [leftBtn setTitle:@"换货" forState:UIControlStateNormal];
//                                            [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                                        }
//                                            break;
        case OrderStateUnComment:
        case OrderStateFinish:
        {
            AppraiseViewController * pingjia=[[AppraiseViewController alloc] init];
            pingjia.orderDetail= orderView.orderDetail;
            [self.navigationController pushViewController:pingjia animated:YES];
        }
            break;
            
        case OrderStateCancel:
        {
            [self DelOrder:orderView.orderDetail.orderId];
        }
            break;
            
            
        default:
            break;
            
    }
    
    UIButton *tempBtn = self.orderStateBtnArr[index];
    [self stateBtnClick:tempBtn];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==2) {
       
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
        UILabel * lbl_left=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, (SCREEN_WIDTH-30)/2, 60)];
        lbl_left.text=[NSString stringWithFormat:@"到店支付\n金额￥%.2f",[self.orderArr[indexPath.section].orderPrice floatValue]];
        lbl_left.numberOfLines=2;
        [cell.contentView addSubview:lbl_left];
        
        UILabel * lbl_right=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl_left.frame), 0, (SCREEN_WIDTH-30)/2, 60)];
        
        lbl_right.font=[UIFont systemFontOfSize:16];
        lbl_right.text=[NSString stringWithFormat:@"\n%@",[_orderArr[indexPath.section].orderPayTime length]>10?[_orderArr[indexPath.section].orderPayTime substringToIndex:10]:@""];
        lbl_right.textAlignment=NSTextAlignmentRight;
        lbl_right.numberOfLines=2;
        [cell.contentView addSubview:lbl_right];
        
        
        
        return cell;
    }
    
    NSString *CellIdentifier = ZY_NSStringFromFormat(@"Cell%ld",(long)indexPath.row);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
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
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
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



//设置section footer的高度

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

#pragma mark - property

-(UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height + 37, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 10 - 35 )];
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
            [weakSelf getOrderListWithState:ZY_NSStringFromFormat(@"%ld",_orderState)
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
