//
//  EditAddressViewController.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/7.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "EditAddressViewController.h"
#import "AddressRequest.h"
#import "Main_mapViewController.h"

#define _CELLHEIGHT     40
#define Gapleft         15
#define _CELL       (cell.contentView)


@interface EditAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic) UITableView *mainTableView;
@property(nonatomic) UITextField *nameField;
@property(nonatomic) UITextField *phoneField;
@property(nonatomic) UITextField *addressField;
@property(nonatomic) UITextField *addressNumField;
@property(nonatomic) UIButton *boyBtn;
@property(nonatomic) UIButton *girlBtn;

@property(nonatomic)UIButton *commitBtn;

@end

@implementation EditAddressViewController
{
    NSDictionary * locationDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

-(void)initViews
{
    if (self.addressModel == nil) {
        self.navtitle = @"新增收货地址";
    }
    else
    {
        self.navtitle = @"编辑收货地址";
    }
    self.tapGesture.enabled = YES;
    self.tapGesture.delegate = self;
    [self addLeftButton:@"fanhui"];
    [self addRightButton:@"Shape-60"];
    [self.view addSubview:self.mainTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(select_address_compliat:) name:@"select_address_compliat" object:nil];
}
-(void)select_address_compliat:(NSNotification *)notice
{
    DLog(@"%@",notice.object);
    locationDict=[[NSDictionary alloc] initWithDictionary:notice.object];
    self.addressField.text=[NSString stringWithFormat:@"%@%@",locationDict[@"address"],locationDict[@"name"]];
    
}

#pragma mark - gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    
    if (gestureRecognizer == self.tapGesture) {
        if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"])
        {
            return NO;
        }
    }
    
    return  YES;
}

#pragma mark - self tools

-(NSError *)checkInfo
{
    if (!self.nameField.hasText) {
        return [NSError errorWithDomain:@"请输入姓名" code:1 userInfo:nil];
    }
    
    if (!self.phoneField.hasText) {
        return [NSError errorWithDomain:@"请输入手机号" code:2 userInfo:nil];
    }
    
    if (self.boyBtn.selected == NO && self.girlBtn.selected == NO) {
        return [NSError errorWithDomain:@"请选择性别" code:3 userInfo:nil];
    }
    
    if (!self.addressField.hasText) {
        return [NSError errorWithDomain:@"请输入地址" code:4 userInfo:nil];
    }
    
    return nil;
}

#pragma mark - self datasource

-(void)addAddress
{
    NSError *err = [self checkInfo];
    
    if (err != nil) {
        
        [SVProgressHUD showErrorWithStatus:err.domain];
        return;
    }
    
//    [SVProgressHUD showWithStatus:@"保存地址中"];
//    AddressRequest *request = [[AddressRequest alloc] init];
//    [request setDelegateObject:self setSucceedBackFunctionName:@"addAddressCallBack:" setFailBackFunctionName:nil];
//    [request addAddressWithDetail:ZY_NSStringFromFormat(@"%@%@",self.addressField.text,self.addressNumField.text) andAreaid:@"0" andLat:@"116" andLng:@"25"];
    NSString *sex = @"";
    
    if (self.boyBtn.selected == YES) {
        sex = @"0";
    }
    else if(self.girlBtn.selected == YES)
    {
        sex = @"1";
    }
    

    
}
//
//-(void)addAddressCallBack:(id)dict
//{
//    ELog(dict);
//    if (RequestSuccess(dict)) {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:ErrorMessage(dict)];
//    }
//}


-(void)EditAddress
{
    NSError *err = [self checkInfo];
    
    if (err != nil) {
        
        [SVProgressHUD showErrorWithStatus:err.domain];
        return;
    }
    
//    [SVProgressHUD showWithStatus:@"保存地址中"];
//    AddressRequest *request = [[AddressRequest alloc] init];
//    [request setDelegateObject:self setSucceedBackFunctionName:@"addAddressCallBack:" setFailBackFunctionName:nil];
    NSString *sex = @"";
    if (self.boyBtn.selected == YES) {
        sex = @"0";
    }
    else if(self.girlBtn.selected == YES)
    {
        sex = @"1";
    }
    
//    [request eidtAddressWithId:self.addressModel.Address_Id
//                        Detail:self.addressField.text
//                     andAreaid:@"0"
//                        andLat:locationDict[@"lat"]
//                        andLng:locationDict[@"lon"]
//                        andSex:sex
//                      andPhone:self.phoneField.text
//                       andName:self.nameField.text
//                   andHouseNum:self.addressNumField.text];
}




#pragma mark - action

-(void)clickRightButton:(UIButton *)sender
{
    if (locationDict==nil) {
//        [YJXStatusHUD showError:@"请选择地址"];
        return;
    }
    if (self.addressModel == nil) {
        [self addAddress];
    }
    else
    {
        [self EditAddress];
    }
    
}

-(void)addrBtnClick:(UIButton *)sender
{
    NSLog(@"--------------");
    
    Main_mapViewController * mainVC=[[Main_mapViewController alloc] init];
    UINavigationController * mainnavi=[[UINavigationController alloc] initWithRootViewController:mainVC];
    [self showViewController:mainnavi sender:nil];
    
    
    
}

-(void)sexBtnClick:(UIButton *)sender
{
    sender.selected = YES;
    if (sender == self.boyBtn) {
        self.girlBtn.selected = NO;
    }
    else if (sender == self.girlBtn) {
        self.boyBtn.selected = NO;
    }
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }
    return 2;
}

#pragma mark - setting for cell

#define ViewsGaptoLine 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                [_CELL addSubview:self.nameField];
            }
                break;
            case 1:
            {
                self.boyBtn.center = CGPointMake(SCREEN_WIDTH/8.0 * 3, _CELLHEIGHT/2);
                [_CELL addSubview:self.boyBtn];
                
                self.girlBtn.center = CGPointMake(SCREEN_WIDTH/8.0 * 5, _CELLHEIGHT/2);
                [_CELL addSubview:self.girlBtn];
            }
                break;
            case 2:
            {
                [_CELL addSubview:self.phoneField];
            }
                break;
            default:
                break;
        }
    }
    
    if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                [_CELL addSubview:self.addressField];
            }
                break;
            case 1:
            {
                [_CELL addSubview:self.addressNumField];
            }
                break;
                
            default:
                break;
        }
    }
    
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  _CELLHEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark - setting for section
//设置section footer的高度

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"联系人";
    }
    else if (section == 1)
    {
        return @"收货地址";
    }
    
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
    
}

//#pragma mark - 去掉粘连
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView//取消tableview的粘连
//{
//    CGFloat sectionHeaderHeight = 10;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    }
//    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}


#pragma mark - property

-(UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height , SCREEN_WIDTH, SCREEN_HEIGHT -Header_Height )];
        _mainTableView.backgroundColor = BACKGROUND_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        
        [_mainTableView.tableFooterView addSubview:self.commitBtn];
    }
    
    return _mainTableView;
}


-(void)setAddressModel:(AddressModel *)addressModel
{
    _addressModel = addressModel;
    
    if (_addressModel !=nil) {
        self.nameField.text = _addressModel.Address_name;
        self.phoneField.text = _addressModel.Address_phone;
        if ([_addressModel.Address_sex isEqualToString:@"男"]) {
            self.boyBtn.selected = YES;
            self.girlBtn.selected = NO;
        }
        else
        {
            self.boyBtn.selected = NO;
            self.girlBtn.selected = YES;
        }
        self.addressField.text = _addressModel.Address_addr;
        self.addressNumField.text = _addressModel.Address_Num;
    }
}



-(UITextField *)nameField
{
    if (_nameField == nil) {
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(Gapleft, 0, SCREEN_HEIGHT - Gapleft*2, _CELLHEIGHT)];
        _nameField.font = [UIFont systemFontOfSize:14];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(Gapleft,0 ,50 , _CELLHEIGHT)];
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.text = @"姓名:";
        _nameField.leftView = nameLab;
        _nameField.leftViewMode = UITextFieldViewModeAlways;
        
        _nameField.placeholder = @"请填写收货人名字";
        
    }
    return _nameField;
}



-(UITextField *)phoneField
{
    if (_phoneField == nil) {
        _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(Gapleft, 0, SCREEN_HEIGHT - Gapleft*2, _CELLHEIGHT)];
        _phoneField.font = [UIFont systemFontOfSize:14];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(Gapleft,0 ,50 , _CELLHEIGHT)];
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.text = @"手机:";
        _phoneField.leftView = nameLab;
        _phoneField.leftViewMode = UITextFieldViewModeAlways;
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        
        _phoneField.placeholder = @"请填写您的手机号";
        
    }
    return _phoneField;
}

-(UIButton *)boyBtn
{
    if (_boyBtn == nil) {
        _boyBtn = [[UIButton alloc] init];
        _boyBtn.bounds = CGRectMake(0, 0, 40, _CELLHEIGHT);
        [_boyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_boyBtn setTitle:@"男" forState:UIControlStateNormal];
        [_boyBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        [_boyBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [_boyBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _boyBtn;
}


-(UIButton *)girlBtn
{
    if (_girlBtn == nil) {
        _girlBtn = [[UIButton alloc] init];
        _girlBtn.bounds = CGRectMake(0, 0, 40, _CELLHEIGHT);
        [_girlBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_girlBtn setTitle:@"女" forState:UIControlStateNormal];
        [_girlBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        [_girlBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [_girlBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _girlBtn;
}

-(UITextField *)addressField
{
    if (_addressField == nil) {
        _addressField = [[UITextField alloc] initWithFrame:CGRectMake(Gapleft, 0, SCREEN_HEIGHT - Gapleft*2, _CELLHEIGHT)];
        _addressField.font = [UIFont systemFontOfSize:14];
        _addressField.placeholder = @"点击选择";
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 125, _CELLHEIGHT)];
        UILabel *tiplib = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 105, _CELLHEIGHT)];
        tiplib.font = [UIFont systemFontOfSize:14];
        tiplib.text = @"小区/大厦/学校:";
        UIButton *addrBtn = [[UIButton alloc] initWithFrame:CGRectMake(105, 0, 20, _CELLHEIGHT)];
        [addrBtn setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
        [addrBtn addTarget:self action:@selector(addrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:tiplib];
        [leftView addSubview:addrBtn];
        _addressField.leftView = leftView;
        _addressField.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return _addressField;
}

-(UITextField *)addressNumField
{
    if (_addressNumField == nil) {
        _addressNumField = [[UITextField alloc] initWithFrame:CGRectMake(Gapleft, 0, SCREEN_HEIGHT - Gapleft*2, _CELLHEIGHT)];
        _addressNumField.font = [UIFont systemFontOfSize:14];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(Gapleft,0 ,100 , _CELLHEIGHT)];
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.text = @"楼号－门牌号：";
        _addressNumField.leftView = nameLab;
        _addressNumField.leftViewMode = UITextFieldViewModeAlways;
        
        _addressNumField.placeholder = @"例如：16号楼1601室";
        
    }
    return _addressNumField;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, SCREEN_WIDTH-60, 40)];
        _commitBtn.backgroundColor = ORANGE_COLOR;
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}
-(void)commitClick:(UIButton *)button{
    
    NSError *err = [self checkInfo];
    if (err) {
        return [SVProgressHUD showErrorWithStatus:err.domain];
    }
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"addAddressCallBack:" setFailBackFunctionName:nil];
    [dataProvider addAddressWithId:(_isEdit?_addressModel.Address_Id:@"0")
                     addressdetail:[NSString stringWithFormat:@"%@%@",_addressField.text,_addressNumField.text]
                            areaid:@""
                         isdefault:@"0"
                               lat:@""
                               lng:@""
                            shopid:[Toolkit getUserDefaultByKey:user_ID]
                             phone:_phoneField.text
                          postcode:@""
                              name:_nameField.text];
}
-(void)addAddressCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        if (_isEdit) {
            [SVProgressHUD showSuccessWithStatus:@"地址修改成功"];
        }
        else{
            [SVProgressHUD showSuccessWithStatus:@"地址添加成功"];
        }
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:AddressVCRefresh object:nil];
    }
    else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
