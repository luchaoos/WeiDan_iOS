//
//  ThirdViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/6/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ThirdViewController.h"
#import "JCMineTableViewCell.h"
#import "lhScanQCodeViewController.h"
#import "PurseViewController.h"
#import "FL_Button.h"
#import "LoginViewController.h"
#import "AddressManagerViewController.h"
#import "JiFenViewController.h"
#import "HealthMoneyViewController.h"
#import "TodayRecommendViewController.h"
#import "ShouCangViewController.h"
#import "CommentViewController.h"
#import "TrolleyViewController.h"
#import "DataViewController.h"
#import "NewsCenterViewController.h"
#import "MoreViewController.h"
#import "CtrlCodeScan.h"
#import "Index_ShopInfoViewController.h"

#define JCMineTableViewCellName @"cell_mine"

@interface ThirdViewController ()<UITableViewDelegate,UITableViewDataSource,CtrlCodeScanDelegate>
@property (nonatomic,strong)UIImageView * img_userHeader;
@property (nonatomic,strong)UIButton * btn_userName;
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)UIImageView * img_tiao;
@end

@implementation ThirdViewController {
    NSString *jifen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavTitle];
    
    
    [self BuildHeaderView];
    [self.view addSubview:self.mainTableView];
}

-(void)initNavTitle
{
    _imgLeft.hidden=YES;
    _lblTitle.text=@"我的";
//    [UIImage imageNamed:@"gwc"]
    _imgLeft.hidden=NO;
    [self addLeftButton:@"gwerer"];
    [self addRightButton:@"xiaoxi"];
    UIButton * btn_saoyisao=[[UIButton alloc] initWithFrame:CGRectMake(_btnRight.frame.origin.x-30, _btnRight.frame.origin.y, 30, _btnRight.frame.size.height)];
    [btn_saoyisao setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
    [btn_saoyisao addTarget:self action:@selector(JumpToScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_saoyisao];
}

-(void)clickLeftButton:(UIButton *)sender {
//    if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
//        TrolleyViewController *tvc = [[TrolleyViewController alloc]init];
//        [self.navigationController pushViewController:tvc animated:YES];
//    }
//    else
//    {
//        [self JumpToLogin];
//    }
}

-(void)clickRightButton:(UIButton *)sender
{
    
    if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
        NewsCenterViewController * newsCenterVC=[[NewsCenterViewController alloc] init];
        [self.navigationController pushViewController:newsCenterVC animated:YES];
    }
    else
    {
        [self JumpToLogin];
    }
    
}
-(void)BuildHeaderView
{
    UIImageView * img_headerView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    img_headerView.image=[UIImage imageNamed:@"beijing"];
    img_headerView.userInteractionEnabled=YES;
    [img_headerView addSubview:self.img_userHeader];
    [img_headerView addSubview:self.btn_userName];
    self.img_tiao.center=CGPointMake(SCREEN_WIDTH/2, img_headerView.frame.size.height-15);
    [img_headerView addSubview:self.img_tiao];
    self.mainTableView.tableHeaderView=img_headerView;
}

#pragma mark - actions

-(void)orderBtnClick:(UIButton *)sender
{
    if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
        if (sender.tag == 1) {
            TuanGouOrdersViewController *tuanGouViewCtl = [[TuanGouOrdersViewController alloc] init];
            [self.navigationController pushViewController:tuanGouViewCtl animated:YES];
        }
        else if (sender.tag == 2)
        {
            JiFenOrderViewController *jiFenViewCtl = [[JiFenOrderViewController alloc] init];
            [self.navigationController pushViewController:jiFenViewCtl animated:YES];
        }
    }
    else
    {
        [self JumpToLogin];
    }
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2||section==3||section == 5) {
        return 1;
    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==1) {
        return 70;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==1) {
        UITableViewCell * cell=[[UITableViewCell alloc] init];
        FL_Button * btn_1=[FL_Button fl_shareButton];
        btn_1.status=FLAlignmentStatusTop;
        [btn_1 setImage:[UIImage imageNamed:@"tuangoudingdan"] forState:UIControlStateNormal];
        [btn_1 setTitle:@"到店支付" forState:UIControlStateNormal];
        btn_1.center=CGPointMake(SCREEN_WIDTH/4, 25);
        btn_1.bounds=CGRectMake(0, 0,SCREEN_WIDTH/2, 70);
        [btn_1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn_1.titleLabel.font=[UIFont systemFontOfSize:15];
        btn_1.tag = 1;
        [btn_1 addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_1];
//        [btn_1 addTarget:self action:@selector(JumpToChongZhi) forControlEvents:UIControlEventTouchUpInside];
        
        FL_Button * btn_2=[FL_Button fl_shareButton];
        btn_2.status=FLAlignmentStatusTop;
        [btn_2 setImage:[UIImage imageNamed:@"shangchengdingdan"] forState:UIControlStateNormal];
        [btn_2 setTitle:@"商城订单" forState:UIControlStateNormal];
        btn_2.center=CGPointMake(SCREEN_WIDTH/4*3, 25);
        btn_2.bounds=CGRectMake(0, 0,SCREEN_WIDTH/2, 70);
        [btn_2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn_2.titleLabel.font=[UIFont systemFontOfSize:15];
        btn_2.tag = 2;
        [btn_2 addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_2];
        return cell;
    }
    else
    {
        JCMineTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:JCMineTableViewCellName forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
            {
                cell.name.text = @"我的订单";
                cell.image.image = [UIImage imageNamed:@"wodedingdan"];
                cell.arrows_switch.hidden = YES;
                cell.arrows.hidden=YES;
            }
                break;
            case 1:
                if (indexPath.row==0) {
                    cell.name.text = @"购物券";
                    cell.image.image = [UIImage imageNamed:@"jifenqianbao"];
                    cell.arrows_switch.hidden = YES;
                }
                else
                {
                    cell.name.text = @"我的钱包";
                    cell.image.image = [UIImage imageNamed:@"wodeqianbao"];
                    cell.arrows_switch.hidden = YES;
                }
                break;
            case 2:
                cell.name.text = @"健康储蓄金";
                cell.image.image = [UIImage imageNamed:@"jiankangchuxujin"];
                cell.arrows_switch.hidden = YES;
                break;
            case 3:
                cell.name.text = @"今日推荐";
                cell.image.image = [UIImage imageNamed:@"jinrituij"];
                cell.arrows_switch.hidden = YES;
                break;
            case 4:
                if (indexPath.row==0) {
                    cell.name.text = @"我的地址";
                    cell.image.image = [UIImage imageNamed:@"wodedizhi"];
                    cell.arrows_switch.hidden = YES;
                }
                else
                {
                    cell.name.text = @"客服电话:400-6099-171";
                    cell.image.image = [UIImage imageNamed:@"kefudianhua"];
                    cell.arrows_switch.hidden = YES;
                }
                break;
            case 5:
                cell.name.text = @"更多设置";
                cell.image.image = [UIImage imageNamed:@"jinrituij"];
                cell.arrows_switch.hidden = YES;
                break;
            default:
                break;
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            
        }
        if (indexPath.section==1&&indexPath.row==1) {
            PurseViewController * purseVC=[[PurseViewController alloc] init];
            [self.navigationController pushViewController:purseVC animated:YES];
        }
        if (indexPath.section==1&&indexPath.row==0) {
            JiFenViewController * jifenView=[[JiFenViewController alloc] init];
            [self.navigationController pushViewController:jifenView animated:YES];
        }
        if (indexPath.section == 2) {
            HealthMoneyViewController *healthMoneyVC = [[HealthMoneyViewController alloc] init];
            [self.navigationController pushViewController:healthMoneyVC animated:YES];
        }
        if (indexPath.section == 3) {
            TodayRecommendViewController *todayRecommendVC = [[TodayRecommendViewController alloc] init];
            [self.navigationController pushViewController:todayRecommendVC animated:YES];
        }
        if (indexPath.section==4&&indexPath.row==0) {
            AddressManagerViewController * addressManagerVC=[[AddressManagerViewController alloc] init];
            [self.navigationController pushViewController:addressManagerVC animated:YES];
        }
        if (indexPath.section==4&&indexPath.row==1) {
            [Toolkit makeCall:@"4006099171"];
        }
        if (indexPath.section == 5) {
            MoreViewController * moreVC=[[MoreViewController alloc] init];
//            moreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreVC animated:YES];
        }
    }
    else
    {
        [self JumpToLogin];
    }
}



-(void)JumpToScan
{
    
    CtrlCodeScan * scanCode=[[CtrlCodeScan alloc] initWithNibName:@"CtrlCodeScan" bundle:[NSBundle mainBundle]];
    scanCode.delegate=self;
    [self.navigationController presentViewController:scanCode animated:YES completion:nil];
    
}

-(void)JumpToLogin
{
//    [Toolkit setUserDefaultWithObject:@"NO" forKey:isLogin];
//    NSLog(@"%@",[Toolkit getUserDefaultByKey:isLogin]);
//    
    if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
        //弹出个人信息页面
        DataViewController *dataVC = [[DataViewController alloc] init];
        [self.navigationController pushViewController:dataVC animated:YES];
    }
    else{
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}



-(UIImageView *)img_tiao
{
    if (!_img_tiao) {
        _img_tiao=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tiao"]];
        _img_tiao.bounds=CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _img_tiao.userInteractionEnabled=YES;
//        FL_Button * btn_1=[FL_Button fl_shareButton];
//        btn_1.status=FLAlignmentStatusNormal;
//        [btn_1 setImage:[UIImage imageNamed:@"wodeguomiquan"] forState:UIControlStateNormal];
//        [btn_1 setTitle:@" 果米券" forState:UIControlStateNormal];
//        btn_1.center=CGPointMake(SCREEN_WIDTH/6, 15);
//        btn_1.bounds=CGRectMake(0, 0,SCREEN_WIDTH/3, 30);
//        [btn_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn_1.titleLabel.font=[UIFont systemFontOfSize:15];
//        [_img_tiao addSubview:btn_1];
//        btn_1.tag = 101;
//        [btn_1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        FL_Button * btn_2=[FL_Button fl_shareButton];
        btn_2.status=FLAlignmentStatusNormal;
        [btn_2 setImage:[UIImage imageNamed:@"pingjia"] forState:UIControlStateNormal];
        [btn_2 setTitle:@" 评价" forState:UIControlStateNormal];
        btn_2.center=CGPointMake(SCREEN_WIDTH/4, 20);
        btn_2.bounds=CGRectMake(0, 0,SCREEN_WIDTH/2, 30);
        [btn_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_2.titleLabel.font=[UIFont systemFontOfSize:15];
        [_img_tiao addSubview:btn_2];
        btn_2.tag = 102;
        [btn_2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        FL_Button * btn_3=[FL_Button fl_shareButton];
        btn_3.status=FLAlignmentStatusNormal;
        [btn_3 setImage:[UIImage imageNamed:@"wodeshoucang"] forState:UIControlStateNormal];
        [btn_3 setTitle:@" 收藏" forState:UIControlStateNormal];
        btn_3.center=CGPointMake(SCREEN_WIDTH/4*3, 20);
        btn_3.bounds=CGRectMake(0, 0,SCREEN_WIDTH/2, 30);
        [btn_3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_3.titleLabel.font=[UIFont systemFontOfSize:15];
        [_img_tiao addSubview:btn_3];
        btn_3.tag = 103;
        [btn_3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _img_tiao;
}
-(void)btnClick:(UIButton *)button{
    if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
        if (button.tag == 101) {
            
        }
        else if (button.tag == 102) {
            CommentViewController *commentVC = [[CommentViewController alloc] init];
            [self.navigationController pushViewController:commentVC animated:YES];
        }
        else {
            ShouCangViewController *shoucangVC = [[ShouCangViewController alloc] init];
            [self.navigationController pushViewController:shoucangVC animated:YES];
        }
    }
    else
    {
        [self JumpToLogin];
    }
}

-(UIImageView *)img_userHeader
{
    if (!_img_userHeader) {
        _img_userHeader=[[UIImageView alloc] init];
        _img_userHeader.bounds=CGRectMake(0, 0, 50, 50);
        _img_userHeader.center=CGPointMake(45, 50);
        _img_userHeader.layer.masksToBounds=YES;
        _img_userHeader.layer.cornerRadius=25;
        _img_userHeader.userInteractionEnabled=YES;
//        _img_userHeader.contentMode=UIViewContentModeScaleAspectFit;
//        _img_userHeader.userInteractionEnabled=YES;
        [_img_userHeader sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"jinrituij"]];
         [_img_userHeader addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)]];
    }
    return _img_userHeader;
}
-(void)singleTapAction:(UIGestureRecognizer *)tap
{
    [self JumpToLogin];
}
-(UIButton *)btn_userName
{
    if (!_btn_userName) {
        _btn_userName=[[UIButton alloc] init];
        _btn_userName.frame=CGRectMake(CGRectGetMaxX(self.img_userHeader.frame)+10, self.img_userHeader.frame.origin.y, 130, 60);
        [_btn_userName setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_btn_userName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn_userName.titleLabel.numberOfLines=2;
        _btn_userName.titleLabel.textAlignment=NSTextAlignmentLeft;
        [_btn_userName addTarget:self action:@selector(JumpToLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_userName;
}
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-(TabBar_HEIGHT*(SCREEN_WIDTH/320))-64)];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
        _mainTableView.showsVerticalScrollIndicator=NO;
        //注册
        [_mainTableView registerClass:[JCMineTableViewCell class] forCellReuseIdentifier:JCMineTableViewCellName];
    }
    return _mainTableView;
}
- (void)didCodeScanOk:(id)info
{
    if([info containsString:@"http"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:info]];
        return;
    }
    else if ([info hasPrefix:@"abd"] ) {
        NSArray *arr = [info componentsSeparatedByString:@","];
        NSString *jfstr = [NSString stringWithFormat:@"商品价值%.2lf分", [arr[2] doubleValue]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扣除积分" message:jfstr preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"submitPointFinish:" setFailBackFunctionName:nil];
            [dataProvider ShopIndexServiceSubmitPointWithShopid:[arr[0] substringFromIndex:3] userid:get_sp(user_ID) priceid:arr[1]];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self presentViewController:alert animated:YES completion:nil];
        });
        return;
        
    }
    else if ([info hasPrefix:@"abc"]) {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扣除积分" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入积分";
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            [textField addTarget:self action:@selector(textFieldEnd:) forControlEvents:UIControlEventEditingDidEnd];
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"submitPointFinish:" setFailBackFunctionName:nil];
            [dataProvider ShopIndexServiceSubmitPointWithShopid:[info substringFromIndex:3] userid:get_sp(user_ID) point:jifen];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self presentViewController:alert animated:YES completion:nil];
        });
    }

    else
    {
        if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
            Index_ShopInfoViewController * index_goodInfoVC=[[Index_ShopInfoViewController alloc] init];
            index_goodInfoVC.shopID=info;
            [self.navigationController pushViewController:index_goodInfoVC animated:YES];
        }
        else
        {
            [self JumpToLogin];
        }
        
    }
}

- (void)textFieldEnd:(UITextField *)sender {
    jifen = sender.text;
}

- (void)submitPointFinish:(NSDictionary *)data {
    if (RequestSuccess(data)) {
        [SVProgressHUD showSuccessWithStatus:@"扣除成功"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [_app_ showTabBar];
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
        [_btn_userName setTitle:ZY_NSStringFromFormat(@"%@\n%@",Zy_JudgeIsNull(get_sp(@"UserName")),Zy_JudgeIsNull(get_sp(@"Name"))) forState:UIControlStateNormal];
        NSString * img_str=[NSString stringWithFormat:@"%@",get_sp(@"PhotoPath")];
        [_img_userHeader sd_setImageWithURL:[NSURL URLWithString:img_str] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
//        _img_userHeader.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_str]]];
    }
    else
    {
        [_btn_userName setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_img_userHeader sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    }
}


@end
