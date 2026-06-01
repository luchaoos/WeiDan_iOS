//
//  OrderView.m
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "OrderView.h"
#import "GoodDetailCellTableViewCell.h"

#define _CELLHEIGHT     40


#define GoodDetailCell (indexPath.row > 0 && indexPath.row < 1 + self.orderDetail.orderGoods.count )

@interface OrderView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UITableView *mainTableView;

@end

@implementation OrderView

+(CGFloat)CalculateViewHeightWithOrderDetail:(OrderDetailModel *)orderDetail
{
    
    CGFloat viewHeight = _CELLHEIGHT *3.5;//日期  统计  按键
    viewHeight += orderDetail.orderGoods.count * GoodDetailHeight;
    
    
    viewHeight += 10;//留一丢丢缝隙
    return viewHeight;
    
}

+(instancetype)OrderViewWithOrderDetail:(OrderDetailModel *)orderDetail
{
    return [[self alloc] initWithOrderDetail:orderDetail];
}


-(instancetype)initWithOrderDetail:(OrderDetailModel *)orderDetail
{
    if (self = [super init]) {
        
        _orderDetail = orderDetail;
        
        [self buildViews];
    }
    
    return self;
}

-(void)buildViews
{
    self.backgroundColor = [UIColor whiteColor];
    if (self.orderDetail == nil) {
        return;
    }
    
    self.frame = CGRectMake(0, 0 , SCREEN_WIDTH, [OrderView CalculateViewHeightWithOrderDetail:self.orderDetail]);
    self.mainTableView.frame = self.bounds;
    [self addSubview:self.mainTableView];

}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3 + self.orderDetail.orderGoods.count;
}

#pragma mark - setting for cell
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier = ZY_NSStringFromFormat(@"Cell%ld",indexPath.row);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    if (indexPath.row == 0) {
        
        if([self.orderDetail.orderType integerValue] == OrderTypeJiFen)
        {
            cell.detailTextLabel.textColor = NAVBAR_COLOR;
            cell.textLabel.text = ZY_NSStringFromFormat(@"订单编号：%@",self.orderDetail.orderNumber);
            cell.detailTextLabel.text = [OrderDetailModel getStateStrWithState:[self.orderDetail.orderState integerValue]];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"shangjiatubiao"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.orderDetail.orderOwerShop;
        }
    }
    
    if (GoodDetailCell) {
        
        GoodDetailCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodDetailCell"];
        cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        GoodDetailModel *goodModel = self.orderDetail.orderGoods[indexPath.row - 1];
        cell.goodName.text = goodModel.goodName;
        
//        NSString *specs = ZY_NSStringFromFormat(@"%@:%@ %@:%@",goodModel.goodSpecs[0].specsName,goodModel.goodSpecs[0].specsSelected,goodModel.goodSpecs[1].specsName,goodModel.goodSpecs[1].specsSelected);
        NSString *specs = @"";
        if (goodModel.goodSpecs.count > 0) {
            specs = goodModel.goodSpecs[0].specsSelected;
        }
        
        cell.goodSpecs.text = specs;
        cell.goodPrice.text = ZY_NSStringFromFormat(@"¥%@",goodModel.goodPrice);
        cell.goodCountLib.text =ZY_NSStringFromFormat(@"x%@",goodModel.goodCount);
        
    
        [cell.goodImg sd_setImageWithURL:[NSURL URLWithString:goodModel.goodImgUrl] placeholderImage:[UIImage imageNamed:@"tianjiatupian"]];
        return cell;
        
    }
    
    if (indexPath.row == self.orderDetail.orderGoods.count+1) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor=NAVBAR_COLOR;
        cell.detailTextLabel.text = ZY_NSStringFromFormat(@"共%ld件商品       实付¥%@",self.orderDetail.orderGoods.count,self.orderDetail.orderPrice);
    }
    
    if (indexPath.row == self.orderDetail.orderGoods.count+2) {
        
        CGFloat btnWidth = 70;
        
        RoundButton *leftBtn = [cell.contentView viewWithTag:200];
        if (leftBtn == nil) {
            leftBtn = [[RoundButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - btnWidth - 20 - btnWidth - 10, 12, btnWidth, 35)];
            leftBtn.tag = 200;
        }
        [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:leftBtn];
        
        RoundButton *rightBtn = [cell.contentView viewWithTag:300];
        if (rightBtn == nil) {
            rightBtn = [[RoundButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - btnWidth - 15, 12, btnWidth, 35)];
            rightBtn.tag = 300;
        }
        [rightBtn addTarget:self action:@selector(RightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:rightBtn];
        rightBtn.myTintColor = NAVBAR_COLOR;
        
        
        if([self.orderDetail.orderType integerValue] == OrderTypeJiFen)
        {
        
            OrderState state = [self.orderDetail.orderState integerValue];
            
            switch (state) {
                case OrderStateUnPay:
                {
                    [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    [rightBtn setTitle:@"去付款" forState:UIControlStateNormal];

                }
                    break;
                case OrderStateUnRecv:
                {
                    [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [rightBtn setTitle:@"收货" forState:UIControlStateNormal];

                }
                    break;
                case OrderStateWaitSend:
                {
                    [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    [rightBtn setTitle:@"等待发货" forState:UIControlStateNormal];

                }
                    break;
                    
//                case OrderStateAlreadySend:
//                {
//                    [leftBtn setTitle:@"换货" forState:UIControlStateNormal];
//                    [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                }
//                    break;
                case OrderStateUnComment:
                case OrderStateFinish:
                {
                    [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    [rightBtn setTitle:@"评价" forState:UIControlStateNormal];

                }
                    break;
                    
                case OrderStateCancel:
                {
                    leftBtn.hidden = YES;
                    rightBtn.myTintColor = [UIColor lightGrayColor];
                    [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];

                }
                    break;
                    
                    
                default:
                    break;
            }
        }
        else
        {
            
            //nomal 和拒绝退款状态 正常进行订单流程
            if ([self.orderDetail.orderTuiKuanState integerValue] == OrderTuanGouTuiKunStateNormal ||
                [self.orderDetail.orderTuiKuanState integerValue] == OrderTuanGouTuiKunStateTuiKuanRejected) {
                
                NSLog(@"%@",self.orderDetail.orderTuiKuanState);
                OrderTuanGouState state = [self.orderDetail.orderState integerValue];
                
                switch (state) {
                    case OrderTuanGouStateUnPay:
                    {
                        [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                        [rightBtn setTitle:@"付款" forState:UIControlStateNormal];
                        
                    }
                        break;
                    case OrderTuanGouStateUnUse:
                    {
                        [rightBtn setTitle:@"查看券码" forState:UIControlStateNormal];
                        [leftBtn removeFromSuperview];
                    }
                        break;
                        
                    case OrderTuanGouStateUnComment:
                    {
                        [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                        [rightBtn setTitle:@"评价" forState:UIControlStateNormal];
                    }
                        break;
                        
                    case OrderTuanGouStatePayOnShop:
                    {
                        [rightBtn setTitle:@"到店支付" forState:UIControlStateNormal];
                        [leftBtn removeFromSuperview];
                    }
                        break;
                        
                        
                    default:
                        break;
                }
            }
            else
            {
                rightBtn.layer.borderWidth = 0;
                
                switch ((OrderTuanGouTuiKunState)[self.orderDetail.orderTuiKuanState integerValue]) {
                    case OrderTuanGouTuiKunStateApplyTuiKuan:
                    {
                        [leftBtn removeFromSuperview];
                        [rightBtn setTitle:@"等待退款" forState:UIControlStateNormal];
                    }
                        break;
                    case OrderTuanGouTuiKunStateTuiKuanFinish:
                    {
                        [leftBtn removeFromSuperview];
                        [rightBtn setTitle:@"退款成功" forState:UIControlStateNormal];
                    }
                        break;
                    case OrderTuanGouTuiKunStateTuiKuanRejected:
                    {
                        [leftBtn removeFromSuperview];
                        [rightBtn setTitle:@"退款被拒" forState:UIControlStateNormal];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                
            }
            
            
        }
        
    }
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (GoodDetailCell) {
        return GoodDetailHeight;
    }
    if (indexPath.row == self.orderDetail.orderGoods.count + 2) {
        return _CELLHEIGHT * 1.5;
    }
    return  _CELLHEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    DLog(@"click cell section : %ld row : %ld",(long)indexPath.section,(long)indexPath.row);
    
    
    if ([self.delegate respondsToSelector:@selector(OrderView:clickTableViewIndexPath:)]) {
        [self.delegate OrderView:self clickTableViewIndexPath:indexPath];
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
    
    return 0;
    
}

-(void)leftBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(OrderView:LeftBtnClick:)]) {
        [self.delegate OrderView:self LeftBtnClick:sender];
    }
}
-(void)RightBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(OrderView:RightBtnClick:)]) {
        [self.delegate OrderView:self RightBtnClick:sender];
    }
}
#pragma mark - property

-(UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.backgroundColor = BACKGROUND_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.scrollEnabled = NO;
        _mainTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        
        [_mainTableView registerNib:[UINib nibWithNibName:@"GoodDetailCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodDetailCell"];
    }
    
    
    return _mainTableView;
}


@end
