//
//  ShopDetialViewController.m
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/4/25.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "ShopDetialViewController.h"
#import "CCTableView.h"
#import "TakeOutModel.h"
#import "ShoppingCarCellTableViewCell.h"
#import "VOSegmentedControl.h"
#import "ShopDetialPingJiaTableViewCell.h"
#import "ShopDetialPingJiaCellModel.h"
#import "HXTagsView.h"
#import "JCMineTableViewCell.h"
#import "DataProviderOther.h"
#import "GoodDetialViewController.h"
#import "JSONKit.h"
#import "SubmitJiFenOrderViewController.h"
#import "LoginViewController.h"


#define _ShopingCartCELLHEIGHT   44

@interface ShopDetialViewController ()<UITableViewDelegate,UITableViewDataSource,HXTagsViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet CCTableView *cctableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonnull,strong)NSMutableArray *orderArray;


//评价tb
@property (nonatomic,strong)UITableView * tb_PingJia;
@property (nonatomic,strong)NSMutableArray *pingjiaDataArray;
@property (nonatomic,strong)HXTagsView *tagsView;



@property(nonatomic ) NSArray *shopingCartArr;//购物车



@end

@implementation ShopDetialViewController
{
    UIImageView * img_backGround;
    
    VOSegmentedControl *segctrl1;
    
    BOOL isbottomviewshow;
    BOOL isshoppingCarShow;
    UIButton * btn_showORHide;
    UILabel * lbl_titleprice;
    UIButton * btn_zhezhao;
    
    NSInteger witchTb;//主tableview加载哪个tableview  0：点菜  1：评价
    
    CGFloat lastContentOffset;
    
    BOOL isLoading;
    
    UIView * bottomview_backview;
    
    NSInteger oldSegmentIndex;
    
    NSArray * diancaiArray;
    
    NSString * zonghepingfen;
    
    NSInteger pageNo;
    
    NSInteger pageSize;
    
    NSString * classId;
    
    NSArray * pingjiaArray;//评价数组
    
    NSMutableArray * classArray;
    
    NSArray * clsssDictArray;
    
    NSDictionary * shopInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isLoading=YES;
    pageNo=0;
    pageSize=10;
    
//    [APPDefaultManager removeDefaultByKey:KEYShopingCart];
    zonghepingfen=@"0";
    classId=@"0";
    diancaiArray=[[NSArray alloc] init];
    self.pingjiaDataArray=[NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JumpToGoodDetial:) name:@"moreguige" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshShoppingCar) name:@"Refresh_shoppingCar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshAllDate) name:@"goodDetialVCAddGoodSucceed" object:nil];
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetCaiDan:" setFailBackFunctionName:nil];
    [dataproviderOther GetJiFenShopAllProductWithareaid:get_sp(@"city_Id") andparentid:self.parentid];
    
    
    [self initData];
    witchTb=0;
    oldSegmentIndex=0;
    isshoppingCarShow=NO;
    isbottomviewshow=NO;
    
    self.shopingCartArr = [ShoppingCartManager GetShoppingCart];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tablevewUptoTop) name:@"insideTableView_upTouch" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tablevewDowntoTop) name:@"insideTableView_DownTouch" object:nil];
    [self BuildSetmentCotrol];
    
    [self InitView];
    
//    [self BuildShoppingCarView];
    [self InitNav];
    [self buildbottom];
    [self SetInfoWithShoppingCar];
    
    
    [self GetCommentTitle];
    
    [self GetCommentList];
    
//    [self GetshopInfo];
    
}

-(void)GetCommentTitle
{
//    OrderRequest * orderRequest=[[OrderRequest alloc] init];
//    [orderRequest setDelegateObject:self setSucceedBackFunctionName:@"GetCommentCallBack:" setFailBackFunctionName:nil];
//    [orderRequest SelectPageCommentByShopIdWithshopid:@"1"];
}

-(void)GetCommentCallBack:(id)dict
{
//    if (RequestSuccess(dict)) {
//        
//        zonghepingfen=[NSString stringWithFormat:@"%@",dict[@"data"][@"AvgDeliveryScore"]];
//        classArray=[[NSMutableArray alloc] init];
//        
//        clsssDictArray=[[NSArray alloc] initWithArray:dict[@"data"][@"ScoreCategoryList"]];
//        
//        for (NSDictionary * dic in dict[@"data"][@"ScoreCategoryList"]) {
//            [classArray addObject:dic[@"Name"]];
//        }
//        _tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
//        _tagsView.type = 0;
//        _tagsView.tagHeight=30;
//        _tagsView.masksToBounds=YES;
//        _tagsView.cornerRadius=15;
//        //    _tagsView
//        [_tagsView setTagAry:classArray delegate:self];
//        [self.tb_PingJia reloadData];
//    }
}
-(void)GetCommentList
{
//    pageNo=0;
//    OrderRequest * orderRequest=[[OrderRequest alloc] init];
//    [orderRequest setDelegateObject:self setSucceedBackFunctionName:@"GetCommentListCallBack:" setFailBackFunctionName:nil];
//    [orderRequest getCommentListWithStartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andMaximumRows:[NSString stringWithFormat:@"%d",pageSize] andshopid:@"1" andIsreminder:classId];
}
-(void)GetCommentListCallBack:(id)dict
{
//    if (RequestSuccess(dict)) {
//        pageNo=1;
//        pingjiaArray=[[NSArray alloc] initWithArray:dict[@"data"]];
//        [self.pingjiaDataArray removeAllObjects];
//        for (int i=0; i<pingjiaArray.count; i++) {
//            ShopDetialPingJiaCellModel * model=[[ShopDetialPingJiaCellModel alloc] init];
//            model.pingJiaDate=[[NSString stringWithFormat:@"%@",pingjiaArray[i][@"SignTime"]] substringToIndex:10];
//            model.img_Path=[NSString stringWithFormat:@"%@%@",LunBoUrl,pingjiaArray[i][@"PhotoPath"]];
//            model.starNum=[pingjiaArray[i][@"ProductScore"] intValue];
//            model.nickName=pingjiaArray[i][@"UserName"];
//            model.timeLong=@"30";
//            model.pinglunContent=pingjiaArray[i][@"Content"];
//            model.addContent=@"";
//            NSArray * arrayright=[[NSArray alloc] initWithArray:pingjiaArray[i][@"Answer"]];
//            if (arrayright.count>0) {
//                model.shopperWritBack=[NSString stringWithFormat:@"商家回复:%@",[[arrayright firstObject] valueForKey:@"Content"]];
//                model.addContent=[NSString stringWithFormat:@"商家回复:%@",[[arrayright firstObject] valueForKey:@"Content"]];
//            }
//            else
//            {
//                model.shopperWritBack=@"";
//            }
//            
//            [self.pingjiaDataArray addObject:model];
//            
//        }
//        
//        [self.tb_PingJia reloadData];
//    }
}
-(void)GetCommentList1
{
//    OrderRequest * orderRequest=[[OrderRequest alloc] init];
//    [orderRequest setDelegateObject:self setSucceedBackFunctionName:@"GetCommentList1CallBack:" setFailBackFunctionName:nil];
//    [orderRequest getCommentListWithStartRowIndex:[NSString stringWithFormat:@"%d",pageNo*pageSize] andMaximumRows:[NSString stringWithFormat:@"%d",pageSize] andshopid:@"1" andIsreminder:classId];
}
-(void)GetCommentList1CallBack:(id)dict
{
//    DLog(@"GetCommentList1CallBack%@",dict);
//    if (RequestSuccess(dict)) {
//        pageNo++;
//        
//        for (NSDictionary * dic in dict[@"data"]) {
//            ShopDetialPingJiaCellModel * model=[[ShopDetialPingJiaCellModel alloc] init];
//            model.pingJiaDate=[[NSString stringWithFormat:@"%@",dic[@"SignTime"]] substringToIndex:10];
//            model.starNum=[dic[@"ProductScore"] intValue];
//            model.nickName=dic[@"UserName"];
//            model.timeLong=@"30";
//            model.pinglunContent=dic[@"Content"];
//            model.addContent=@"";
//            NSArray * arrayright=[[NSArray alloc] initWithArray:dic[@"Answer"]];
//            if (arrayright.count>0) {
//                model.shopperWritBack=[NSString stringWithFormat:@"商家回复:%@",[[arrayright firstObject] valueForKey:@"Content"]];
//                model.addContent=[NSString stringWithFormat:@"商家回复:%@",[[arrayright firstObject] valueForKey:@"Content"]];
//            }
//            else
//            {
//                model.shopperWritBack=@"";
//            }
//            [self.pingjiaDataArray addObject:model];
//            
//        }
//        [self.tb_PingJia reloadData];
//    }
}




-(void)RefreshShoppingCar
{
    self.shopingCartArr = [ShoppingCartManager GetShoppingCart];
    DLog(@"%lu",(unsigned long)self.shopingCartArr.count);
    [self BuildShoppingCarView];
    [self SetInfoWithShoppingCar];
}

-(void)InitNav
{
    self.view.backgroundColor=[UIColor whiteColor];
//    [self.view bringSubviewToFront:_topView];
//    [self.view bringSubviewToFront:_btnLeft];
//    [self.view bringSubviewToFront:_lblTitle];
//    [self.view bringSubviewToFront:_imgLeft];
//    [self addLeftButton:@"goback"];
//    _imgLeft.image=[UIImage imageNamed:@"goback"];
//    [self addLeftButton:@"goback"];
    _lblTitle.text=@"购物券商城";
    _lblTitle.textColor=[UIColor whiteColor];
//    UIButton * btn_goBack=[[UIButton alloc] initWithFrame:CGRectMake(20, 20, 44, 44)];
//    
//    [btn_goBack setImage:[UIImage imageNamed:@"01fanhui_07"] forState:UIControlStateNormal];
//    [self.view addSubview:btn_goBack];

//    _topView.alpha=0;
}

-(void)InitView
{
    [self.view addSubview:self.mainTableView];
    
//    [self BuildTableviewHeader];
    
}
-(void)BuildTableviewHeader
{
    img_backGround=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
    
    img_backGround.image=[UIImage imageNamed:@"beijing"];
    
    UIView * tableHeaderView=[[UIView alloc] initWithFrame:img_backGround.frame];
    tableHeaderView.backgroundColor=[UIColor lightGrayColor];
    
    tableHeaderView.alpha=0.3;
    
    [img_backGround addSubview:tableHeaderView];
    
    
    
    self.mainTableView.tableHeaderView=img_backGround;
}

-(void)buildbottom
{
    
    bottomview_backview=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 70)];
    bottomview_backview.backgroundColor=[UIColor whiteColor];
    UIView * itembottomview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    itembottomview.backgroundColor=UIColorFromRGBValue(0xaeaeae);
    UIButton * btn_pay=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 50)];
    btn_pay.backgroundColor=NAVBAR_COLOR;
    [btn_pay setTitle:@"去支付" forState:UIControlStateNormal];
    [btn_pay addTarget:self action:@selector(PayForShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [itembottomview addSubview:btn_pay];
    lbl_titleprice=[[UILabel alloc] initWithFrame:CGRectMake(80, 15, 150, 20)];
    lbl_titleprice.text=@"购物车还是空的";
    lbl_titleprice.textColor=[UIColor grayColor];
    [itembottomview addSubview:lbl_titleprice];
    [bottomview_backview addSubview:itembottomview];
    btn_showORHide=[[UIButton alloc] initWithFrame:CGRectMake(10, bottomview_backview.frame.origin.y-30, 60, 60)];
    if (self.shopingCartArr.count>0) {
        [btn_showORHide setImage:[UIImage imageNamed:@"huisegouwuc"] forState:UIControlStateNormal];
    }
    else
    {
        [btn_showORHide setImage:[UIImage imageNamed:@"huangsegouwuc"] forState:UIControlStateNormal];
    }
    
//    [btn_showORHide setImage:[UIImage imageNamed:@"hui"] forState:UIControlStateSelected];
    btn_showORHide.selected=NO;
    [btn_showORHide addTarget:self action:@selector(btn_showShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomview_backview];
    [self.view addSubview:btn_showORHide];
    isbottomviewshow=YES;
}

-(void)BuildSetmentCotrol
{
    segctrl1 = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText: @"选购"},@{VOSegmentText: @"评价"}]];
    segctrl1.contentStyle = VOContentStyleTextAlone;
    segctrl1.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
    segctrl1.backgroundColor = [UIColor whiteColor];
    segctrl1.selectedBackgroundColor = segctrl1.backgroundColor;
    segctrl1.selectedIndicatorColor=AppMainColor;
    segctrl1.allowNoSelection = NO;
    segctrl1.frame = CGRectMake(0, 1, SCREEN_WIDTH, 40);
    segctrl1.indicatorThickness = 4;
    segctrl1.scrollBounce=NO;
    segctrl1.textColor=[UIColor blackColor];
    segctrl1.tag = 1;
    [segctrl1 addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
}

-(void)BuildShoppingCarView
{
    UIView *shoppingCarView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
    shoppingCarView.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(15, 6, 100, 20)];
    
    lbl_title.text=@"已添加商品";
    
    [shoppingCarView addSubview:lbl_title];
    
    UILabel *lbl_canhefei=[[UILabel alloc] initWithFrame:CGRectMake(lbl_title.frame.origin.x+lbl_title.frame.size.width, 10, 100, 14)];
    lbl_canhefei.text=@"(餐盒费:￥2)";
    
    lbl_canhefei.textColor=[UIColor grayColor];
    
    self.lbl_shoppingCarNum=lbl_canhefei;
    [shoppingCarView addSubview:self.lbl_shoppingCarNum];
    
    self.shoppingCarvVew=shoppingCarView;
    
    
    UITableView * tb_shoppingcar=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, _ShopingCartCELLHEIGHT * self.shopingCartArr.count)];
    
    tb_shoppingcar.delegate=self;
    
    tb_shoppingcar.dataSource=self;
    
    self.shoppingCarTableview=tb_shoppingcar;
    self.shoppingCarTableview.tableFooterView = [[UIView alloc] init];
    
    shoppingCarView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH , 34+self.shoppingCarTableview.frame.size.height);
    [shoppingCarView addSubview:self.shoppingCarTableview];
    shoppingCarView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.shoppingCarvVew];
//    self.shoppingCarvVew.hidden=YES;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.tb_PingJia]) {
        return 2;
    }
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tb_PingJia]) {
        if (section==0) {
            return 1;
        }
        if (_pingjiaDataArray.count>0) {
            return _pingjiaDataArray.count+1;
        }
        else{
            return 1;
        }
        
    }
    if ([tableView isEqual:self.shoppingCarTableview]) {
        return self.shopingCartArr.count;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if ([tableView isEqual:self.shoppingCarTableview]||[tableView isEqual:self.tb_PingJia]) {
        return nil;
    }
    
    UIView * backGroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
    backGroundView.backgroundColor=[UIColor lightGrayColor];
    [backGroundView addSubview:segctrl1];
    return backGroundView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tb_PingJia]) {
        if (indexPath.section==0) {
            return 100;
        }
        if (indexPath.section==1&&indexPath.row==0) {
            return CGRectGetMaxY(self.tagsView.frame)+50;
        }
        ShopDetialPingJiaCellModel * pingjiaModel=self.pingjiaDataArray[indexPath.row-1];
        return [ShopDetialPingJiaTableViewCell JiSuanCellHeight:pingjiaModel];
    }
    if ([tableView isEqual:self.shoppingCarTableview ]) {
        return _ShopingCartCELLHEIGHT;
    }
    if (witchTb!=0) {
        return SCREEN_HEIGHT-64-41;
    }
    return SCREEN_HEIGHT-TabBar_HEIGHT-44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.shoppingCarTableview]) {
        return 0;
    }
    return 41;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  评价列表
     */
    if ([tableView isEqual:self.tb_PingJia]) {
        if (indexPath.section==0) {
            UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            
            UIView * view_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3+30, 100)];
            UILabel * lbl_pingfen=[[UILabel alloc] init];
            lbl_pingfen.bounds=CGRectMake(0, 0, view_left.frame.size.width, 35);
            lbl_pingfen.center=CGPointMake(view_left.frame.size.width/2, 25);
            lbl_pingfen.text=zonghepingfen;
            lbl_pingfen.textAlignment=NSTextAlignmentCenter;
            lbl_pingfen.textColor=[UIColor orangeColor];
            lbl_pingfen.font=[UIFont systemFontOfSize:24];
            [view_left addSubview:lbl_pingfen];
            UILabel * lbl_title=[[UILabel alloc] init];
            lbl_title.bounds=CGRectMake(0, 0, view_left.frame.size.width, 16);
            lbl_title.center=CGPointMake(view_left.frame.size.width, CGRectGetMaxY(lbl_pingfen.frame)+13);
            lbl_title.textAlignment=NSTextAlignmentCenter;
            lbl_title.textColor=[UIColor grayColor];
            lbl_title.text=@"综合评分";
            [view_left addSubview:lbl_title];
            
            [cell.contentView addSubview:view_left];
            
//            UIView * view_right=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view_left.frame), 0, SCREEN_WIDTH-CGRectGetMaxX(view_left.frame), 100)];
            
            [cell.contentView addSubview:view_left];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section==1) {
            if (indexPath.row==0) {
                UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.tagsView.frame)+50)]
                ;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:self.tagsView];
                
                
                
                return cell;
            }
            
            ShopDetialPingJiaCellModel * pingjiaModel=self.pingjiaDataArray[indexPath.row-1];
            
            ShopDetialPingJiaTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ShopDetialPingJiaTableViewCell" forIndexPath:indexPath];
            for (UIView * itemView in cell.contentView.subviews) {
                [itemView removeFromSuperview];
            }
            cell.model=pingjiaModel;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell BuildAllCellView];
            return cell;
        }
    }
    
    /**
     *  购物车
     */
    if ([tableView isEqual:self.shoppingCarTableview]) {
        
        ShoppingCartModel * itemModel=self.shopingCartArr[indexPath.row];
        static NSString *CellIdentifier = @"shoppingcarcellTableViewCellIdentifier";
        ShoppingCarCellTableViewCell *itemcell = (ShoppingCarCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        @try {
            
            itemcell  = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingCarCellTableViewCell" owner:self options:nil] lastObject];
            itemcell.layer.masksToBounds=YES;
            itemcell.selectionStyle = UITableViewCellSelectionStyleNone;
            itemcell.frame=CGRectMake(itemcell.frame.origin.x, itemcell.frame.origin.y, tableView.frame.size.width, itemcell.frame.size.height);
            itemcell.lbl_title.text=itemModel.ShoppingCartGoodName;
            itemcell.lbl_price.text=itemModel.ShoppingCartGoodPrice;
            itemcell.lbl_num.text=itemModel.ShoppingCartBuyNum;
            itemcell.btn_add.tag=indexPath.row;
            itemcell.btn_jian.tag=indexPath.row;
            [itemcell.btn_add addTarget:self action:@selector(ShoppingCarJiaChangeNum:) forControlEvents:UIControlEventTouchUpInside];
            [itemcell.btn_jian addTarget:self action:@selector(ShoppingCarJianchangeNum:) forControlEvents:UIControlEventTouchUpInside];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        return itemcell;
    }
    
    
    UITableViewCell *cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TabBar_HEIGHT-44-64)];
    if (witchTb==0) {
        self.cctableView.dataArray=self.dataArray;
        self.cctableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [cell addSubview:self.cctableView];
    }
    else
    {
        [cell addSubview:self.tb_PingJia];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [Toolkit makeCall:shopInfo[@"PhoneBind"]];
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
    classId=[NSString stringWithFormat:@"%@",clsssDictArray[sender.tag][@"Id"]];
    [self.tb_PingJia.mj_header beginRefreshing];
//    [self GetCommentList];
}



//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if ([scrollView isEqual:self.mainTableView]) {
//        CGFloat threholdHeight = img_backGround.frame.size.height - 64;
//        if(scrollView.contentOffset.y >= 0 &&
//           scrollView.contentOffset.y <= threholdHeight) {
//            CGFloat alpha = scrollView.contentOffset.y / threholdHeight;
//            _topView.alpha = alpha;
//            
//            if (alpha>1) {
//                scrollView.contentOffset=CGPointMake(0, 64);
//            }
//            
//        }
//        else if(scrollView.contentOffset.y < 0) {
//            scrollView.contentOffset = CGPointMake(0, 0);
//            
//        }
//        else {
//            _topView.alpha = 1.0;
//            
//        }
//    }
//    if ([scrollView isEqual:self.tb_PingJia]) {
//        if (lastContentOffset < scrollView.contentOffset.y) {
//            //                        NSLog(@"向上滚动");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"insideTableView_upTouch" object:nil];
//        }else{
//            //                        NSLog(@"向下滚动");
//            //                        NSLog(@"%f",scrollView.contentOffset.y);
//            if (scrollView.contentOffset.y>scrollView.contentSize.height) {
////                scrollView.contentOffset=CGPointMake(0, scrollView.contentSize.height);
////                return;
//            }
////            if (!isLoading) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"insideTableView_DownTouch" object:nil];
////            }
//            
//        }
//        return;
//    }
//    
//    
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    if ([scrollView isEqual:self.tb_PingJia]) {
//        lastContentOffset = scrollView.contentOffset.y;
//    }
//    
//}
#pragma mark - data source

-(void)buildBill
{
    @try {
        if ([[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]){
            
//            [SVProgressHUD showWithStatus:@"创建订单。。。" maskType:SVProgressHUDMaskTypeBlack];
            DataProviderOther *request = [[DataProviderOther alloc] init];
            [request setDelegateObject:self setSucceedBackFunctionName:@"BuildBillCallBack:" setFailBackFunctionName:nil];
            NSMutableArray *cartArr = [NSMutableArray array];
            
            for (ShoppingCartModel *model in self.shopingCartArr) {
                [cartArr addObject:[model transToBill]];
            }
            
            [request BuildBillWithDetail:[Toolkit NSArrayToJsonString:cartArr] andtype:@"1"];
        }
    } @catch (NSException *exception) {
        DLog(@"func:buildBill 抛异常");
        
    } @finally {
        
    }

}

-(void)BuildBillCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    ELog(dict);
    if (RequestSuccess(dict)) {
        
//        SubmitOrderViewController * submitOrderVC=[[SubmitOrderViewController alloc] init];
//        submitOrderVC.billDetailDict = dict[@"data"];
//        submitOrderVC.allGoodPrice=[ShoppingCartManager getShoppingCartTotalPrice];
//        [self.navigationController pushViewController:submitOrderVC animated:YES];
        
        SubmitJiFenOrderViewController * submitOrderVC=[[SubmitJiFenOrderViewController alloc] init];
        submitOrderVC.orderDetial=dict[@"data"];
        [self.navigationController pushViewController:submitOrderVC animated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
    }
    
}
#pragma mark 点菜页面操作开始
-(void)reLayoutShoppingCart
{
    //调整frame
    self.shoppingCarTableview.frame = CGRectMake(0, 44, SCREEN_WIDTH, _ShopingCartCELLHEIGHT * self.shopingCartArr.count);
    self.shoppingCarvVew.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH , 34+self.shoppingCarTableview.frame.size.height);
    btn_zhezhao.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(self.shoppingCarvVew.bounds.size.height)-60);
    btn_showORHide.frame =  CGRectMake(10, bottomview_backview.frame.origin.y-30, 60, 60);
    //重设center
    btn_showORHide.center=CGPointMake(btn_showORHide.center.x, btn_showORHide.center.y-(self.shoppingCarvVew.bounds.size.height+30));
    self.shoppingCarvVew.center=CGPointMake(self.shoppingCarvVew.center.x, self.shoppingCarvVew.center.y-60-self.shoppingCarvVew.bounds.size.height);
    
}

-(void)btn_showShoppingCar:(UIButton *)sender
{
    [self setShoppingcarButtonStatue];
    if (!isshoppingCarShow) {
        
        self.shopingCartArr = [ShoppingCartManager GetShoppingCart];
        [self.view addSubview:_shoppingCarvVew];
        
        if (!btn_zhezhao) {
            btn_zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(self.shoppingCarvVew.bounds.size.height)-60)];
            btn_zhezhao.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        }
        
        [self.view addSubview:btn_zhezhao];
        isshoppingCarShow=YES;
        [self.view bringSubviewToFront:btn_showORHide];
        [UIView animateWithDuration:0.3 animations:^{
            btn_showORHide.center=CGPointMake(btn_showORHide.center.x, btn_showORHide.center.y-(self.shoppingCarvVew.bounds.size.height+30));
            self.shoppingCarvVew.center=CGPointMake(self.shoppingCarvVew.center.x, self.shoppingCarvVew.center.y-60-self.shoppingCarvVew.bounds.size.height);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            btn_showORHide.center=CGPointMake(btn_showORHide.center.x, btn_showORHide.center.y+(self.shoppingCarvVew.bounds.size.height+30));
            self.shoppingCarvVew.center=CGPointMake(self.shoppingCarvVew.center.x, self.shoppingCarvVew.center.y+60+self.shoppingCarvVew.bounds.size.height);
//            _shoppingCarvVew.hidden=YES;
        }];
        [btn_zhezhao removeFromSuperview];
        
        isshoppingCarShow=NO;
    }
    
}

-(void)setShoppingcarButtonStatue
{
    if (self.shopingCartArr.count>0) {
//        [btn_showORHide setImage:[UIImage imageNamed:@"01fanhui_07"] forState:UIControlStateNormal];
        btn_showORHide.selected=NO;
    }
    else
    {
        _lbl_shoppingCarNum.text=[NSString stringWithFormat:@"餐盒费:￥2"];
        
//        [btn_showORHide setImage:[UIImage imageNamed:@"01fanhui_07"] forState:UIControlStateNormal];
        btn_showORHide.selected=YES;
    }
}
-(void)ShoppingCarJiaChangeNum:(UIButton * )sender
{
    @try {
        ShoppingCartModel *model = self.shopingCartArr[sender.tag];
        [ShoppingCartManager plusGoodNumWithGoodId:model.ShoppingCartGoodId andGuigeId:model.ShoppingCartGuigeId];
        [self PlusGoodForCaiDanListWithGoodID:model.ShoppingCartGoodId AndguigeId:model.ShoppingCartGuigeId];
    }
    @catch (NSException *exception) {
        NSLog(@"购物车数量改变＋");
    }
    @finally {
        self.shopingCartArr = [ShoppingCartManager GetShoppingCart];
        [_shoppingCarTableview reloadData];
        [self SetInfoWithShoppingCar];
        
    }
}

-(void)ShoppingCarJianchangeNum:(UIButton *)sender
{
    @try {
        ShoppingCartModel *model = self.shopingCartArr[sender.tag];
        [ShoppingCartManager reduceGoodNumWithGoodId:model.ShoppingCartGoodId andGuigeId:model.ShoppingCartGuigeId];
        [self RdusGoodForCaiDanListWithGoodID:model.ShoppingCartGoodId AndguigeId:model.ShoppingCartGuigeId];
    }
    @catch (NSException *exception) {
        NSLog(@"购物车数量改变-");
    }
    @finally {
        self.shopingCartArr = [ShoppingCartManager GetShoppingCart];
        [_shoppingCarTableview reloadData];
        [self reLayoutShoppingCart];
        [self SetInfoWithShoppingCar];
    }
}
-(void)SetInfoWithShoppingCar
{
    
    _lbl_shoppingCarNum.text=[NSString stringWithFormat:@"共计%lu件商品",(unsigned long)self.shopingCartArr.count];
    if (self.shopingCartArr.count>0) {
        [btn_showORHide setImage:[UIImage imageNamed:@"huangsegouwuc"] forState:UIControlStateNormal];
        lbl_titleprice.text=[NSString stringWithFormat:@"共¥%.2f",[ShoppingCartManager getShoppingCartTotalPrice]];
    }
    else
    {
        lbl_titleprice.text=@"购物车还是空的";
        [btn_showORHide setImage:[UIImage imageNamed:@"huisegouwuc"] forState:UIControlStateNormal];
    }
    
}

-(void)JumpToGoodDetial:(NSNotification *)notification
{
    NSIndexPath * indexpath=(NSIndexPath*)notification.object;
    
    DLog(@"%@",self.cctableView.dataArray[indexpath.section]);
    
    if (![[Toolkit getUserDefaultByKey:isLogin] isEqualToString:@"YES"]) {
        LoginViewController* loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    GoodDetialViewController * goodDetialVC=[[GoodDetialViewController alloc] init];
    TakeOutModel *model =(TakeOutModel *)self.cctableView.dataArray[indexpath.section][@"content"][indexpath.row];
    goodDetialVC.goodId=[NSString stringWithFormat:@"%ld",(long)model.foodID];
    [self.navigationController pushViewController:goodDetialVC animated:YES];
}

#pragma mark 点菜页面操作结束


- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    NSLog(@"%@: value --> %@",@(segmentCtrl.tag), @(segmentCtrl.selectedSegmentIndex));
    
    
    
    witchTb=segmentCtrl.selectedSegmentIndex;
    if (witchTb==0) {
        bottomview_backview.hidden=NO;
        self.mainTableView.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    else
    {
        bottomview_backview.hidden=YES;
        self.mainTableView.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        
    }
    btn_showORHide.hidden=bottomview_backview.hidden;
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:oldSegmentIndex>segmentCtrl.selectedSegmentIndex?UITableViewRowAnimationRight:UITableViewRowAnimationLeft];
    oldSegmentIndex=segmentCtrl.selectedSegmentIndex;
}
-(void)GetshopInfo
{
//    OrderRequest * orderRQ=[[OrderRequest alloc] init];
//    [orderRQ setDelegateObject:self setSucceedBackFunctionName:@"GetShopInfoCallBack:" setFailBackFunctionName:nil];
//    [orderRQ SelectShopNewsByShopId:@"1"];
}
-(void)GetShopInfoCallBack:(id)dict
{
//    if (RequestSuccess(dict)) {
//        shopInfo=[[NSDictionary alloc] initWithDictionary:dict[@"data"]];
//        
//        [self.tb_ShopInfo reloadData];
//    }
}
-(void)PayForShoppingCar:(UIButton *)sender
{
//    float shoppingcarprice=[ShoppingCartManager getShoppingCartTotalPrice];
    
//    GoodDetialViewController * goodDetialVC=[[GoodDetialViewController alloc] init];
//    goodDetialVC.goodId=@"1";
//    [self.navigationController pushViewController:goodDetialVC animated:YES];

    if (self.shopingCartArr.count>0) {
        [self buildBill];
    }
    else
    {
//        [YJXStatusHUD showError:@"请选择商品后进行支付"];
        return;
    }
    
    
    if (isshoppingCarShow) {
        [self btn_showShoppingCar:sender];
    }
    
    
}

#pragma mark 评价顶部刷新
-(void)PingjiaStoreTopRefresh
{
    [self.tb_PingJia.mj_header endRefreshing];
    [self GetCommentList];
}
-(void)PingJiaStoreFootRefresh
{
    
    [self.tb_PingJia.mj_footer endRefreshing];
    [self GetCommentList1];
    isLoading=NO;
}




-(void)GetCaiDan:(id)dict
{
    DLog(@"GetCaiDan%@",dict);
    if (RequestSuccess(dict)) {
        diancaiArray=dict[@"data"];
        
        [self initData];
    }
    else
    {
    }
}





/**
 * 添加假数据
 */
- (void)initData
{
    self.dataArray = [NSMutableArray array];
    self.orderArray=[NSMutableArray array];
    
    
    if (diancaiArray.count!=0) {
        for (int j=0; j<diancaiArray.count; j++) {
            NSDictionary * itemDict=[[NSDictionary alloc] initWithDictionary:diancaiArray[j]];//item一个分类
            NSArray * good_array=[[NSArray alloc] initWithArray:itemDict[@"ProductList"]];
            
            NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
            [dict4 setValue:itemDict[@"Name"] forKey:@"title"];
            
            NSMutableArray *array4 = [NSMutableArray array];
            for (NSInteger i = 0; i<good_array.count; i++) {
                
                TakeOutModel *model = [[TakeOutModel alloc] init];
                model.price = [good_array[i][@"Price"] floatValue];
                model.title = [NSString stringWithFormat:@"%@",good_array[i][@"Name"]];
                model.soldCount = [good_array[i][@"SaleNum"] intValue];
                model.iconPath=[NSString stringWithFormat:@"%@%@",BaseImgUrl,good_array[i][@"ImagePath"]];
                model.foodID=[good_array[i][@"Id"] intValue];
                model.moreGuiGe=NO;
//                if (!([self ReturnGoodCount:[NSString stringWithFormat:@"%ld",(long)model.foodID]]==0)) {
//                    model.showCount=YES;
//                }
                NSArray * price_list=[[NSArray alloc] initWithArray:good_array[i][@"PriceList"]];
                if (price_list.count>1) {
                    model.moreGuiGe=YES;
                    model.showCount=NO;
                }
                else
                {
                    NSInteger count_food=[self ReturnGoodCount:[NSString stringWithFormat:@"%ld",(long)model.foodID]];
                    model.orderCount=count_food;
                    if (count_food>0) {
                        
                        model.showCount=YES;
                    }
                }
                model.guiGeArray=price_list;
               
                [array4 addObject:model];
            }
            [dict4 setValue:array4 forKey:@"content"];
            
            [self.dataArray addObject:dict4];
        }
        self.cctableView.dataArray=self.dataArray;
//        [self.cctableView reloadData];
    }
    else
    {
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:@"汉堡" forKey:@"title"];
        NSMutableArray *array1 = [NSMutableArray array];
        for (NSInteger i = 0; i<5; i++) {
            TakeOutModel *model = [[TakeOutModel alloc] init];
            model.price = 99;
            model.title = [NSString stringWithFormat:@"汉堡%ld",(long)i];
            model.soldCount = 10+i;
            [array1 addObject:model];
            [self.orderArray addObject:model];
        }
        [dict1 setValue:array1 forKey:@"content"];
        
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        [dict2 setValue:@"火锅" forKey:@"title"];
        NSMutableArray *array2 = [NSMutableArray array];
        for (NSInteger i = 0; i<7; i++) {
            TakeOutModel *model = [[TakeOutModel alloc] init];
            model.price = 19+i;
            model.title = [NSString stringWithFormat:@"火锅%ld",(long)i];
            model.soldCount = 20+i;
            [array2 addObject:model];
        }
        [dict2 setValue:array2 forKey:@"content"];
        
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
        [dict3 setValue:@"薯条" forKey:@"title"];
        NSMutableArray *array3 = [NSMutableArray array];
        for (NSInteger i = 0; i<8; i++) {
            TakeOutModel *model = [[TakeOutModel alloc] init];
            model.price = 99+i;
            model.title = [NSString stringWithFormat:@"薯条%ld",(long)i];
            model.soldCount = 30+i;
            [array3 addObject:model];
        }
        [dict3 setValue:array3 forKey:@"content"];
        
        NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
        [dict4 setValue:@"麻饼" forKey:@"title"];
        NSMutableArray *array4 = [NSMutableArray array];
        for (NSInteger i = 0; i<9; i++) {
            TakeOutModel *model = [[TakeOutModel alloc] init];
            model.price = 89+i;
            model.title = [NSString stringWithFormat:@"麻%ld",(long)i];
            model.soldCount = 40+i;
            [array4 addObject:model];
        }
        [dict4 setValue:array4 forKey:@"content"];
        
        [self.dataArray addObject:dict1];
        [self.dataArray addObject:dict2];
        [self.dataArray addObject:dict3];
        [self.dataArray addObject:dict4];
    }
    
    
    
    
    
    
    
    [self.shoppingCarTableview reloadData];
    


}


-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
        _mainTableView.showsVerticalScrollIndicator=NO;
        _mainTableView.tag=9;
        _mainTableView.contentSize=CGSizeMake(0, _mainTableView.contentSize.height+50);
    }
    return _mainTableView;
}
-(UITableView *)tb_PingJia
{
    if (!_tb_PingJia) {
        _tb_PingJia=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-41)];
        _tb_PingJia.delegate=self;
        _tb_PingJia.dataSource=self;
        [_tb_PingJia registerClass:[ShopDetialPingJiaTableViewCell class] forCellReuseIdentifier:@"ShopDetialPingJiaTableViewCell"];
        _tb_PingJia.tableFooterView = [[UIView alloc] init];
        _tb_PingJia.bounces = NO;
        __unsafe_unretained __typeof(self) weakSelf = self;
//        __weak typeof(UITableView *) weakTb = _tb_PingJia;
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        
        _tb_PingJia.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf PingjiaStoreTopRefresh];
            
        }];
        
        // 马上进入刷新状态
        [_tb_PingJia.mj_header beginRefreshing];
        
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(PingJiaStoreFootRefresh)];
        
        // 禁止自动加载
        footer.automaticallyRefresh = NO;
        
        // 设置footer
        _tb_PingJia.mj_footer = footer;
    }
    
    return _tb_PingJia;
}

-(void)tablevewUptoTop
{
    [UIView animateWithDuration:0.5 animations:^{
        self.mainTableView.contentOffset=CGPointMake(0, img_backGround.frame.size.height-64);
        if (witchTb!=0) {
            self.mainTableView.contentOffset=CGPointMake(0, img_backGround.frame.size.height-64);
        }
        _lblTitle.textColor=[UIColor whiteColor];
        [self addLeftButton:@"fanhui"];
    }];
    
}
-(void)tablevewDowntoTop
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mainTableView.contentOffset=CGPointMake(0, 0);
//        _lblTitle.textColor=[UIColor clearColor];
        [self addLeftButton:@"goback"];
    }];
    
}

-(NSInteger)ReturnGoodCount:(NSString *)goodid
{
    NSInteger GoodCount=0;
    for (int i=0; i<self.shopingCartArr.count; i++) {
        ShoppingCartModel * model=self.shopingCartArr[i];
        if ([goodid isEqualToString:[NSString stringWithFormat:@"%@",model.ShoppingCartGoodId]]) {
            GoodCount=[model.ShoppingCartBuyNum integerValue];
        }
    }
    return GoodCount;
}

-(void)PlusGoodForCaiDanListWithGoodID:(NSString *)GoodId AndguigeId:(NSString *)GuiGeId
{
    @try {
        BOOL isBreak=NO;
        NSMutableArray * dataarray_=[[NSMutableArray alloc] initWithArray:self.cctableView.dataArray];
        for (int i=0; i<self.cctableView.dataArray.count; i++) {
            NSMutableDictionary * itemdict=[[NSMutableDictionary alloc] initWithDictionary:self.cctableView.dataArray[i]];
            NSMutableArray *takeOurModelArray=[[NSMutableArray alloc] initWithArray:itemdict[@"content"]];
            for (int j=0; j<takeOurModelArray.count; j++) {
                TakeOutModel *model=takeOurModelArray[j];
                if ([GoodId isEqualToString:[NSString stringWithFormat:@"%ld",(long)model.foodID]]) {
                    if (model.guiGeArray!=nil&&GuiGeId!=nil) {
                        if (model.guiGeArray.count==1&&([[NSString stringWithFormat:@"%@",model.guiGeArray[0][@"Id"]] isEqualToString:[NSString stringWithFormat:@"%@",GuiGeId]] )) {
                            model.orderCount+=1;
                            isBreak=YES;
                            [takeOurModelArray replaceObjectAtIndex:j withObject:model];
                            [itemdict setObject:takeOurModelArray forKey:@"content"];
                            [dataarray_ replaceObjectAtIndex:i withObject:itemdict];
                            self.cctableView.dataArray=[[NSArray alloc] initWithArray:dataarray_];
                            break;
                            
                        }
                    }
                    else
                    {
                        model.orderCount+=1;
                        isBreak=YES;
                        [takeOurModelArray replaceObjectAtIndex:j withObject:model];
                        [itemdict setObject:takeOurModelArray forKey:@"content"];
                        [dataarray_ replaceObjectAtIndex:i withObject:itemdict];
                        self.cctableView.dataArray=[[NSArray alloc] initWithArray:dataarray_];
                        break;
                    }
                }
                
            }
            if (isBreak) {
                break;
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
    }
}

-(void)RdusGoodForCaiDanListWithGoodID:(NSString *)GoodId AndguigeId:(NSString *)GuiGeId
{
    @try {
        BOOL isBreak=NO;
        NSMutableArray * dataarray_=[[NSMutableArray alloc] initWithArray:self.cctableView.dataArray];
        for (int i=0; i<self.cctableView.dataArray.count; i++) {
            NSMutableDictionary * itemdict=[[NSMutableDictionary alloc] initWithDictionary:self.cctableView.dataArray[i]];
            NSMutableArray *takeOurModelArray=[[NSMutableArray alloc] initWithArray:itemdict[@"content"]];
            for (int j=0; j<takeOurModelArray.count; j++) {
                TakeOutModel *model=takeOurModelArray[j];
                if ([GoodId isEqualToString:[NSString stringWithFormat:@"%ld",(long)model.foodID]]) {
                    if (model.guiGeArray!=nil&&GuiGeId!=nil) {
                        if (model.guiGeArray.count==1&&([[NSString stringWithFormat:@"%@",model.guiGeArray[0][@"Id"]] isEqualToString:[NSString stringWithFormat:@"%@",GuiGeId]] )) {
                            if (model.orderCount>=1) {
                                if (model.orderCount==1) {
                                    model.orderCount=0;
                                    model.showCount=NO;
                                }
                                else
                                {
                                    model.orderCount-=1;
                                }
                                isBreak=YES;
                                [takeOurModelArray replaceObjectAtIndex:j withObject:model];
                                [itemdict setObject:takeOurModelArray forKey:@"content"];
                                [dataarray_ replaceObjectAtIndex:i withObject:itemdict];
                                self.cctableView.dataArray=[[NSArray alloc] initWithArray:dataarray_];
                                break;
                            }
                        }
                    }
                    else
                    {
                        if (model.orderCount>=1) {
                            if (model.orderCount==1) {
                                model.orderCount=0;
                                model.showCount=NO;
                            }
                            else
                            {
                                model.orderCount-=1;
                            }
                            isBreak=YES;
                            [takeOurModelArray replaceObjectAtIndex:j withObject:model];
                            [itemdict setObject:takeOurModelArray forKey:@"content"];
                            [dataarray_ replaceObjectAtIndex:i withObject:itemdict];
                            self.cctableView.dataArray=[[NSArray alloc] initWithArray:dataarray_];
                            break;
                        }
                    }
                }
                
            }
            if (isBreak) {
                break;
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
    }
}

-(NSString *)peisongTime:(NSArray *)array
{
    NSString * str_time=@"配送时间:";
    for (NSDictionary * itemDict in array) {
        str_time=[str_time stringByAppendingString:@" "];
        str_time=[str_time stringByAppendingString:[Toolkit compareCurrentTime:itemDict[@"TimeStart"]]];
        str_time=[str_time stringByAppendingString:@"~"];
        str_time=[str_time stringByAppendingString:[Toolkit compareCurrentTime:itemDict[@"TimeEnd"]]];
    }
    return str_time;
    
}

-(void)RefreshAllDate
{
    self.shopingCartArr = [ShoppingCartManager GetShoppingCart];
    [self initData];
    [self.mainTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self RefreshShoppingCar];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
-(void)viewDidAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
