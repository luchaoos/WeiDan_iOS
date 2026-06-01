//
//  SearchViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/7/7.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "SearchViewController.h"
//#import "OldAddressTableViewCell.h"
#import "HXTagsView.h"
#import "DataProviderOther.h"
#import "SearchResultViewController.h"
#import "ShangChengSearchResultViewController.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,HXTagsViewDelegate,SearchResultDeleagate,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView * mainTableView;
@property (nonatomic,strong)UITextField * txt_search;
@property (nonatomic,strong)HXTagsView *tagsView;

@end

@implementation SearchViewController
{
    NSArray * good_Array;
    
    NSMutableArray * hissearchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (get_sp(@"searchHistory")==nil) {
        NSMutableArray *searchHistoryArray=[[NSMutableArray alloc] init];
        set_sp(@"searchHistory", searchHistoryArray);
    }
    hissearchArray=[[NSMutableArray alloc] initWithArray:get_sp(@"searchHistory")];
    [self initViews];
    DataProviderOther * mainRequest=[[DataProviderOther alloc] init];
    [mainRequest setDelegateObject:self setSucceedBackFunctionName:@"GetHotProductListCallBack:" setFailBackFunctionName:nil];
    [mainRequest HotSearch];
}
-(void)GetHotProductListCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        good_Array=[[NSArray alloc] initWithArray:dict[@"data"]];
        
        NSMutableArray * itemarray=[[NSMutableArray alloc] init];
        for (NSDictionary * dic in good_Array) {
            [itemarray addObject:dic[@"Name"]];
        }
        
        _tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _tagsView.type = 0;
        _tagsView.tagHeight=30;
        _tagsView.masksToBounds=YES;
        _tagsView.cornerRadius=15;
        //    _tagsView
        [_tagsView setTagAry:itemarray delegate:self];
        
        [self.mainTableView reloadData];
    }
}





-(void)initViews
{
    [self addLeftButton:@"fanhui"];
    self.view.backgroundColor=RGB(239, 239, 239);
    [_topView addSubview:self.txt_search];
    [self addRightbuttontitle:@"搜索"];
    
    
    
    
    
    
    
    [self.view addSubview:self.mainTableView];
}

-(void)clickRightButton:(UIButton *)sender{
    if (self.txt_search.text.length>0) {
        if (self.type==3) {
            ShangChengSearchResultViewController * shangchengsearchVC=[[ShangChengSearchResultViewController alloc] init];
            shangchengsearchVC .keyWorld=_txt_search.text;
            [self.navigationController pushViewController:shangchengsearchVC animated:YES];
            return;
        }
        SearchResultViewController *searchResult = [[SearchResultViewController alloc] init];
//        searchResult.resultArr = dict[@"data"];
        searchResult.keyWorld=_txt_search.text;
        searchResult.type=self.type;
        searchResult.deleagate = self;
        [self.navigationController pushViewController:searchResult animated:YES];
        
        if (get_sp(@"searchHistory")==nil) {
            NSMutableArray *searchHistoryArray=[[NSMutableArray alloc] init];
            
            set_sp(@"searchHistory", searchHistoryArray);
            //CatePageViewController * catepageVC=[[CatePageViewController alloc] init];
            //catepageVC.keyWorld=self.txt_search.text;
            //[self showViewController:catepageVC sender:nil];
        }
        else
        {
            [hissearchArray addObject:self.txt_search.text];
            set_sp(@"searchHistory", hissearchArray);
//            CatePageViewController * catepageVC=[[CatePageViewController alloc] init];
//            catepageVC.navtitle=@"商品";
//            catepageVC.keyWorld=self.txt_search.text;
//            [self showViewController:catepageVC sender:nil];
        }
    }
    else
    {
//        [YJXStatusHUD showError:@"请填写搜索关键词"];
    }
}


#pragma mark 标签代理
/**
 *  tagsView代理方法
 *
 *  @param tagsView tagsView
 *  @param sender   tag:sender.titleLabel.text index:sender.tag
 */
- (void)tagsViewButtonAction:(HXTagsView *)tagsView button:(UIButton *)sender {
    NSLog(@"tag:%@ -->index:%ld",sender.titleLabel.text,(long)sender.tag);
//    CatePageViewController * catepageVC=[[CatePageViewController alloc] init];
//    catepageVC.keyWorld=sender.titleLabel.text;
//    catepageVC.navtitle=@"商品";
//    [self showViewController:catepageVC sender:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return hissearchArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        sectionHeaderView.backgroundColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0];
        UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
        lbl_title.text=@"历史搜索";
        [sectionHeaderView addSubview:lbl_title];
        UIButton * btn_clearn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 0, 80, 30)];
        [btn_clearn setTitle:@"清除" forState:UIControlStateNormal];
        [btn_clearn addTarget:self action:@selector(OldClearn) forControlEvents:UIControlEventTouchUpInside];
        [btn_clearn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sectionHeaderView addSubview:btn_clearn];
        return sectionHeaderView;
    }
     UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    sectionHeaderView.backgroundColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    lbl_title.text=@"热门搜索";
    [sectionHeaderView addSubview:lbl_title];
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%ld",(long)indexPath.row]];
    
    if (indexPath.section==0) {
        if(self.tagsView!=nil)
        {
            [cell.contentView addSubview:self.tagsView];
        }
        return cell;
    }
    
    
    cell.imageView.image=img(@"dingwei");
    cell.textLabel.text=[NSString stringWithFormat:@"%@",hissearchArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    CatePageViewController * catepageVC=[[CatePageViewController alloc] init];
//    catepageVC.keyWorld=hissearchArray[indexPath.row];
//    catepageVC.navtitle=@"商品";
//    [self showViewController:catepageVC sender:nil];
    SearchResultViewController *searchResult = [[SearchResultViewController alloc] init];
    //        searchResult.resultArr = dict[@"data"];
    searchResult.keyWorld=hissearchArray[indexPath.row];
    searchResult.deleagate = self;
    searchResult.type=self.type;
    [self.navigationController pushViewController:searchResult animated:YES];
}

-(void)OldClearn
{
    if (hissearchArray.count>0) {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"" message:@"确认清除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        hissearchArray=[[NSMutableArray alloc] init];
        set_sp(@"searchHistory", hissearchArray);
        [YJXStatusHUD showSuccess:@"清除成功"];
        [self.mainTableView reloadData];
    }
}

-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
        _mainTableView.dataSource=self;
        _mainTableView.delegate=self;
//        [_mainTableView registerClass:[OldAddressTableViewCell class] forCellReuseIdentifier:@"local_Old_address"];
        [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    return _mainTableView;
}

#pragma mark 初始化控件
-(UITextField *)txt_search
{
    if (!_txt_search) {
        _txt_search=[[UITextField alloc] init];
        _txt_search.center=CGPointMake(_topView.frame.size.width/2, 42);
        _txt_search.bounds=CGRectMake(0, 0, 200*(SCREEN_WIDTH/320), 30);
        _txt_search.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:0.5];
        _txt_search.font=[UIFont systemFontOfSize:15];
        _txt_search.layer.masksToBounds=YES;
        _txt_search.layer.cornerRadius=15;
        UIView * leftview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        
        UIImageView * img_left=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuo"]];
        img_left.frame=CGRectMake(5, 0, 20, 20);
        [leftview addSubview:img_left];
        _txt_search.leftViewMode=UITextFieldViewModeAlways;
        _txt_search.leftView =leftview;
        _txt_search.textColor=[UIColor whiteColor];
        
    }
    return _txt_search;
}


-(void)viewDidAppear:(BOOL)animated
{
    [_app_ hiddenTabBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
