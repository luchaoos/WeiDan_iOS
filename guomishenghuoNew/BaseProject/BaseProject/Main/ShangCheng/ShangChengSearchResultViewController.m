//
//  ShangChengSearchResultViewController.m
//  BaseProject
//
//  Created by 于金祥 on 17/4/10.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "ShangChengSearchResultViewController.h"
#import "DataProviderOther.h"
#import "GoodDetialViewController.h"
#import "LoginViewController.h"


@interface ShangChengSearchResultViewController ()
{
    // define for views
    UITableView *_mainTableView;
    
    //set for views
    NSInteger _cellCount;
    NSInteger _sectionCount;
    CGFloat _cellheight;
    CGFloat _SectionHeaderHeight;
    
    NSInteger page;
    NSInteger pageSize;
    
    NSArray * shopList;
}
@end

@implementation ShangChengSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageSize=100;
    page=0;
    
    [self initDatas];
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void) initDatas
{
        DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
        [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetSearchResultCallBack:" setFailBackFunctionName:nil];
    [dataproviderother JifenSearchWithstartRowIndex:ZY_NSStringFromFormat(@"%d",(pageSize*page)) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:self.keyWorld andareaid:get_sp(@"city_Id")];
    
    _cellCount = 1;
    
    _cellheight = SCREEN_WIDTH*0.5+40;
    _SectionHeaderHeight = 0;
}
-(void)GetSearchResultCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        shopList=[[NSArray alloc] initWithArray:dict[@"data"]];
        if (shopList.count>0) {
            [_mainTableView reloadData];
        }
        else
        {
            [YJXStatusHUD showError:@"抱歉,未搜索到任何数据"];
        }
        
    }
}

-(void) initViews
{
    
    _lblTitle.text = @"搜索结果";
    
    //    [self addLeftButton:@"Icon_Back@2x.png"];
    
    _mainTableView = [[UITableView alloc ] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT - 64 )];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    
    //_mainTableView.separatorColor =  [UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        //设置cell分割线从最左边开始
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    
    [self.view addSubview:_mainTableView];
}

#pragma mark - 重写父类
- (void)clickLeftButton:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)setResultArr:(NSArray *)resultArr
{
    
    if(shopList.count == 0)
    {
        [_mainTableView removeFromSuperview];
        
        UILabel *tempLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 64 + 50, SCREEN_WIDTH - 40*2, 40)];
        tempLab.text = @"#_# 木找着～～";
        tempLab.numberOfLines = 0;
        tempLab.font = [UIFont boldSystemFontOfSize:20];
        tempLab.textAlignment = NSTextAlignmentCenter;
        
        tempLab.textColor = [UIColor grayColor];
        [self.view addSubview:tempLab];
    }
    else
    {
        _sectionCount = shopList.count;
        [_mainTableView reloadData];
    }
}


#pragma mark - setting for cell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (shopList) {
        return shopList.count;
    }
    return _sectionCount;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    @try {
    //        if (self.resultArr == nil || self.resultArr.count == 0 ||self.resultArr.count - 1 <  section) {
    //            return _cellCount;
    //        }
    //        NSArray *tempGoodList = self.resultArr[section][@"goodList"];
    //
    //        _cellCount =tempGoodList.count + 1 ;
    //        return _cellCount;
    //    }
    //    @catch (NSException *exception) {
    //
    //    }
    //    @finally {
    //        return _cellCount;
    //    }
    
    
    return 1;
}

//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell;
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,_cellheight)];
        // cell.backgroundColor = [UIColor redColor];
        
        @try {
//            for (NSDictionary * itemdict in shopList) {
            NSDictionary * itemdict=shopList[indexPath.section];
                UIButton * btn_item=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.5)];
                [btn_item sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImgUrl,itemdict[@"ImagePath"]]] forState:UIControlStateNormal placeholderImage:img(@"placeHolderlong")];
                btn_item.tag=[itemdict[@"Id"] integerValue];
                [btn_item addTarget:self action:@selector(GoodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn_item];
                UIView * V_bottom=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn_item.frame), SCREEN_WIDTH, 40)];
                V_bottom.backgroundColor=[UIColor whiteColor];
                UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-40, 40)];
                lbl_title.numberOfLines=2;
                lbl_title.text=ZY_NSStringFromFormat(@"%@\n￥%@",itemdict[@"Name"],itemdict[@"Price"]);
                lbl_title.font=[UIFont systemFontOfSize:14];
                [V_bottom addSubview:lbl_title];
                UIButton * btn_share=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl_title.frame), 5, 30, 30)];
                [btn_share setImage:[UIImage imageNamed:@"fenxiang-1"] forState:UIControlStateNormal];
                [btn_share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
//                [V_bottom addSubview:btn_share];
                [cell.contentView addSubview:V_bottom];
//            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return _cellheight;//一定要和collection view的高度匹配否则会显示不出来
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    GoodDetialViewController * goodDetialVC=[[GoodDetialViewController alloc] init];
    goodDetialVC.goodId=shopList[indexPath.section][@"Id"];
    [self.navigationController pushViewController:goodDetialVC animated:YES];
    
}

-(void)GoodButtonClick:(UIButton *)sender
{
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    GoodDetialViewController * goodDetialVC=[[GoodDetialViewController alloc] init];
    goodDetialVC.goodId=ZY_NSStringFromFormat(@"%d",sender.tag);
    [self.navigationController pushViewController:goodDetialVC animated:YES];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1)); //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, 10, 100, 10));
}


//设置划动cell是否出现del按钮，可供删除数据里进行处理

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//设置选中的行所执行的动作

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath;
    
}

#pragma mark - setting for section
//设置section的header view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _SectionHeaderHeight)];
    return headView;
}

//设置section的footer view
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];;
    tempView.backgroundColor = UIColorFromRGBValue(0xeeeeee);
    
    return tempView;
    
}


//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _SectionHeaderHeight;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 10;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [_app_ hiddenTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
