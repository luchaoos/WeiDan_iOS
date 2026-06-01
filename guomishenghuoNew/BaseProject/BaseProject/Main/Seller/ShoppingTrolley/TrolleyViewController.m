//
//  TrolleyViewController.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "TrolleyViewController.h"
#import "Util.h"
#import "Header.h"
#import "ShoppingTableView.h"
#import "ShoppingModel.h"
#import "DataProviderOther.h"
#import "JSONKit.h"
#import "SubmitTuanGouOrderViewController.h"


@interface TrolleyViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    
    BOOL isbool;
    
    BOOL editbool;
    
    NSString *numString;
    
    ShoppingTableView *shopping;
    
    NSArray *cellArray;
    
    NSArray * ShoppingCarArray;
}
@property (nonatomic, strong)UITableView *TroTableView;

@end

@implementation TrolleyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _lblTitle.text=@"购物车";
//    [self addRightbuttontitle:@"编辑"];
    [_btnRight setTitle:@"编辑" forState:UIControlStateNormal];
    [_app_ hiddenTabBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self GetShoppingCarData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self bottomView];
    [self setInit];
//    [self GetShoppingCarData];
}

-(void)GetShoppingCarData
{
    DataProviderOther * dataprovider=[[DataProviderOther alloc] init];
    [dataprovider setDelegateObject:self setSucceedBackFunctionName:@"GetShoppingCarDataCallBack:" setFailBackFunctionName:nil];
    [dataprovider GetShoppingCarDataWithUserId:get_sp(user_ID)];
    
}
-(void)GetShoppingCarDataCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        ShoppingCarArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        [self setData];
//        [self.TroTableView reloadData];
    }
}
-(void)setInit{
    
    numString = @"0";
    shopping = [[ShoppingTableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -75) style:UITableViewStyleGrouped];
    [self.view addSubview:shopping];
    
    [self setData];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllPrice:) name:@"AllPrice" object:nil];
    [Util setUILabel:_allPriceLabel Data:@"合计: " SetData:@"0.00" Color:RGB(231, 123, 75) Font:15 Underline:NO];
    
}

#pragma mark 通知
- (void)AllPrice:(NSNotification *)text{
    
    _allPriceLabel.text = [NSString stringWithFormat:@"总价: %@",text.userInfo[@"allPrice"]];
    [Util setUILabel:_allPriceLabel Data:@"总价: " SetData:text.userInfo[@"allPrice"] Color:RGB(231, 123, 75) Font:15 Underline:NO];

    numString = text.userInfo[@"num"];
    [self setTlementLabel];
    [self setAllBtnState:[text.userInfo[@"allState"]  isEqual: @"YES"]?NO:YES];
    cellArray =  text.userInfo[@"cellModel"];
}

#pragma mark 设置结算按钮状态
-(void)setTlementLabel{
    
    NSString *string = editbool?@"删除":@"结算";
    [_settlementBtn setTitle:[NSString stringWithFormat:@"%@(%@)",string,numString] forState:UIControlStateNormal];
}

#pragma mark 数据
-(void)setData{
    
    
    
    
    NSDictionary *dicts = @{
                            @"item":@[
                                    @{
                                        @"headID":@"10",
                                        @"headState":@1,
                                        @"discount":@"9",
                                        @"headCellArray":@[
                                                @{
                                                    @"imageUrl":@"headurl.png",
                                                    @"title":@"一岁宝宝拖车轻巧方便",
                                                    @"color":@"浅蓝",
                                                    @"size":@"s",
                                                    @"price":@"100.00",
                                                    @"numInt":@2,
                                                    @"inventoryInt":@10,
                                                    @"mustInteger":@1,
                                                    @"ID":@"10",
                                                    },
                                                @{
                                                    
                                                    @"imageUrl":@"headurl.png",
                                                    @"title":@"韩版宽松杂色马海毛休闲",
                                                    @"color":@"浅蓝",
                                                    @"size":@"s",
                                                    @"price":@"100.00",
                                                    @"numInt":@2,
                                                    @"inventoryInt":@10,
                                                    @"mustInteger":@1,
                                                    @"ID":@"11",
                                                    },
                                                @{
                                                    
                                                    @"imageUrl":@"headurl.png",
                                                    @"title":@"韩版宽松杂色马海毛休闲",
                                                    @"color":@"浅蓝",
                                                    @"size":@"s",
                                                    @"price":@"100.00",
                                                    @"numInt":@2,
                                                    @"inventoryInt":@10,
                                                    @"mustInteger":@0,
                                                    @"ID":@"12",
                                                    },
                                                ]
                                        
                                        },
                                    @{
                                        @"headID":@"11",
                                        @"headState":@1,
                                        @"discount":@"9",
                                        @"headCellArray":@[
                                                @{
                                                    @"imageUrl":@"headurl.png",
                                                    @"title":@"韩版宽松杂色马海毛休闲",
                                                    @"color":@"浅蓝",
                                                    @"size":@"s",
                                                    @"price":@"100.00",
                                                    @"numInt":@2,
                                                    @"inventoryInt":@10,
                                                    @"mustInteger":@1,
                                                    @"ID":@"13",
                                                    },
                                                @{
                                                    
                                                    @"imageUrl":@"headurl.png",
                                                    @"title":@"韩版宽松杂色马海毛休闲",
                                                    @"color":@"浅蓝",
                                                    @"size":@"s",
                                                    @"price":@"100.00",
                                                    @"numInt":@2,
                                                    @"inventoryInt":@10,
                                                    @"mustInteger":@0,
                                                    @"ID":@"14",
                                                    },
                                                ]
                                        
                                        },
                                    @{
                                        @"headID":@"12",
                                        @"headState":@1,
                                        @"discount":@"9",
                                        @"headCellArray":@[
                                                @{
                                                    @"imageUrl":@"headurl.png",
                                                    @"title":@"韩版宽松杂色马海毛休闲",
                                                    @"color":@"浅蓝",
                                                    @"size":@"s",
                                                    @"price":@"100.00",
                                                    @"numInt":@2,
                                                    @"inventoryInt":@10,
                                                    @"mustInteger":@0,
                                                    @"ID":@"15",
                                                    },
                                                
                                                ]
                                        
                                        },
                                    @{
                                        @"headID":@"13",
                                        @"headState":@1,
                                        @"discount":@"9",
                                        @"headCellArray":@[
                                                @{
                                                    @"imageUrl":@"headurl.png",
                                                    @"title":@"韩版宽松杂色马海毛休闲",
                                                    @"color":@"浅蓝",
                                                    @"size":@"s",
                                                    @"price":@"100.00",
                                                    @"numInt":@2,
                                                    @"inventoryInt":@10,
                                                    @"mustInteger":@0,
                                                    @"ID":@"16",
                                                    },
                                                
                                                ]
                                        
                                        },
                                    @{
                                        @"headID":@"13",
                                        @"headState":@1,
                                        @"discount":@"9",
                                        @"headCellArray":@[
                                                @{
                                                    @"imageUrl":@"headurl.png",
                                                    @"title":@"韩版宽松杂色马海毛休闲",
                                                    @"color":@"浅蓝",
                                                    @"size":@"s",
                                                    @"price":@"100.00",
                                                    @"numInt":@2,
                                                    @"inventoryInt":@10,
                                                    @"mustInteger":@0,
                                                    @"ID":@"16",
                                                    },
                                                
                                                ]
                                        
                                        }
                                    
                                    ]
                            };
    
    
    
    
    
    
    
    NSMutableArray *arrayl = [[NSMutableArray alloc] init];
    
    
    
    
    for (NSDictionary *dict in ShoppingCarArray) {
        
//        NSMutableArray *dictarray = [[NSMutableArray alloc] init];
        ShoppingModel *model = [[ShoppingModel alloc] initWithShopDict:dict];
//        [dictarray addObject:model];
        
        [arrayl addObject:model];
        
    }
    
    shopping.shoppingArray = arrayl;
    
}

#pragma mark 底部视图
- (void)bottomView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 75, SCREEN_WIDTH, 75)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    _allChooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 35, 35)];
    [view addSubview:_allChooseBtn];
    [_allChooseBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [_allChooseBtn addTarget:self action:@selector(allSeleted) forControlEvents:UIControlEventTouchUpInside];
    _allLabel = [UILabel new];
    _allLabel.text = @"全部";
    [view addSubview:_allLabel];
    [_allLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.and.top.equalTo(_allChooseBtn);
        make.left.equalTo(_allChooseBtn.right).offset(5);
    }];
    _allLabel.textColor = RGB(72, 73, 75);
    _allLabel.hidden = YES;
    
    _settlementBtn  = [UIButton new];
    [view addSubview:_settlementBtn];
    [_settlementBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.right.and.bottom.and.top.mas_equalTo(0);
    }];
    _settlementBtn.backgroundColor = RGB(229, 88, 7);
    _settlementBtn.tintColor = [UIColor whiteColor];
    [_settlementBtn setTitle:@"结算(0)" forState:UIControlStateNormal];
    [_settlementBtn addTarget:self action:@selector(SettlementBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _allPriceLabel = [UILabel new];
    [view addSubview:_allPriceLabel];
    _allPriceLabel.textAlignment = NSTextAlignmentRight;
    [_allPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.equalTo(_settlementBtn.left).offset(-5);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    _allPriceLabel.text = @"总价:￥0.00";
    _allPriceLabel.textColor = RGB(72, 73, 75);
    
    _freightLabel = [UILabel new];
    [view addSubview:_freightLabel];
    _freightLabel.text = @"运费和服务费(当面付)";
    _freightLabel.textColor = RGB(72, 73, 75);
    _freightLabel.textAlignment = NSTextAlignmentRight;
    _freightLabel.font = [UIFont systemFontOfSize:14];
    [_freightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allPriceLabel.bottom).offset(1);
        make.right.equalTo(_allPriceLabel);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
}
#pragma mark 编辑
- (void)clickRightButton:(UIButton *)sender{
    if (editbool) {
        editbool = NO;
    }else{
        editbool = YES;
        
        
    }
    
    [sender setTitle:editbool?@"完成":@"编辑" forState:UIControlStateNormal];
    [_settlementBtn setTitle:editbool?@"删除":[NSString stringWithFormat:@"%@(%@)",@"结算",numString] forState:UIControlStateNormal];
    _allPriceLabel.hidden = editbool;
    _freightLabel.hidden = editbool;
    _allLabel.hidden = !editbool;
    
}

#pragma mark 返回
- (IBAction)ReturnBtn:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 全选
- (void)allSeleted{
    [shopping allBtn:!isbool];
}
#pragma mark 全选

-(void)setAllBtnState:(BOOL)_bool{
    
    if (_bool) {
        [_allChooseBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        isbool = NO;
        
    }else{
        [_allChooseBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        isbool = YES;
    }
}

#pragma mark 结算
- (void)SettlementBtn{
    if (editbool) {
        
//        [shopping deleteBtn:editbool];
        DataProviderOther *request = [[DataProviderOther alloc] init];
        [request setDelegateObject:self setSucceedBackFunctionName:@"DeleteForBasketWithlist_detailCallBack:" setFailBackFunctionName:nil];
        
        
        NSMutableArray * prmarray=[[NSMutableArray alloc] init];
        for (ShoppingCellModel * model in cellArray) {
            [prmarray addObject:model.ID];
        }
        [request DeleteForBasketWithlist_detail:[Toolkit NSArrayToJsonString:prmarray]];
        
    }else{
        
        NSLog(@"结算:%@价格:%@",cellArray, _allPriceLabel.text);
       
        DataProviderOther *request = [[DataProviderOther alloc] init];
        [request setDelegateObject:self setSucceedBackFunctionName:@"BuildBillCallBack:" setFailBackFunctionName:nil];
        
        
        
        NSMutableArray * prmarray=[[NSMutableArray alloc] init];
        for (ShoppingCellModel * model in cellArray) {
//            NSMutableDictionary *billDict = [NSMutableDictionary dictionary];
//            [billDict setObject:model.ID forKey:@"ProductId"];
//            [billDict setObject:model.title forKey:@"ProductName"];
//            [billDict setObject:model.price forKey:@"ProductPrice"];
//            //
//            [billDict setObject:@"0" forKey:@"ProductPriceId"];
//            [billDict setObject:model.color forKey:@"ProductPriceName"];
//            [billDict setObject:[NSString stringWithFormat:@"%ld",(long)model.numInt] forKey:@"ProductNum"];
            [prmarray addObject:model.ID];
        }
        [request SubmitBasketWithlist_detail:[Toolkit NSArrayToJsonString:prmarray]];
        
    }
}

-(void)BuildBillCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        SubmitTuanGouOrderViewController * submitOrderVC=[[SubmitTuanGouOrderViewController alloc] init];
        submitOrderVC.orderDetial=dict[@"data"];
        [self.navigationController pushViewController:submitOrderVC animated:YES];
    }
}

-(void)DeleteForBasketWithlist_detailCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [self GetShoppingCarData];
    }
}
- (UITableView *)TroTableView{
    if (!_TroTableView) {
        _TroTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
        _TroTableView.delegate = self;
        _TroTableView.dataSource = self;
    }
    return _TroTableView;
}
#pragma mark tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (ShoppingCarArray) {
        return ShoppingCarArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * itemArray=[[NSArray alloc] initWithArray:ShoppingCarArray[section][@"BillDetailList"]];
    if (itemArray.count>0) {
        return itemArray.count;
    }
    return 0;
}
#pragma mark tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"ident";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIButton *leftBtn = [UIButton new];
    [cell.contentView addSubview:leftBtn];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(30);
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(35);
    }];
    UIImageView *imgView = [UIImageView new];
    [cell.contentView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.right).offset(10);
        make.top.mas_equalTo(10);
        make.width.and.height.mas_equalTo(75);
    }];
    imgView.backgroundColor = [UIColor blueColor];
    
    
    UILabel *title = [UILabel new];
    [cell.contentView addSubview:title];
    title.text = @"一岁宝宝拖车轻巧方便";
    title.textColor = RGB(55, 55, 57);
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(16);
        make.left.equalTo(imgView.right).offset(5);
    }];
    
    UILabel *color = [UILabel new];
    [cell.contentView addSubview:color];
    color.text = @"颜色:红色";
    color.textColor = RGB(55, 55, 57);
    color.font = [UIFont systemFontOfSize:14];
    [color makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
        make.top.equalTo(title.bottom).offset(2);
        make.left.equalTo(title);
    }];
    
    UILabel *size = [UILabel new];
    [cell.contentView addSubview:size];
    size.text = @"颜色:红色";
    size.font = [UIFont systemFontOfSize:14];
    size.textColor = RGB(55, 55, 57);
    [size makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
        make.top.equalTo(color);
        make.left.equalTo(color.right).offset(5);
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView vi:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = RGB(235, 235, 242);
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
