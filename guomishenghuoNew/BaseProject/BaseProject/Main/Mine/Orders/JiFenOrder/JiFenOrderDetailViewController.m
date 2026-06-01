//
//  JiFenOrderDetailViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "JiFenOrderDetailViewController.h"
#import "OrderView.h"
#import "DataProviderOther.h"
#import "AppraiseViewController.h"

@interface JiFenOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,OrderViewDelegate,UIActionSheetDelegate>
@property(nonatomic) UITableView *mainTableView;
@end

@implementation JiFenOrderDetailViewController
{
    NSString * cancelMessage;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    cancelMessage=@"";
    [self initViews];
}

-(void)initViews
{
    self.navtitle = @"商城订单详情";
    
    [self.view addSubview:self.mainTableView];
//    [self.view addSubview:[self OperationBar]];
}

-(UIView *)OperationBar
{
    UIView *operationBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 60)];
    operationBar.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnWidth = 70;
    
    RoundButton *rightBtn = [[RoundButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70 - 10,10 , btnWidth, 40)];
    rightBtn.myTintColor = NAVBAR_COLOR;
    [operationBar addSubview:rightBtn];
    
    RoundButton *leftBtn = [[RoundButton alloc] initWithFrame:CGRectMake(rightBtn.frame.origin.x - 70 - 10,10 , btnWidth, 40)];
    [operationBar addSubview:leftBtn];
    
    
    OrderState state = [self.orderDetail.orderState integerValue];
    switch (state) {
        case OrderStateUnPay:
        {
            [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [rightBtn setTitle:@"去付款" forState:UIControlStateNormal];
        }
            break;
        case OrderStateWaitSend:
        {
            [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [rightBtn setTitle:@"等待发货" forState:UIControlStateNormal];
        }
            break;
        case OrderStateUnRecv:
        {
            [leftBtn setTitle:@"物流查询" forState:UIControlStateNormal];
            [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
        case OrderStateUnComment:
        {
            [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [rightBtn setTitle:@"评价" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    return operationBar;
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1+3;
    }
    
    if (section == 2) {
        OrderState state = [self.orderDetail.orderState integerValue];
        switch (state) {
            case OrderStateUnPay:
                return 2;
                break;
            case OrderStateWaitSend:
                return 3;
                break;
            case OrderStateUnRecv:
                return 3;
                break;
            case OrderStateUnComment:
                return 4;
                break;
                
            default:
                break;
        }
    }
    
    return 4;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier = ZY_NSStringFromFormat(@"Cell%ld%ld",indexPath.section,indexPath.row);

    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = ZY_NSStringFromFormat(@"%@ %@",self.orderDetail.orderCustomAddress.Address_name,self.orderDetail.orderCustomAddress.Address_phone);
        cell.detailTextLabel.text = self.orderDetail.orderCustomAddress.Address_addr;
        cell.detailTextLabel.layer.masksToBounds=YES;
        cell.detailTextLabel.numberOfLines =  2;
        return cell;
    }
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1 ) {
        
        if (indexPath.row == 0) {
            OrderDetailModel *orderModel = self.orderDetail;
            
            OrderView *orderView = [cell.contentView viewWithTag:123];
            if (orderView != nil) {
                [orderView removeFromSuperview];
                orderView = nil;
            }
            orderView = [OrderView OrderViewWithOrderDetail:orderModel];
            orderView.delegate=self;
            orderView.tag = 123;
            [cell.contentView addSubview:orderView];
        }
        else
        {
            
            switch (indexPath.row) {
                case 1:
                {
                    cell.textLabel.text = @"运费：";
                    cell.detailTextLabel.text = @"到付";
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"服务费：";
                    cell.detailTextLabel.text = @"到付";
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = @"支付方式：";
                    cell.detailTextLabel.text = @"购物券钱包";
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text  = ZY_NSStringFromFormat(@"订单编号：%@",self.orderDetail.orderNumber);
            }
                break;
            case 1:
            {
                 cell.textLabel.text  = ZY_NSStringFromFormat(@"创建时间：%@",self.orderDetail.orderTime);
            }
                break;
            case 2:
            {
                cell.textLabel.text  = ZY_NSStringFromFormat(@"付款时间：%@",self.orderDetail.orderPayTime);
                
            }
                break;
            case 3:
            {
                cell.textLabel.text  = ZY_NSStringFromFormat(@"收货时间：%@",self.orderDetail.orderReviceTime);
                
            }
                break;
                
            default:
                break;
        }
    }

    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 70;
    }
    if (indexPath.section == 1 && indexPath.row ==0) {
        return  [OrderView CalculateViewHeightWithOrderDetail:self.orderDetail];
    }
    
    return  30;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
}


#pragma mark - setting for section

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}



//设置section footer的高度

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 1;
    }
    
    return 10;
    
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
            [Toolkit makeCall:@"123"];
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
    
}
-(void)OrderView:(OrderView *)orderView RightBtnClick:(UIButton *)sender
{
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
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==2) {
        
        switch (buttonIndex) {
            case 0:
                cancelMessage=@"商家停业/转让/装修";
                [self CancelOrder:self.orderDetail.orderId];
                break;
            case 1:
                cancelMessage=@"买多了/买错了";
                [self CancelOrder:self.orderDetail.orderId];
                break;
            case 2:
                cancelMessage=@"后悔/不想要了";
                [self CancelOrder:self.orderDetail.orderId];
                break;
            case 3:
                cancelMessage=@"联系不上商家";
                [self CancelOrder:self.orderDetail.orderId];
                break;
            default:
                break;
        }
        
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
    [dataproviderOther SaveBillWithbillid:self.orderDetail.orderId andaddressid:self.orderDetail.orderCustomAddress.Address_Id andtype:@"1" andbuyermessage:@"" andtotalprice:self.orderDetail.orderPrice];
    
}
-(void)SaveBillCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [SVProgressHUD showSuccessWithStatus:@"订单支付成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height , SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height +10 )];
        _mainTableView.backgroundColor = BACKGROUND_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    
    return _mainTableView;
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
