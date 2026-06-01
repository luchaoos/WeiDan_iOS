//
//  SearchResultViewController.m
//  LikeAttention
//
//  Created by 王建成 on 15/11/20.
//  Copyright © 2015年 zykj.LikeAttention. All rights reserved.
//

#import "SearchResultViewController.h"
#import "DataProviderOther.h"
#import "LoginViewController.h"
#import "Index_GoodInfoViewController.h"
#import "Index_ShopInfoViewController.h"

@interface SearchResultViewController ()
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

@implementation SearchResultViewController

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
    if (self.type==1) {
        DataProviderOther * dataprovider=[[DataProviderOther alloc] init];
        [dataprovider setDelegateObject:self setSucceedBackFunctionName:@"GetSearchResultCallBack:" setFailBackFunctionName:nil];
        [dataprovider SearchWithRowIndex:ZY_NSStringFromFormat(@"%d",pageSize*page) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:self.keyWorld andcategoryid:@"0" andlength:@"1000000" andorder:@"0" andareaid:get_sp(@"city_Id") andisallcity:@"1"  andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
    }
    else
    {
        DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
        [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetSearchResultCallBack:" setFailBackFunctionName:nil];
        [dataproviderother SelectShopIndexNewRowIndex:ZY_NSStringFromFormat(@"%d",(pageSize*page)) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize) andsearch:self.keyWorld andcategoryid:@"0" andlength:@"1000000" andorder:@"0" andareaid:get_sp(@"city_Id")  andisallcity:@"1" andlat:get_sp(@"location_lat") andlng:get_sp(@"location_lng")];
    }
    
    _cellCount = 1;
  //  _sectionCount = 1;
    
    if(_resultArr!=nil)
    {
        _sectionCount = _resultArr.count;
    }
    _cellheight = 85;
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
   
    if([self.deleagate respondsToSelector:@selector(backToSearch)])
    {
        [self.deleagate backToSearch];
    }
}



-(void)setResultArr:(NSArray *)resultArr
{
    _resultArr = resultArr;
    
    if(_resultArr.count == 0)
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
        _sectionCount = _resultArr.count;
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
    
    if(indexPath.row  == 0)
    {
        SellerCell *cell = [SellerCell cellWithTableView:tableView];
        if (shopList) {
           
            if (self.type==1) {
                [cell.logoView sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,shopList[indexPath.section][@"ImagePath"])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                cell.nameLabel.text=shopList[indexPath.section][@"Name"];
                cell.price.text=[NSString stringWithFormat:@"￥%@",shopList[indexPath.section][@"Price"]];
                cell.distance.text=[NSString stringWithFormat:@"%.2fkm",[shopList[indexPath.section][@"Length"] floatValue]];
                cell.other.text=shopList[indexPath.section][@"CategoryName"];
                cell.dress.text=@"";
                cell.score.text=ZY_NSStringFromFormat(@"已售:%@",Zy_JudgeIsNull(shopList[indexPath.section][@"SeleNum"]));
                CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,80,12) numberOfStars:5];
                weisheng.scorePercent = [shopList[indexPath.section][@"AvgScore"] floatValue]/5;
                weisheng.allowIncompleteStar = NO;
                weisheng.hasAnimation = YES;
                [cell.starView addSubview:weisheng];
                cell.price.textColor=[UIColor redColor];
                cell.dress.textColor=[UIColor redColor];
            }
            else
            {
                [cell.logoView sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,shopList[indexPath.section][@"PhotoPath"])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
                cell.nameLabel.text=shopList[indexPath.section][@"Name"];
                cell.score.text=[NSString stringWithFormat:@"人均%@", Zy_JudgeIsNull(shopList[indexPath.section][@"RenJun"])];
                cell.price.text=ZY_NSStringFromFormat(@"已售%@",shopList[indexPath.section][@"SeleNum"]);
                cell.distance.text=[NSString stringWithFormat:@"%.2fkm",[shopList[indexPath.section][@"Length"] floatValue]];
                cell.other.text=shopList[indexPath.section][@"CategoryName"];
                cell.dress.text=@"";
                CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(0,4,80,12) numberOfStars:5];
                weisheng.scorePercent = [shopList[indexPath.section][@"AvgScore"] floatValue]/5;
                weisheng.allowIncompleteStar = NO;
                weisheng.hasAnimation = YES;
                [cell.starView addSubview:weisheng];
                cell.price.textColor=[UIColor redColor];
                cell.dress.textColor=[UIColor redColor];
            }
        }
        
        return cell;
    }
    else
    {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,_cellheight)];
       // cell.backgroundColor = [UIColor redColor];
        
        @try {
            NSDictionary *tempDict = self.resultArr[indexPath.section][@"goodList"][indexPath.row - 1];
            UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 50, 30)];
            priceLab.text = [NSString stringWithFormat:@"¥%.1f",(float)[tempDict[@"price"] integerValue]];
            priceLab.textColor = [UIColor orangeColor];
            priceLab.font = [UIFont systemFontOfSize:16];
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(priceLab.frame.origin.x+priceLab.frame.size.width + 10, 10, 200, 30)];
            nameLab.text = tempDict[@"name"];
            nameLab.font = [UIFont systemFontOfSize:16];
            
            UILabel *payNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 -10, _cellheight -10 -20, 50, 20)];
            payNum.text = [NSString stringWithFormat:@"已售%@",tempDict[@"paynum"]];
            payNum.font = [UIFont systemFontOfSize:14];
            
            
            [cell addSubview:priceLab];
            [cell addSubview:nameLab];
            [cell addSubview:payNum];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

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
    if (self.type==1) {
        Index_GoodInfoViewController * index_goodInfoVC=[[Index_GoodInfoViewController alloc] init];
        index_goodInfoVC.goodID=shopList[indexPath.section][@"Id"];
        [self.navigationController pushViewController:index_goodInfoVC animated:YES];
    }
    else
    {
        Index_ShopInfoViewController *index_shopInfoVC=[[Index_ShopInfoViewController alloc] init];
        index_shopInfoVC.shopID=shopList[indexPath.section][@"Id"];
        [self.navigationController pushViewController:index_shopInfoVC animated:YES];
    }
    
    
    
//    if(indexPath.row  == 0)
//    {
//
//        @try {
////            NSDictionary *tempDict = self.resultArr[indexPath.section];
//            
////            ShopInfoViewController *shopInfoViewCtl = [[ShopInfoViewController alloc] init];
////            shopInfoViewCtl.merchantid = tempDict[@"id"];
////            [self.navigationController pushViewController:shopInfoViewCtl animated:YES];
//            
//           
//        }
//        @catch (NSException *exception) {
//            
//        }
//        @finally {
//           
//        }
//        
//        
//    }
//    else
//    {
//        @try {
////            NSDictionary *tempDict = self.resultArr[indexPath.section][@"goodList"][indexPath.row - 1];
////            GoodsInfoViewController *goodInfoViewCtl = [[GoodsInfoViewController alloc ] init];
////            goodInfoViewCtl.goodID = tempDict[@"id"];
////            [self.navigationController pushViewController:goodInfoViewCtl animated:YES];
//
//        }
//        @catch (NSException *exception) {
//            
//        }
//        @finally {
//            
//        }
    
//    }
    
    
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
