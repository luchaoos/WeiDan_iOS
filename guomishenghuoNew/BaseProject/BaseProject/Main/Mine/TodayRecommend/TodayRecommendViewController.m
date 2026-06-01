//
//  TodayRecommendViewController.m
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "TodayRecommendViewController.h"
#import "TodayRecommendTableViewCell.h"
#import "DataProviderOther.h"
#import "Index_GoodInfoViewController.h"

#define CellHeight 100

@interface TodayRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)UITableView *tableView;

@end

@implementation TodayRecommendViewController
{
    NSArray *hotGoodArray;
    
    int pageNo;
    int pageSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNo=0;
    pageSize=30;
    self.navtitle = @"今日推荐";
    [self addLeftButton:@"fanhui"];
    
    [self createViews];
    
    [self GetHotGood];
}
-(void)GetHotGood
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetHotGoodCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectTodayRecommend:get_sp(@"city_Id") andstartRowIndex:ZY_NSStringFromFormat(@"%d",pageSize*pageNo) andmaximumRows:ZY_NSStringFromFormat(@"%d",pageSize)];
}
-(void)GetHotGoodCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        hotGoodArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate hiddenTabBar];
}

-(void)createViews{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT-Header_Height)];
    //    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}
#pragma mark ----- number of sections and rows -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else{
        if (hotGoodArray) {
            return hotGoodArray.count;
        }
        return 0;
    }
}

#pragma mark ----- heigth for row -----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }
    else{
        return CellHeight;
    }
}

#pragma mark ----- setting for cell -----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 45)];
        tipLbl.text = @"为您准备了如下优惠";
        tipLbl.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:tipLbl];
        
        UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, (45-25)/2, 100, 25)];
        [cityBtn setTitle:[NSString stringWithFormat:@"%@",get_sp(@"city_Name")] forState:UIControlStateNormal];
        [cityBtn setImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateNormal];
        
        cityBtn.backgroundColor = NAVBAR_COLOR;
        cityBtn.layer.cornerRadius = 10;
        cityBtn.layer.masksToBounds = YES;
        cityBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [cell.contentView addSubview:cityBtn];
        
        return cell;
    }
    else{
        
        NSDictionary * itemdict=hotGoodArray[indexPath.row];
        static NSString *identifier = @"cell";
        
        TodayRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TodayRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.goodName.text=itemdict[@"Name"];
        [cell.goodImage sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,itemdict[@"ImagePath"])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
        cell.goodPrice.text=[NSString stringWithFormat:@"￥%@",itemdict[@"Price"]];
        cell.goodPrice.font=[UIFont systemFontOfSize:14];
        cell.goodDistance.hidden=YES;
        cell.goodDetail.hidden=YES;
        cell.goodDiscount.hidden=YES;
        cell.goodType.hidden=YES;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return;
    }
    Index_GoodInfoViewController * goodInfoVC=[[Index_GoodInfoViewController alloc] init];
    goodInfoVC.goodID=hotGoodArray[indexPath.row][@"Id"];
    [self.navigationController pushViewController:goodInfoVC animated:YES];
}

//Setup your cell margins:
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
