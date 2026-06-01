//
//  TuanGouOrderDetailViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "TuanGouOrderDetailViewController.h"
#import "DataProviderOther.h"
#import "Pingpp.h"
#import "JSONKit.h"
#import "RatingsViewController.h"

#define LeftGap         15
#define _CELLHEIGHT     40

typedef NS_ENUM(NSInteger,TableViewSection) {
    TableViewSectionGoodInfo,
    TableViewSectionOperation,//订单操作section
    TableViewSectionShopInfo,
    TableViewSectionOrderDetail,

    TableViewSectionCount
};

@interface TuanGouOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property(nonatomic) UITableView *mainTableView;
@end

@implementation TuanGouOrderDetailViewController
{
    NSString * cancelMessage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

-(void)initViews
{
    self.navtitle = @"订单详情";
    [self.view addSubview:self.mainTableView];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return TableViewSectionCount;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch ((TableViewSection)section) {
        case TableViewSectionGoodInfo:
            return self.orderDetail.orderGoods.count;
            break;
            
        case TableViewSectionOperation:
        {
            if ([self.orderDetail.orderTuiKuanState integerValue] == OrderTuanGouTuiKunStateNormal ||
                [self.orderDetail.orderTuiKuanState integerValue] == OrderTuanGouTuiKunStateTuiKuanRejected)
            {
            
                OrderTuanGouState state = [self.orderDetail.orderState integerValue];
                switch (state) {
                    case OrderTuanGouStateUnPay:
                        return 1;
                        break;
                    case OrderTuanGouStateUnUse:
                        return 2;
                    case OrderTuanGouStateUnComment:
                        return 1;
                    default:
                        break;
                }
            }
            else
            {
                return 1;
            }
        }
            break;
            
        case TableViewSectionShopInfo:
            return 2;
            break;
        case TableViewSectionOrderDetail:
            return 6;
            
        default:
            break;
    }
    
    return 1;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier = ZY_NSStringFromFormat(@"Cell%ld",indexPath.row);
    
    if (indexPath.section == TableViewSectionGoodInfo && indexPath.row<self.orderDetail.orderGoods.count) {

        GoodDetailCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodDetailCell"];
        
        GoodDetailModel *goodModel = self.orderDetail.orderGoods[indexPath.row];
        cell.goodName.text = goodModel.goodName;
        
        OrderTuanGouState state = [self.orderDetail.orderState integerValue];
        if (state != OrderTuanGouStateUnPay) {
            cell.goodSpecs.text = @"";
        }
        else
        {
            NSString *specs = ZY_NSStringFromFormat(@"%@",[Toolkit judgeIsNull:goodModel.goodSpecs[0].specsName]);
            
            cell.goodSpecs.text = specs;
        }
    
       
        cell.goodPrice.text = ZY_NSStringFromFormat(@"¥%@",goodModel.goodPrice);
        cell.goodCountLib.text =ZY_NSStringFromFormat(@"x%@",goodModel.goodCount);
        
        [cell.goodImg sd_setImageWithURL:[NSURL URLWithString:goodModel.goodImgUrl] placeholderImage:[UIImage imageNamed:@"tianjiatupian"]];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == TableViewSectionGoodInfo && indexPath.row == self.orderDetail.orderGoods.count) {
            UIButton *miaoshuBtn = [cell.contentView viewWithTag:110];
            
            if (miaoshuBtn == nil) {
                miaoshuBtn = [[UIButton alloc] initWithFrame:CGRectMake(LeftGap, 0, 100, _CELLHEIGHT)];
                miaoshuBtn.tag = 110;
                [miaoshuBtn setTitle:@"描述相符" forState:UIControlStateNormal];
                [miaoshuBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [miaoshuBtn setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
                
            }
            [cell.contentView addSubview:miaoshuBtn];
            
            UIButton *serverBtn = [cell.contentView viewWithTag:111];
            
            if (serverBtn == nil) {
                serverBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(miaoshuBtn.frame) + 20, 0, 100, _CELLHEIGHT)];
                serverBtn.tag = 111;
                [serverBtn setTitle:@"服务态度" forState:UIControlStateNormal];
                [serverBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [serverBtn setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
                
            }
            [cell.contentView addSubview:serverBtn];
            
        }
        
        if (indexPath.section == TableViewSectionOperation) {
            OrderTuanGouState state = [self.orderDetail.orderState integerValue];
            OrderTuanGouTuiKunState tuiKuanState = [self.orderDetail.orderTuiKuanState integerValue];
            
            if (tuiKuanState == OrderTuanGouTuiKunStateNormal || tuiKuanState == OrderTuanGouTuiKunStateTuiKuanRejected) {
                switch (state) {
                    case OrderTuanGouStateUnPay:
                    {
                        cell.contentView.backgroundColor = BACKGROUND_COLOR;
                        
                        UIButton *payBtn = [cell.contentView viewWithTag:200];
                        
                        if (payBtn == nil) {
                            payBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 40)];
                            payBtn.center = CGPointMake(SCREEN_WIDTH/2, 60/2);
                            payBtn.tag = 200;
                            payBtn.backgroundColor = NAVBAR_COLOR;
                            [payBtn setTitle:@"付款" forState:UIControlStateNormal];
                            [payBtn addTarget:self action:@selector(Pay) forControlEvents:UIControlEventTouchUpInside];
                        }
                        [cell.contentView addSubview:payBtn];
                    }
                        break;
                    case OrderTuanGouStateUnUse:
                    {
                        if (indexPath.row==0) {
                            cell.textLabel.text=ZY_NSStringFromFormat(@"券码：%@",self.orderDetail.orderBuyCode);
                        }
                        if(indexPath.row == 1)
                        {
                            cell.contentView.backgroundColor = BACKGROUND_COLOR;
                            
                            UIButton *tuiKuanBtn = [cell.contentView viewWithTag:211];
                            
                            if (tuiKuanBtn == nil) {
                                tuiKuanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 40)];
                                tuiKuanBtn.center = CGPointMake(SCREEN_WIDTH/2, 60/2);
                                tuiKuanBtn.tag = 211;
                                tuiKuanBtn.backgroundColor = NAVBAR_COLOR;
                                [tuiKuanBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                                [tuiKuanBtn addTarget:self action:@selector(CancelOrder) forControlEvents:UIControlEventTouchUpInside];
                            }
                            [cell.contentView addSubview:tuiKuanBtn];
                        }
                            
                    }
                        break;
                    case OrderTuanGouStateUnComment:
                    {
                        if(indexPath.row == 0)
                        {
                            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            cell.detailTextLabel.text = @"去评价";
                            
                        }
                        
                    }
                        break;
                    default:
                        break;
                }
            }
            else//退款的情况
            {
                NSString *tuiKuanStr = @"";
                
                switch (tuiKuanState) {
                    case OrderTuanGouTuiKunStateApplyTuiKuan:
                        tuiKuanStr = @"退款中";
                        break;
                    case OrderTuanGouTuiKunStateTuiKuanFinish:
                        tuiKuanStr = @"退款完成";
                        break;

                    case OrderTuanGouTuiKunStateTuiKuanRejected:
                        tuiKuanStr = @"退款被拒绝";
                        break;

                        
                    default:
                        break;
                }
                
                cell.detailTextLabel.textColor = NAVBAR_COLOR;
                cell.detailTextLabel.text = tuiKuanStr;
            }
            
        }
        
        
        if (indexPath.section == TableViewSectionShopInfo) {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"商家信息";
            }
            else if (indexPath.row == 1)
            {
                UILabel *shopNameLab = [cell.contentView viewWithTag:300];
                if (shopNameLab == nil) {
                    shopNameLab = [[UILabel alloc] initWithFrame:CGRectMake(LeftGap, 0, SCREEN_WIDTH - 50, 20)];
                    shopNameLab.tag = 300;
                    shopNameLab.font = [UIFont systemFontOfSize:14];
                }
                shopNameLab.text = _orderDetail.orderOwerShop;
                [cell.contentView addSubview:shopNameLab];
                
                UILabel *addrLab = [cell.contentView viewWithTag:310];
                if (addrLab == nil) {
                    addrLab = [[UILabel alloc] initWithFrame:CGRectMake(LeftGap, 20, SCREEN_WIDTH - 50 - LeftGap, 30)];
                    addrLab.tag = 310;
                    addrLab.font = [UIFont systemFontOfSize:12];
                    addrLab.textColor = [UIColor lightGrayColor];
                }
                addrLab.text = self.orderDetail.orderShopAddress;
                addrLab.numberOfLines=2;
                [cell.contentView addSubview:addrLab];
                
//                UIButton *distanceBtn = [cell.contentView viewWithTag:320];
//                
//                if (distanceBtn == nil) {
//                    distanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(LeftGap, 60, 60, 30)];
//                    distanceBtn.tag = 320;
//                    distanceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//                    [distanceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
////                    [distanceBtn setImage:[UIImage imageNamed:@"ditutubiao"] forState:UIControlStateNormal];
//                    
//                }
//                [distanceBtn setTitle:@"" forState:UIControlStateNormal];
//                [cell.contentView addSubview:distanceBtn];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50,5, 1, 40)];
                lineView.backgroundColor =[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
                [cell.contentView addSubview:lineView];
                
                
                UIButton *phoneBtn = [cell.contentView viewWithTag:330];
                if (phoneBtn == nil) {
                    phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 49, 0, 49, 50)];
                    [phoneBtn setImage:[UIImage imageNamed:@"bohao"] forState:UIControlStateNormal];
                    [phoneBtn addTarget:self action:@selector(MakeCallForOrder) forControlEvents:UIControlEventTouchUpInside];
                    phoneBtn.tag = 330;
                }
                
                [cell.contentView addSubview:phoneBtn];
                
            }
  
        }
        
        
        if (indexPath.section ==  TableViewSectionOrderDetail) {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"订单详情";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = ZY_NSStringFromFormat(@"订单号：%@",self.orderDetail.orderNumber);
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = ZY_NSStringFromFormat(@"下单时间：%@",self.orderDetail.orderTime);
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = ZY_NSStringFromFormat(@"购买手机号：%@",[Toolkit judgeIsNull:self.orderDetail.orderCustomAddress.Address_phone]);
                }
                    break;
                case 4:
                {
                    cell.textLabel.text = ZY_NSStringFromFormat(@"数量：%ld",(unsigned long)self.orderDetail.orderGoods.count);
                }
                    break;
                case 5:
                {
                    cell.textLabel.text = ZY_NSStringFromFormat(@"总价：%@",self.orderDetail.orderPrice);
                }
                    break;
                    
                default:
                    break;
            }
        }
        return cell;
    
    }

}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == TableViewSectionGoodInfo) {
        if (indexPath.row < self.orderDetail.orderGoods.count) {
            return GoodDetailHeight;
        }
    }
    
    if (indexPath.section == TableViewSectionShopInfo) {
        if (indexPath.row == 1) {
            return 50;
        }
    }
    
    if (indexPath.section == TableViewSectionOperation) {
        return 60;
    }

    return  _CELLHEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
//    if (indexPath.section==OrderTuanGouStateUnComment&&indexPath.row==0) {
//        RatingsViewController * ratingsVC=[[RatingsViewController alloc] init];
//        ratingsVC.orderDetail=self.orderDetail;
//        [self.navigationController pushViewController:ratingsVC animated:YES];
//    }
    
}
-(void)MakeCallForOrder
{
    [Toolkit makeCall:self.orderDetail.orderShopPhone];
}
-(void)Pay
{
    UIActionSheet * ac_alert=[[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信",@"银联", nil];
    ac_alert.tag=3;
    [ac_alert showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==3) {
        NSString * payWay=@"";
        if (buttonIndex==1) {
            payWay=@"wx";
        }
        
        if (buttonIndex==0) {
            payWay=@"alipay";
        }
        if (buttonIndex==2) {
            payWay=@"upacp";
        }
        DataProviderOther * mainrequest=[[DataProviderOther alloc] init];
        [mainrequest setDelegateObject:self setSucceedBackFunctionName:@"GetChargeCallBack:" setFailBackFunctionName:nil];
        //    [mainrequest ChongZhiGetChargeWithchannel:payWay andamount:[NSString stringWithFormat:@"%d",[self.orderDetail.orderPrice intValue]]];
        NSArray * itemarray=[[NSArray alloc] initWithObjects:self.orderDetail.orderId, nil];
        [mainrequest TuanGouSaveBillWithlist_billid:[Toolkit NSArrayToJsonString:itemarray] andqianbao:@"0" andchannel:payWay andbuyermessage:@"" andtotalprice:ZY_NSStringFromFormat(@"%.0f",[self.orderDetail.orderPrice floatValue])];
    }
    else
    {
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

-(void)CancelOrder
{
    UIActionSheet * ac_alert=[[UIActionSheet alloc] initWithTitle:@"取消原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"商家停业/转让/装修",@"买多了/买错了",@"后悔/不想要了",@"联系不上商家", nil];
    ac_alert.tag=2;
    [ac_alert showInView:self.view];
    
    
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
        [YJXStatusHUD showSuccess:@"订单操作成功"];
        [self.mainTableView.mj_header beginRefreshing];
    }
    else
    {
        [YJXStatusHUD showError:@"操作失败，请联系客服"];
    }
}
-(void)JumpToPingjia
{
    RatingsViewController * ratingsVC=[[RatingsViewController alloc] init];
    [self.navigationController pushViewController:ratingsVC animated:YES];
}

#pragma mark - setting for section

//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}



//设置section footer的高度

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0 || section == 1) {
        return 1;
    }
    
    return 10;
    
}

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
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,Header_Height,SCREEN_WIDTH,SCREEN_HEIGHT - Header_Height)];
        _mainTableView.backgroundColor = BACKGROUND_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, LeftGap, 0, 0);
        
        [_mainTableView registerNib:[UINib nibWithNibName:@"GoodDetailCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodDetailCell"];
    }
    
    
    return _mainTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
