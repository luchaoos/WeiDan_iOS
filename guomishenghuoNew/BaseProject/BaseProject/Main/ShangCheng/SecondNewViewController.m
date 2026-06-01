//
//  SecondNewViewController.m
//  BaseProject
//
//  Created by 于金祥 on 17/3/21.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "SecondNewViewController.h"
#import "SDCycleScrollView.h"
#import "DataProviderOther.h"
#import "GoodDetialViewController.h"
#import "LoginViewController.h"
#import "ShangChengGoodListViewController.h"
#import "ShangChengShoppingCarViewController.h"
#import "SearchViewController.h"
#import "WoyaokaidianViewController.h"
#import "JiFenShopingCarViewController.h"

@interface SecondNewViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;//轮播图
@property (nonatomic,strong) UIScrollView *mainScorllView;

@property (nonatomic,assign) BOOL flag;
@end

@implementation SecondNewViewController
{
    UIPageControl *_pageControl;
    
    UIView * headerview;
    
    NSInteger pageNo;
    NSInteger pageSize;
    NSArray * shopListData;
    NSString * areaID;
    
    NSMutableDictionary *flags;
//    FL_Button * btn_city;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    flags = @{}.mutableCopy;
    pageSize=100;
    _imgLeft.hidden=YES;
//    [self BuildheaderView];
    _lblTitle.text=@"";
    [self addRightbuttontitle:@"购物车"];
    [self BuildTopView];
    [self.mainScorllView addSubview:self.cycleScrollView];
    [self startGetIndexData];
    [self.view addSubview:self.mainScorllView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 60 - 50, 45, 45);
    [btn setImage:[UIImage imageNamed:@"我要开店.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(woyaokaidian:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    
}

- (void)woyaokaidian:(UIButton *)sender {
    WoyaokaidianViewController *vc = [[WoyaokaidianViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)BuildTopView
{
    UIButton * btn_search=[[UIButton alloc] init];
    btn_search.bounds=CGRectMake(0, 0, SCREEN_WIDTH-160, 30);
    btn_search.center=CGPointMake(SCREEN_WIDTH/2, 42);
    [btn_search addTarget:self action:@selector(jumpToSearch) forControlEvents:UIControlEventTouchUpInside];
    btn_search.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
    btn_search.layer.masksToBounds=YES;
    [btn_search setTitle:@"搜索商城商品" forState:UIControlStateNormal];
    btn_search.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn_search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_search.layer.cornerRadius=15;
    UIImageView * img_search=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    img_search.image=[UIImage imageNamed:@"sousuo"];
    [btn_search addSubview:img_search];
    [self.view addSubview:btn_search];
}
-(void)jumpToSearch
{
    SearchViewController * searchVC=[[SearchViewController alloc] init];
    searchVC.type=3;
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)BuildGoodListWithY:(CGFloat)Y
{
    UIView * lastView=[[self.mainScorllView subviews] lastObject];
    NSString *str1 = @"热销产品";
    NSString *str2=@"为您探索最好的商品";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:ZY_NSStringFromFormat(@"%@\n%@",str1,str2)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0;
    NSDictionary *attrsDictionary1 = @{NSFontAttributeName:[UIFont systemFontOfSize:22],
                                       NSParagraphStyleAttributeName:paragraphStyle};
    NSDictionary *attrsDictionary2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                       NSParagraphStyleAttributeName:paragraphStyle};
    //给str1添加属性
    [attributedString addAttributes:attrsDictionary1 range:NSMakeRange(0, str1.length)];
    //        [attributedString addAttributes:attrsDictionary2 range:NSMakeRange(str1.length, str1.length+str2.length-2)];
    
    UILabel * lbl_SectionTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH, 70)];
    lbl_SectionTitle.numberOfLines=2;
    lbl_SectionTitle.attributedText=attributedString;
    lbl_SectionTitle.textAlignment=NSTextAlignmentCenter;
    [self.mainScorllView addSubview:lbl_SectionTitle];
    
    
    for (NSDictionary * itemdict in shopListData) {
        lastView=[[self.mainScorllView subviews] lastObject];
        UIButton * btn_item=[[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame)+10, SCREEN_WIDTH, SCREEN_WIDTH*0.4)];
        [btn_item sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImgUrl,itemdict[@"ImagePath"]]] forState:UIControlStateNormal placeholderImage:img(@"placeHolderlong")];
        btn_item.tag=[itemdict[@"Id"] integerValue];
        [btn_item addTarget:self action:@selector(GoodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScorllView addSubview:btn_item];
        UIView * V_bottom=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn_item.frame), SCREEN_WIDTH, 33)];
        V_bottom.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-40, 35)];
        lbl_title.numberOfLines=2;
        lbl_title.text=ZY_NSStringFromFormat(@"%@\n%@  米币",itemdict[@"Name"],itemdict[@"Price"]);
        lbl_title.font=[UIFont systemFontOfSize:12];
        [V_bottom addSubview:lbl_title];
        UIButton * btn_share=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl_title.frame), 5, 30, 30)];
        [btn_share setImage:[UIImage imageNamed:@"fenxiang-1"] forState:UIControlStateNormal];
        [btn_share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [V_bottom addSubview:btn_share];
        [self.mainScorllView addSubview:V_bottom];
    }
    lastView=[[self.mainScorllView subviews] lastObject];
    self.mainScorllView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(lastView.frame)+50);
}
-(void)BuildFenleiItemWithArray:(NSArray *)fenleiArray
{
    
    
//    UIView * lastView=[[self.mainScorllView subviews] lastObject];
    CGFloat itemwidth=(SCREEN_WIDTH)/3;
    CGFloat itemJiange=(SCREEN_WIDTH-(itemwidth*3))/4;
    for (int i = 0; i < fenleiArray.count; ++i) {
        UIView * lastView=[[self.mainScorllView subviews] lastObject];
        
        UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lastView.frame)+10, SCREEN_WIDTH - 20, 20)];
        lbl_title.textAlignment = NSTextAlignmentCenter;
        lbl_title.font = [UIFont systemFontOfSize:14];
        lbl_title.text=Zy_JudgeIsNull(fenleiArray[i][@"Name"]);
        [self.mainScorllView addSubview:lbl_title];
        
        NSArray * itemArray=[[NSArray alloc] initWithArray:fenleiArray[i][@"SecondCate"]];
        if (itemArray.count>0) {
            lastView=[[self.mainScorllView subviews] lastObject];
            UIView *item=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame), SCREEN_WIDTH,(itemArray.count%3)>0?(itemArray.count/3+1)*(itemwidth+20):(itemArray.count/3)*(itemwidth+20))];
            item.backgroundColor=[UIColor whiteColor];
            
            for (int j=0; j<itemArray.count; j++) {
                UIButton * btn_pinglun = nil;
                if (j<2) {
                    btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(itemJiange+(j%3)*(itemwidth+itemJiange),(j/3)*(itemwidth+itemJiange), itemwidth, itemwidth)];
                }else{
                    btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(itemJiange+(j%3)*(itemwidth+itemJiange),(j/3)*(itemwidth+itemJiange+20), itemwidth, itemwidth)];
                }
                btn_pinglun.tag= i*10000+j;
                btn_pinglun.layer.masksToBounds=YES;
                btn_pinglun.layer.cornerRadius=itemwidth/2;
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(itemwidth*0.15,itemwidth*0.15, itemwidth*0.7, itemwidth*0.7)];
                NSString *img = (itemArray.count == 0?@"":itemArray[j][@"ImagePath"]?itemArray[j][@"ImagePath"]:@"");
                NSString *url = [NSString stringWithFormat:@"%@%@",@"",img];
                [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"gengduo"]];
                [btn_pinglun addSubview:imgView];
                
#warning ...
                btn_pinglun.tag=[itemArray[j][@"Id"] integerValue];
                
                [flags setObject:[NSString stringWithFormat:@"%@", itemArray[j][@"Flg"]] forKey:[NSString stringWithFormat:@"%@", itemArray[j][@"Id"]]];
                //[btn_pinglun setImage:[UIImage imageNamed:[NSString stringWithFormat:@"item_%d",i*8+j+1]] forState:UIControlStateNormal];
                [btn_pinglun addTarget:self action:@selector(JumpToTypeVC:) forControlEvents:UIControlEventTouchUpInside];
                [item addSubview:btn_pinglun];
                
                UILabel *lbl_name = [[UILabel alloc] initWithFrame:CGRectMake(itemJiange+(j%3)*(itemwidth+itemJiange), btn_pinglun.frame.origin.y + btn_pinglun.frame.size.height-20, itemwidth, 50)];
                lbl_name.numberOfLines = 2;
                lbl_name.lineBreakMode = NSLineBreakByWordWrapping;
                lbl_name.textAlignment = NSTextAlignmentCenter;
                lbl_name.text = itemArray.count == 0?@"":itemArray[j][@"Name"]?itemArray[j][@"Name"]:@"";
                lbl_name.font = [UIFont systemFontOfSize:12];
                [item addSubview:lbl_name];
            }
            [self.mainScorllView addSubview:item];
        }
        
    }
    UIView * lastView=[[self.mainScorllView subviews] lastObject];
    self.mainScorllView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(lastView.frame)+50);
    [self BuildGoodListWithY:CGRectGetMaxY(lastView.frame)+20];
    
}


-(void)JumpToTypeVC:(UIButton *)sender
{
    ShangChengGoodListViewController * goodlistVC=[[ShangChengGoodListViewController alloc] init];
    goodlistVC.type=ZY_NSStringFromFormat(@"%ld",sender.tag);
    goodlistVC.flag = flags[[NSString stringWithFormat:@"%ld", sender.tag]];//[NSString stringWithFormat:@"%@", shopListData[sender.tag][@"flg"]];
    
    [self.navigationController pushViewController:goodlistVC animated: YES];
}
-(void)share
{
    [Toolkit ShareForProject];
}
-(void)startGetIndexData
{
//    [btn_city setTitle:get_sp(@"city_Name") forState:UIControlStateNormal];
    areaID=get_sp(@"city_Id");
    [self GetLunBoTu];
    [self GetFenLei];
    [self GetShopData];
}
-(void)GetLunBoTu
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetLunbotuCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetLunBoTuSecond:get_sp(@"city_Id") andtype:@"6"];
}
-(void)GetLunbotuCallBack:(id)dict
{
    DLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        [_cycleScrollView removeFromSuperview];
        NSArray * sliderArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        //    sliderArray = [mDataArray valueForKey:@"rotationAdvertList"];
        if (sliderArray.count > 0) {
            for (int i=0; i<sliderArray.count; i++) {
                UIImageView * img=[[UIImageView alloc] init];
                [img sd_setImageWithURL:[NSURL URLWithString:sliderArray[i][@"ImagePath"]] placeholderImage:[UIImage imageNamed:@"placeholder"] ];
                [images addObject:sliderArray[i][@"ImagePath"]];
            }
        }
        else
        {
            UIImageView * img=[[UIImageView alloc] init];
            [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeHolderlong"] ];
            [images addObject:@""];
        }
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.65) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //        cycleScrollView2.titlesGroup = titles;
        _cycleScrollView.imageURLStringsGroup = images;
        [self.mainScorllView addSubview:_cycleScrollView];
    }
}
-(void)GetFenLei
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetFenLeiCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetShopFenLei];
}
-(void)GetFenLeiCallBack:(id)dict
{
    DLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        [self BuildFenleiItemWithArray:dict[@"data"]];
    }
    
}

-(void)GetShopData
{
    pageNo=0;
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetShopDataCallBack:" setFailBackFunctionName:nil];
    [dataproviderother SelectRecommendForJifen:areaID andstartRowIndex:ZY_NSStringFromFormat(@"%d",pageNo*pageSize) andmaximumRows:ZY_NSStringFromFormat(@"%ld",(long)pageSize)];
}
-(void)GetShopDataCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        shopListData=[[NSArray alloc] initWithArray:dict[@"data"]];
        
//        [self BuildGoodList];
    }
    
}


#pragma 购物车
-(void)clickRightButton:(UIButton *)sender
{
//    ShangChengShoppingCarViewController * shangchengshoppingcarVC=[[ShangChengShoppingCarViewController alloc] init];
//    [self.navigationController pushViewController:shangchengshoppingcarVC animated:YES];
    
    JiFenShopingCarViewController *vc = [[JiFenShopingCarViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

-(UIScrollView *)mainScorllView
{
    if (!_mainScorllView) {
        _mainScorllView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-TabBar_HEIGHT-64)];
        _mainScorllView.delegate=self;
    }
    return _mainScorllView;
}

-(SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        UIImageView * img=[[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeHolderlong"] ];
        [images addObject:img];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.65) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //        cycleScrollView2.titlesGroup = titles;
        _cycleScrollView.imageURLStringsGroup = images;
    }
    return _cycleScrollView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_app_ showTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
