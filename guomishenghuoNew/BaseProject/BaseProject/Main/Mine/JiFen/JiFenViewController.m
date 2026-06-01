//
//  JiFenViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "JiFenViewController.h"
#import "JiFenGetRecordViewController.h"
#import "DataProviderOther.h"

@interface JiFenViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * mainTableView;
@property (nonatomic,strong)UIImageView *img_icon;
@property (nonatomic,strong)UIButton * lbl_Myyue;

@end

@implementation JiFenViewController
{
    UILabel * lbl_jifenDetial;
    int pageNo;
    int pageSize;
    NSArray * jifenListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNo=0;
    pageSize=10;
    _lblTitle.text=@"我的购物券";
    [self addLeftButton:@"fanhui"];
//    [self addRightbuttontitle:@"获取记录"];
    [self BuildTableviewHeader];
    [self.view addSubview:self.mainTableView];
}

-(void)GetMyJifen
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetMyJifenCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andtype:@"8"];
}

-(void)GetMyJifenCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        jifenListArray=[[NSArray alloc] initWithArray:dict[@"data"][@"List"]];
        lbl_jifenDetial.text=ZY_NSStringFromFormat(@"%.2f",[dict[@"data"][@"TotalPoint"] floatValue]);
        
        NSString *str1 = @"      我的米币";
        NSString *str2 = ZY_NSStringFromFormat(@" %.2f",[dict[@"data"][@"TotalPoint"] floatValue]);
        NSString *string = [NSString stringWithFormat:@"%@\n%@",str1,str2];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8.0;
        NSDictionary *attrsDictionary1 = @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                           NSParagraphStyleAttributeName:paragraphStyle};
        NSDictionary *attrsDictionary2 = @{NSFontAttributeName:[UIFont systemFontOfSize:40],
                                           NSParagraphStyleAttributeName:paragraphStyle};
        //给str1添加属性
        [attributedString addAttributes:attrsDictionary1 range:NSMakeRange(0, str1.length)];
        //给str2设置
        [attributedString addAttributes:attrsDictionary2 range:NSMakeRange(str1.length, str2.length+1)];
        
        [self.lbl_Myyue setAttributedTitle:attributedString forState:UIControlStateNormal];
        
        
        [self.mainTableView reloadData];
        pageNo++;
    }
}
-(void)GetMyJifen1
{
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetMyJifen1CallBack:" setFailBackFunctionName:nil];
    [dataproviderOther SelectAllWalletDetailWithstartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andmaximumRows:[NSString stringWithFormat:@"%d",pageSize] andtype:@"8"];
}

-(void)GetMyJifen1CallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        NSMutableArray * itemMutablearray=[[NSMutableArray alloc] initWithArray:jifenListArray];
        for (NSDictionary * itemdict in dict[@"data"][@"List"]) {
            [itemMutablearray addObject:itemdict];
        }
        jifenListArray=[[NSArray alloc] initWithArray:itemMutablearray];
        [self.mainTableView reloadData];
        pageNo++;
    }
}
-(void)BuildTableviewHeader
{
    UIView * tableVeiwHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH/4+130)];
    tableVeiwHeaderView.backgroundColor=[UIColor whiteColor];
//    UILabel * lbl_jifenNow=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH*0.5, tableVeiwHeaderView.frame.size.height)];
//    lbl_jifenNow.font=[UIFont systemFontOfSize:17];
//    lbl_jifenNow.text=@"当前购物券";
//    [tableVeiwHeaderView addSubview:lbl_jifenNow];
////    NSString * str_jifen=@"1000";
//    lbl_jifenDetial=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, tableVeiwHeaderView.frame.size.height)];
//    lbl_jifenDetial.text=@"1000";
//    [tableVeiwHeaderView addSubview:lbl_jifenDetial];
//    UIImageView * img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_jifenDetial.frame.origin.x-25, (44-25)/2, 25, 25)];
//    img_icon.image=[UIImage imageNamed:@"wodejifen"];
//    [tableVeiwHeaderView addSubview:img_icon];
    [tableVeiwHeaderView addSubview:self.img_icon];
    [tableVeiwHeaderView addSubview:self.lbl_Myyue];
    
    self.mainTableView.tableHeaderView=tableVeiwHeaderView;
//    [self.view addSubview:tableVeiwHeaderView];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"收支明细";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (jifenListArray) {
        return jifenListArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *itemDict=[[NSDictionary alloc] initWithDictionary:jifenListArray[indexPath.row]];
    UILabel * lbl_left=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, (SCREEN_WIDTH-30)/2, 60)];
    lbl_left.text=[NSString stringWithFormat:@"%@\n购物券:",itemDict[@"Description"]];
    lbl_left.numberOfLines=2;
    [cell.contentView addSubview:lbl_left];
    
    UILabel * lbl_right=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl_left.frame), 0, (SCREEN_WIDTH-30)/2, 60)];
    
    lbl_right.font=[UIFont systemFontOfSize:16];
    NSString * time=[NSString stringWithFormat:@"%@",itemDict[@"OperateTime"]];
    NSString * itemStr=@"";
    if ([itemDict[@"Type"] integerValue]==1||[itemDict[@"Type"] integerValue]==3||[itemDict[@"Type"] integerValue]==5) {
        itemStr =[NSString stringWithFormat:@"%@\n+%.2f",[time length]>10?[time substringToIndex:10]:@"",[itemDict[@"Amount"] floatValue]];
    }
    else
    {
        itemStr =[NSString stringWithFormat:@"%@\n-%.2f",[time length]>10?[time substringToIndex:10]:@"",[itemDict[@"Amount"] floatValue]];
    }
    lbl_right.text=itemStr;
    lbl_right.textAlignment=NSTextAlignmentRight;
    lbl_right.numberOfLines=2;
    [cell.contentView addSubview:lbl_right];
    return cell;
}


-(void)clickRightButton:(UIButton *)sender{
//    JiFenGetRecordViewController *jifenGetVC = [[JiFenGetRecordViewController alloc] init];
//    [self.navigationController pushViewController:jifenGetVC animated:YES];
}






-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
        
        __unsafe_unretained __typeof(self) weakSelf = self;
//        _mainTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//            [_mainTableView.mj_footer setState:MJRefreshStateIdle];
//            pageNo = 0;
//            [weakSelf GetMyJifen];
//        
//        }];
//        [_mainTableView.mj_header beginRefreshing];
        
        // 上拉刷新
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf GetMyJifen1];
        }];
        
    }
    return _mainTableView;
}

-(UIImageView *)img_icon
{
    if (!_img_icon) {
        _img_icon=[[UIImageView alloc] init];
        _img_icon.bounds=CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        _img_icon.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_WIDTH/8+10);
        _img_icon.image=img(@"guomibi");
    }
    return _img_icon;
}
-(UIButton *)lbl_Myyue
{
    if (!_lbl_Myyue) {
        _lbl_Myyue=[[UIButton alloc] init];
        _lbl_Myyue.frame=CGRectMake(0, CGRectGetMaxY(self.img_icon.frame)+10, SCREEN_WIDTH, 100);
        _lbl_Myyue.titleLabel.numberOfLines=2;
        //        _lbl_Myyue.textAlignment=NSTextAlignmentCenter;
    }
    return _lbl_Myyue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self GetMyJifen];
    [_app_ hiddenTabBar];
}

@end
