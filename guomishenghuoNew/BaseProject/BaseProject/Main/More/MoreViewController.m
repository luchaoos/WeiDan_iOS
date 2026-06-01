//
//  MoreViewController.m
//  LikeAttention
//
//  Created by 于金祥 on 15/8/5.
//  Copyright (c) 2015年 zykj.LikeAttention. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"
#import "AdviceSubmitViewController.h"
//#import "LoginViewController.h"
#import "WebVCViewController.h"
#import "AboutUsViewController.h"
//#import "DataProvider.h"
#import "MyBuyerViewController.h"
#import "CooperationFirstViewController.h"

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@end

@implementation MoreViewController
{
    NSString * telPhone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"更多";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandelNotice) name:@"HandelNotice" object:nil];
//    _imgLeft.hidden=YES;
    telPhone=@"";
    _myTableview.delegate=self;
    _myTableview.dataSource=self;
    
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [self exitUserInfo];
}
-(void)HandelNotice
{
    [self.myTableview reloadData];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HandelNotice" object:nil];
//}

#pragma mark 界面初始化
/*****************************************tableview开始*************************************************/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * myview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    myview.backgroundColor=BACKGROUND_COLOR;
    return myview;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        
        CooperationFirstViewController *cooperationFirstVC = [[CooperationFirstViewController alloc] init];
        [self.navigationController pushViewController:cooperationFirstVC animated:YES];
    }else if(indexPath.section == 0 && indexPath.row == 1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"是否清理缓存？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = 1011;
        [alertView show];
    }else if (indexPath.section==0&&indexPath.row==2) {
        
        AboutUsViewController * aboutusVC=[[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:[NSBundle mainBundle]];
        
        [self.navigationController pushViewController:aboutusVC animated:YES];
    }
    
    if (indexPath.section==0&&indexPath.row==3) {
        WebVCViewController * webVC=[[WebVCViewController alloc] initWithNibName:@"WebVCViewController" bundle:[NSBundle mainBundle]];
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
//        CommonProblemsViewController *commonProblemsVC = [[CommonProblemsViewController alloc] init];
//        [self.navigationController pushViewController:commonProblemsVC animated:YES];
    }
//    if (indexPath.section==1&&indexPath.row==1) {
    
//    }
//    if (indexPath.section==2&&indexPath.row==2) {
//        
////        [SVProgressHUD showWithStatus:@"正在拨打..." maskType:SVProgressHUDMaskTypeBlack];
////        DataProvider * dataprovider=[[DataProvider alloc] init];
////        
////        [dataprovider setDelegateObject:self setBackFunctionName:@"GetAppPhoneCallBack:"];
////        
////        [dataprovider AppPhone];
//    }
//    if(indexPath.section == 3)
//    {
//        MyBuyerViewController * myBuyerViewController = [[MyBuyerViewController alloc] init];
//        
//        [self showViewController:myBuyerViewController sender:nil];
//    }
//    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//-(void)clearCache{
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"exit_Success" object:nil];
//    [SVProgressHUD showSuccessWithStatus:@"清空内存成功~" maskType:SVProgressHUDMaskTypeBlack];
//}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 1011) {
        [self clearCache];
        
    }
    if (buttonIndex==1&&telPhone.length>0&&alertView.tag == 1012) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telPhone]]];
    }
}
//清理缓存
-(void) clearCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess)
                                              withObject:nil waitUntilDone:YES];});
}

-(void)clearCacheSuccess
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"缓存清理成功！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil, nil];
//    alertView.tag=1;
//    [alertView show];
    
    [SVProgressHUD showSuccessWithStatus:@"缓存清理成功" maskType:(SVProgressHUDMaskTypeBlack)];
    
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=44;
    if (indexPath.section==((get_sp(isLogin) !=nil&&[get_sp(isLogin) isEqualToString:@"YES"])?2:1)) {
        height=60;
    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"我要合作";
                break;
            case 1:
                cell.textLabel.text=@"清空缓存";
                break;
            case 2:
                cell.textLabel.text=@"关于果米";
                break;
            case 3:
                cell.textLabel.text=@"第三方协议声明";
                break;
                
            default:
                break;
        }
    }
    if (get_sp(isLogin) !=nil&&[get_sp(isLogin) isEqualToString:@"YES"]) {
        if(indexPath.section==1)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;//cell没有任何的样式
            cell.backgroundColor=BACKGROUND_COLOR;
            UIButton * btn_exit=[[UIButton alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, cell.frame.size.height)];
            [btn_exit setTitle:@"退出当前账号" forState:UIControlStateNormal];
            [btn_exit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn_exit.backgroundColor=[UIColor colorWithRed:237/255.0 green:109/255.0 blue:3/255.0 alpha:1.0];
            btn_exit.layer.masksToBounds=YES;
            [btn_exit addTarget:self action:@selector(exitUserInfo) forControlEvents:UIControlEventTouchUpInside];
            btn_exit.layer.cornerRadius=5;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:btn_exit];
        }
    }
    if(indexPath.section==((get_sp(isLogin) !=nil&&[get_sp(isLogin) isEqualToString:@"YES"])?2:1))
    {
        cell.accessoryType = UITableViewCellAccessoryNone;//cell没有任何的样式
        UIView * BackView_exit=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
        BackView_exit.backgroundColor=BACKGROUND_COLOR;
        UILabel * lbl_banquan=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 20)];
        lbl_banquan.text=@"Coryright©2015-2018";
        [lbl_banquan setTextAlignment:NSTextAlignmentCenter];
        lbl_banquan.font=[UIFont fontWithName:@"Helvetica" size:12];
        lbl_banquan.textColor=[UIColor grayColor];
        [BackView_exit addSubview:lbl_banquan];
        UILabel * lbl_banquan1=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lbl_banquan.frame)+10, tableView.frame.size.width, 20)];
        lbl_banquan1.text=@"山东果米网络科技有限公司";
        [lbl_banquan1 setTextAlignment:NSTextAlignmentCenter];
        lbl_banquan1.font=[UIFont fontWithName:@"Helvetica" size:12];
        lbl_banquan1.textColor=[UIColor grayColor];
        [BackView_exit addSubview:lbl_banquan1];
        [cell addSubview:BackView_exit];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }
    return 1;
//    }
//    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (get_sp(isLogin) !=nil&&[get_sp(isLogin) isEqualToString:@"YES"])?3:2;
}
/*****************************************tableview结束*************************************************/










#pragma mark 动作操作

-(void)exitUserInfo
{
    if (get_sp(isLogin) !=nil&&[get_sp(isLogin) isEqualToString:@"YES"]) {
        NSUserDefaults * userdefault=[NSUserDefaults standardUserDefaults];
        
//        [SVProgressHUD showSuccessWithStatus:@"退出成功" maskType:(SVProgressHUDMaskTypeBlack)];
        set_sp(isLogin, @"NO");
        [userdefault removeObjectForKey:user_ID];
        [userdefault removeObjectForKey:@"UserName"];
        [userdefault removeObjectForKey:@"PhotoPath"];
        [userdefault removeObjectForKey:@"Phone"];
//        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
        [self.myTableview reloadData];
        [YJXStatusHUD showSuccess:@"退出成功"];
    }
    
    
//    if([[userdefault objectForKey:@"id"] length] != 0)
//    {
//        [SVProgressHUD showSuccessWithStatus:@"退出成功" maskType:(SVProgressHUDMaskTypeBlack)];
//        
//        [userdefault removeObjectForKey:@"id"];
//        [userdefault removeObjectForKey:@"address"];
//        [userdefault removeObjectForKey:@"birthday"];
//        [userdefault removeObjectForKey:@"blog"];
//        [userdefault removeObjectForKey:@"headportain"];
//        [userdefault removeObjectForKey:@"invitecode"];
//        [userdefault removeObjectForKey:@"mobile"];
//        [userdefault removeObjectForKey:@"name"];
//        [userdefault removeObjectForKey:@"qq"];
//        [userdefault removeObjectForKey:@"receiveaddress"];
//        [userdefault removeObjectForKey:@"sex"];
//        [userdefault removeObjectForKey:@"sign"];
//        [userdefault removeObjectForKey:@"weixin"];
//        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
//    else
//    {
//        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
}

-(void)GetAppPhoneCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    if ([dict[@"status"][@"succeed"] intValue]==1) {
        telPhone=[NSString stringWithFormat:@"%@",[dict[@"data"][@"telephone"] isEqual:[NSNull null]]?@"":dict[@"data"][@"telephone"]];
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[dict[@"data"][@"telephone"] isEqual:[NSNull null]]?@"":dict[@"data"][@"telephone"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        
        alert.tag=1012;
        
        [alert show];
    }
}





#pragma mark 数据请求










#pragma mark 构造参数操作









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


@end
