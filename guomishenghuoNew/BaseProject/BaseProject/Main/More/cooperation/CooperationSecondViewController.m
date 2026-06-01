//
//  CooperationSecondViewController.m
//  BaseProject
//
//  Created by Wangjc on 16/10/5.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CooperationSecondViewController.h"
#import "CooperationTableViewCell.h"
#import "DataProviderOther.h"
#import "MyPickerView.h"

#define CellHeight 45

@interface CooperationSecondViewController ()

<UITableViewDataSource,UITableViewDelegate,MyPickerViewDelegate,UITextFieldDelegate>

@property(nonatomic)UITableView *tableView;
@property(nonatomic)UIButton *commitBtn;

@property(nonatomic)NSArray *section_title_1;
@property(nonatomic)NSArray *section_title_2;
@property(nonatomic)NSArray *section_detail_1;
@property(nonatomic)NSArray *section_detail_2;
@property(nonatomic)MyPickerView  *myPickerView;

@end

@implementation CooperationSecondViewController
{
    NSArray * fenleiArray;
    NSString * firstfenleiName;
    NSString * firstfenleiId;
    NSString * secondfenleiName;
    NSString * secondfenleiId;
    NSMutableDictionary * textDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetAllFenLei];
    firstfenleiId=@"0";
    firstfenleiName=@"请选择";
    secondfenleiId=@"0";
    secondfenleiName=@"请选择";
    textDict=[[NSMutableDictionary alloc] init];
    self.tapGesture.enabled=YES;
    self.navtitle = @"我要合作";
    [self addLeftButton:@"fanhui"];
    
    [self createViews];
}

-(void)createViews{
    
    _section_title_1 = @[@"商家账号",
                         @"密码"];
    _section_detail_1 = @[@"请输入商家账号",
                          @"请输入店铺密码"];
    _section_title_2 = @[@"店铺名称",
                         @"详细地址",
                         @"联系电话"];
    _section_detail_2 = @[@"请输入店铺名称",
                          @"请输入详细地址",
                          @"请输入联系人电话"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT-Header_Height)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.tableFooterView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20+CellHeight)];
    
    _commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH-60, CellHeight)];
    _commitBtn.backgroundColor = ORANGE_COLOR;
    [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(Submit) forControlEvents:UIControlEventTouchUpInside];
    [_tableView.tableFooterView addSubview:_commitBtn];
    
    [self.view addSubview:self.tableView];
    
    _commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_tableView.frame)+10, SCREEN_WIDTH-60, CellHeight)];
    _commitBtn.backgroundColor = ORANGE_COLOR;
    [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(Submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitBtn];
}

#pragma mark ----- number of sections and rows -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
        return 3;
    }
    else{
        return 1;
    }
}

#pragma mark ----- view for section header -----
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = BACKGROUND_COLOR;
    UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
    tipLbl.font = [UIFont systemFontOfSize:17];
    tipLbl.textColor = [UIColor orangeColor];
    
    if (section == 0) {
        tipLbl.text = @"店铺经营信息";
        [view addSubview:tipLbl];
    }
    else if (section == 1){
        tipLbl.text = @"店铺基本信息";
        [view addSubview:tipLbl];
    }
    else{
        
    }
    return view;
}

#pragma mark ----- heigth for row and section -----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2){
        return 90;
    }
    else{
        return CellHeight;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2){
        return 15;
    }
    else{
        return 40;
    }
}

#pragma mark ----- setting for cell -----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CooperationTableViewCell *cell = [[CooperationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        cell.title.text = _section_title_1[indexPath.row];
        cell.detail.placeholder = _section_detail_1[indexPath.row];
        cell.detail.delegate=self;
        cell.detail.tag=(indexPath.section*10+indexPath.row);
        return cell;
    }
    if (indexPath.section == 1){
        cell.title.text = _section_title_2[indexPath.row];
        cell.detail.placeholder = _section_detail_2[indexPath.row];
        cell.detail.delegate=self;
        cell.detail.tag=(indexPath.section*10+indexPath.row);
        return cell;
    }
    if (indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *starSymbol = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 25, CellHeight)];
        starSymbol.text = @"*";
        starSymbol.textColor = [UIColor orangeColor];
        [cell.contentView addSubview:starSymbol];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10+25, 0, 100, CellHeight)];
        title.text = @"经营类目";
        title.textColor = [UIColor darkGrayColor];
        title.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:title];
        
        CGFloat btnWidth = (SCREEN_WIDTH-(10*3))/2;
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, CellHeight, btnWidth, 30)];
        [btn1 setImage:[UIImage imageNamed:@"fenleisanjiao"] forState:UIControlStateNormal];
        [btn1 setTitle:firstfenleiName forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn1 addTarget:self action:@selector(showPickerView) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn1.layer.borderWidth = 0.5;
        [cell.contentView addSubview:btn1];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+10, CellHeight, btnWidth, 30)];
        [btn2 setImage:[UIImage imageNamed:@"fenleisanjiao"] forState:UIControlStateNormal];
        [btn2 setTitle:secondfenleiName forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(showPickerView) forControlEvents:UIControlEventTouchUpInside];
        btn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn2.layer.borderWidth = 0.5;
        [cell.contentView addSubview:btn2];
        
        
        return cell;
    }
    else{
        return nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    DLog(@"%ld0000000%@",(long)textField.tag,textField.text);
    switch (textField.tag/10) {
        case 0:
        {
            switch (textField.tag%10) {
                case 0:
                {
                    if (textField.text.length>0) {
                        [textDict setObject:textField.text forKey:@"ShopCount"];
                    }
                    
                }
                    break;
                case 1:
                {
                    if (textField.text.length>0) {
                        [textDict setObject:textField.text forKey:@"ShopPassWord"];
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (textField.tag%10) {
                case 0:
                {
                    if (textField.text.length>0) {
                        [textDict setObject:textField.text forKey:@"ShopName"];
                    }
                    
                }
                    break;
                case 1:
                {
                    if (textField.text.length>0) {
                        [textDict setObject:textField.text forKey:@"ShopAddress"];
                    }
                    
                }
                    break;
                case 2:
                {
                    if (textField.text.length>0) {
                        [textDict setObject:textField.text forKey:@"ShopTel"];
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
            default:
            break;
    }
}


-(void)Submit
{
    if (textDict.count<5) {
        [YJXStatusHUD showError:@"请确保信息完整"];
        return;
    }
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"SubmitCallBack:" setFailBackFunctionName:nil];
    
    [dataproviderother ApplyOpenShopWithusername:Zy_JudgeIsNull(textDict[@"ShopCount"]) andshopname:Zy_JudgeIsNull(textDict[@"ShopName"]) andpassword:Zy_JudgeIsNull(textDict[@"ShopPassWord"]) andaddress:Zy_JudgeIsNull(textDict[@"ShopAddress"]) andphone:Zy_JudgeIsNull(textDict[@"ShopTel"]) andcategoryid:[secondfenleiId isEqualToString:@"0"]?firstfenleiId:secondfenleiId];
}
-(void)SubmitCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        [YJXStatusHUD showSuccess:@"合作意向提交成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [YJXStatusHUD showError:dict[@"error"]];
    }
}
-(void)showPickerView
{
    [_myPickerView show];
}
-(void)GetAllFenLei
{
    DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
    [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetAllFenLeiCallBack:" setFailBackFunctionName:nil];
    [dataproviderother GetAllFenLei];
}
-(void)GetAllFenLeiCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        fenleiArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        _myPickerView=[[MyPickerView alloc] initWithMultiArr:fenleiArray];
        _myPickerView.delegate=self;
    }
}
-(void)pickerView:(MyPickerView *)pickerView selectComFirstIndex:(NSInteger)firstComIndex andselectComSecondIndex:(NSInteger)SecondComIndex
{
    DLog(@"dafgaghfag");
    firstfenleiName=ZY_NSStringFromFormat(@"%@",fenleiArray[firstComIndex][@"Name"]);
    firstfenleiId=ZY_NSStringFromFormat(@"%@",fenleiArray[firstComIndex][@"Id"]);
    NSArray * itemArray=[[NSArray alloc] initWithArray:fenleiArray[firstComIndex][@"Children"]];
    if (itemArray.count>0) {
        secondfenleiName=ZY_NSStringFromFormat(@"%@",itemArray[SecondComIndex][@"Name"]);
        secondfenleiId=ZY_NSStringFromFormat(@"%@",itemArray[SecondComIndex][@"Id"]);
    }
    else
    {
        secondfenleiName=@"";
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
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
