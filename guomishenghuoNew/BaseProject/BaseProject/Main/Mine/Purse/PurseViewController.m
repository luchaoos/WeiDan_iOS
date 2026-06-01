//
//  PurseViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/5/10.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "PurseViewController.h"
#import "SetPayPwdViewController.h"
#import "ChongZhiViewController.h"
#import "TiXianViewController.h"
#import "UserInfoModel.h"
#import "DataProviderOther.h"
#import "ProjectTools.h"
#import "FL_Button.h"
#import "TiXianJiLuViewController.h"

@interface PurseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)UIImageView *img_icon;
@property (nonatomic,strong)UIButton * lbl_Myyue;
@property (nonatomic,strong)UIButton * btn_chongzhi;
@property (nonatomic,strong)UIButton * btn_tixian;
@property (nonatomic,strong)UIButton * btn_setpay;

@end

@implementation PurseViewController
{
    UIView * topBackView;
    UILabel * lbl_nickname;
    UILabel * lbl_yue;
    UserInfoModel *userInfo;
    
    NSInteger pageNo;
    NSInteger pageSize;
    
    NSArray * dataArray;
    
    float totalMoney;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"fanhui"];
    _lblTitle.text=@"我的钱包";
    pageSize=10;
    userInfo = [ProjectTools getUserInfo];
//    if ([[Toolkit getUserDefaultByKey:havePayPassword] isEqualToString:@"YES"]) {
//        [self addRightbuttontitle:@"修改密码"];
//    }
//    else{
//        [self addRightbuttontitle:@"支付密码"];
//    [self addRightButton:@"shezhipay"];
//    }
    [self addRightbuttontitle:@"余额明细"];
//    [self BuildTopView];
//    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.img_icon];
    [self.view addSubview:self.lbl_Myyue];
    [self.view addSubview:self.btn_chongzhi];
    [self.view addSubview:self.btn_tixian];
    [self.view addSubview:self.btn_setpay];
}

-(void)GetDetialList
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetDetitlListCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andtype:@"9"];
}

-(void)GetDetitlListCallBack:(id)dict
{
    ELog(dict);
    
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    
    if (RequestSuccess(dict)) {
//        dataArray=[[NSArray alloc] initWithArray:dict[@"data"][@"List"]];
//        [self.mainTableView reloadData];
//        lbl_yue.text=[NSString stringWithFormat:@"余额:%.2f",[dict[@"data"][@"TotalMoney"] floatValue]];
        totalMoney=[dict[@"data"][@"TotalMoney"] floatValue];
        pageNo ++;
        NSString *str1 = @"我的余额";
        NSString *str2 = [NSString stringWithFormat:@"￥%.2f",[dict[@"data"][@"TotalMoney"] floatValue]];
        NSString *string = [NSString stringWithFormat:@"%@\n%@",str1,str2];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8.0;
        NSDictionary *attrsDictionary1 = @{NSFontAttributeName:[UIFont systemFontOfSize:30],
                                           NSParagraphStyleAttributeName:paragraphStyle};
        NSDictionary *attrsDictionary2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                           NSParagraphStyleAttributeName:paragraphStyle};
        //给str1添加属性
        [attributedString addAttributes:attrsDictionary1 range:NSMakeRange(0, str1.length)];
        //给str2设置
        [attributedString addAttributes:attrsDictionary2 range:NSMakeRange(str1.length, str2.length+1)];
        
        [self.lbl_Myyue setAttributedTitle:attributedString forState:UIControlStateNormal];
//        
    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
//    }
}

-(void)GetDetialList1
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetDetitlListCallBack1:" setFailBackFunctionName:nil];
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:[NSString stringWithFormat:@"%d",(pageNo*pageSize)] andmaximumRows:[NSString stringWithFormat:@"%ld",(long)pageSize] andtype:@"9"];
}

-(void)GetDetitlListCallBack1:(id)dict
{
    ELog(dict);
    
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    
    if (RequestSuccess(dict)) {
        @try {
            NSMutableArray * itemarray=[[NSMutableArray alloc] initWithArray:dataArray];
            for (NSDictionary * itemDict in dict[@"data"][@"List"]) {
                [itemarray addObject:itemDict];
            }
            dataArray=[[NSArray alloc] initWithArray:itemarray];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
//
       [self.mainTableView reloadData];
        pageNo ++;
        
    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
//    }
}






-(void)BuildTopView
{
    UIImageView * img_Header=[[UIImageView alloc] init];
    img_Header.center=CGPointMake(SCREEN_WIDTH/2, _topView.frame.size.height-22);
    img_Header.bounds=CGRectMake(0, 0, 44, 44);
    img_Header.layer.masksToBounds=YES;
    img_Header.layer.cornerRadius=22;
    [img_Header sd_setImageWithURL:[NSURL URLWithString:get_sp(@"PhotoPath")] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    [_topView addSubview:img_Header];
    topBackView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 130)];
    topBackView.backgroundColor=_topView.backgroundColor;
    lbl_nickname=[[UILabel alloc] init];
    lbl_nickname.bounds=CGRectMake(0, 0, SCREEN_WIDTH, 20);
    lbl_nickname.center=CGPointMake(SCREEN_WIDTH/2, 20);
    lbl_nickname.text=userInfo.userName;
    lbl_nickname.textColor=[UIColor whiteColor];
    lbl_nickname.textAlignment=NSTextAlignmentCenter;
    [topBackView addSubview:lbl_nickname];
    
    lbl_yue=[[UILabel alloc] init];
    lbl_yue.bounds=CGRectMake(0, 0, SCREEN_WIDTH, 20);
    lbl_yue.center=CGPointMake(SCREEN_WIDTH/2, CGRectGetMaxY(lbl_nickname.frame)+20);
    lbl_yue.text=[NSString stringWithFormat:@"余额:"];
    lbl_yue.textColor=[UIColor whiteColor];
    lbl_yue.textAlignment=NSTextAlignmentCenter;
    [topBackView addSubview:lbl_yue];
    
    FL_Button * btn_1=[FL_Button fl_shareButton];
    btn_1.status=FLAlignmentStatusNormal;
    [btn_1 setImage:[UIImage imageNamed:@"chongzhi"] forState:UIControlStateNormal];
    [btn_1 setTitle:@" 充值" forState:UIControlStateNormal];
    btn_1.center=CGPointMake(SCREEN_WIDTH/4, CGRectGetMaxY(lbl_yue.frame)+45);
    btn_1.bounds=CGRectMake(0, 0,SCREEN_WIDTH/2, 30);
    [btn_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_1.titleLabel.font=[UIFont systemFontOfSize:20];
    btn_1.layer.masksToBounds=YES;
    btn_1.layer.cornerRadius=5;
//    btn_1.backgroundColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
    [topBackView addSubview:btn_1];
    [btn_1 addTarget:self action:@selector(JumpToChongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    FL_Button * btn_2=[FL_Button fl_shareButton];
    btn_2.status=FLAlignmentStatusNormal;
    [btn_2 setImage:[UIImage imageNamed:@"tixian"] forState:UIControlStateNormal];
    [btn_2 setTitle:@" 提现" forState:UIControlStateNormal];
    btn_2.center=CGPointMake(SCREEN_WIDTH/4*3, CGRectGetMaxY(lbl_yue.frame)+45);
    btn_2.bounds=CGRectMake(0, 0,SCREEN_WIDTH/2, 30);
    [btn_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_2.titleLabel.font=[UIFont systemFontOfSize:20];
    [btn_2 addTarget:self action:@selector(JumpToTiXian) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:btn_2];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn_1.frame), btn_1.frame.origin.y, 0.5, btn_1.frame.size.height)];
    fenge.backgroundColor=[UIColor whiteColor];
    [topBackView addSubview:fenge];

    
    [self.view addSubview:topBackView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray!=nil?dataArray.count:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"余额明细";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UILabel * lbl_left=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, (SCREEN_WIDTH-30)/2, 60)];
    lbl_left.text=[NSString stringWithFormat:@"%@\n",dataArray[indexPath.row][@"Description"]];
    lbl_left.numberOfLines=2;
    [cell.contentView addSubview:lbl_left];
    
    UILabel * lbl_right=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl_left.frame), 0, (SCREEN_WIDTH-30)/2, 60)];
    
    lbl_right.font=[UIFont systemFontOfSize:16];
    lbl_right.text=[NSString stringWithFormat:@"%@\n金额￥%@",[[NSString stringWithFormat:@"%@",dataArray[indexPath.row][@"OperateTime"] ] substringToIndex:10],[NSString stringWithFormat:@"%.2f",[dataArray[indexPath.row][@"Amount"] floatValue]]];
    lbl_right.textAlignment=NSTextAlignmentRight;
    lbl_right.numberOfLines=2;
    [cell.contentView addSubview:lbl_right];
    
    
    
    return cell;
}


-(void)clickRightButton:(UIButton *)sender
{
//    SetPayPwdViewController * setpayPwdVC=[[SetPayPwdViewController alloc] init];
//    setpayPwdVC.isreaister=NO;
//    [self.navigationController pushViewController:setpayPwdVC animated:YES];
    TiXianJiLuViewController * tixianjiluVC=[[TiXianJiLuViewController alloc] init];
    [self.navigationController pushViewController:tixianjiluVC animated:YES];
}

-(void)JumpToChongZhi
{
    ChongZhiViewController * chongzhiVC=[[ChongZhiViewController alloc] init];
    
    [self.navigationController pushViewController:chongzhiVC animated:YES];
}
-(void)JumpToTiXian
{
    TiXianViewController * tixianVC=[[TiXianViewController alloc] init];
    tixianVC.TotalMoney=totalMoney;
    [self.navigationController pushViewController:tixianVC animated:YES];
}
-(void)JumpToSetPayPWD
{
    SetPayPwdViewController * setpayPwdVC=[[SetPayPwdViewController alloc] init];
    setpayPwdVC.isreaister=NO;
    [self.navigationController pushViewController:setpayPwdVC animated:YES];
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topBackView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(topBackView.frame))];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
        
        _mainTableView.showsVerticalScrollIndicator=NO;
        __unsafe_unretained __typeof(self) weakSelf = self;
        _mainTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [_mainTableView.mj_footer setState:MJRefreshStateIdle];
            pageNo = 0;
            [weakSelf GetDetialList];
            
        }];
        [_mainTableView.mj_header beginRefreshing];
        
        // 上拉刷新
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf GetDetialList1];
        }];

    }
    return _mainTableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIImageView *)img_icon
{
    if (!_img_icon) {
        _img_icon=[[UIImageView alloc] init];
        _img_icon.bounds=CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        _img_icon.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_WIDTH/8+100);
        _img_icon.image=img(@"zuanshilogo");
    }
    return _img_icon;
}
-(UIButton *)lbl_Myyue
{
    if (!_lbl_Myyue) {
        _lbl_Myyue=[[UIButton alloc] init];
        _lbl_Myyue.frame=CGRectMake(0, CGRectGetMaxY(self.img_icon.frame)+30, SCREEN_WIDTH, 100);
        _lbl_Myyue.titleLabel.numberOfLines=2;
//        _lbl_Myyue.textAlignment=NSTextAlignmentCenter;
    }
    return _lbl_Myyue;
}
-(UIButton *)btn_chongzhi
{
    if (!_btn_chongzhi) {
        _btn_chongzhi=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.lbl_Myyue.frame)+20, SCREEN_WIDTH-60, 44)];
        _btn_chongzhi.backgroundColor=NAVBAR_COLOR;
        [_btn_chongzhi setTitle:@"充值" forState:UIControlStateNormal];
        [_btn_chongzhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_chongzhi addTarget:self action:@selector(JumpToChongZhi) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_chongzhi;
}
-(UIButton *)btn_tixian
{
    if (!_btn_tixian) {
        _btn_tixian=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.btn_chongzhi.frame)+20, SCREEN_WIDTH-60, 44)];
        _btn_tixian.backgroundColor=[UIColor lightGrayColor];
        [_btn_tixian setTitle:@"提现" forState:UIControlStateNormal];
        [_btn_tixian setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn_tixian addTarget:self action:@selector(JumpToTiXian) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_tixian;
}
-(UIButton *)btn_setpay
{
    if (!_btn_setpay) {
        _btn_setpay=[[UIButton alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT-60, SCREEN_WIDTH-60, 44)];
//        _btn_setpay.backgroundColor=[UIColor lightGrayColor];
        [_btn_setpay setTitle:@"修改支付密码" forState:UIControlStateNormal];
        [_btn_setpay setTitleColor:NAVBAR_COLOR forState:UIControlStateNormal];
        [_btn_setpay addTarget:self action:@selector(JumpToSetPayPWD) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_setpay;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self GetDetialList];
//    [self.mainTableView.mj_header beginRefreshing];
    _app_.hiddenTabBar;
}

@end
