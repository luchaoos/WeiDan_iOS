//
//  SelectCityViewController.m
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "SelectCityViewController.h"
#import "MJRefresh.h"
#import "ChineseString.h"
#import "CCLocationManager.h"
#import "DataProviderOther.h"

@interface SelectCityViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate>
{
    NSDictionary *cityinfoWithFile;
    UIButton *locateBtn;
}
@property(nonatomic)UITableView *tableView;
@property(nonatomic)UISearchBar *searchBar;
@property(nonatomic)NSMutableArray *datalist;
@property(nonatomic)NSMutableArray *cityDicArray;
@property(nonatomic,retain)NSMutableArray *indexArray;
@property(nonatomic,retain)NSMutableArray *LetterResultArr;

@end

@implementation SelectCityViewController {
    NSDictionary * searchIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navtitle = @"城市选择";
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)loadData {
    [SVProgressHUD showWithStatus:@"正在加载数据..."];
    // 获取所有的城市
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setSucceedBackFunctionName:@"getAllCityCallBack:" setFailBackFunctionName:nil];
    [dataProvider getAllCity];
}
- (void)getAllCityCallBack:(id)dict {
    NSLog(@"%@",dict);
    _datalist = [NSMutableArray array];
    _cityDicArray = [NSMutableArray array];
    NSArray *dataArray = dict[@"data"];
    for (int i = 0; i < dataArray.count; i++){
        NSArray *childrenArr = dataArray[i][@"Children"];
        if (childrenArr.count>0) {
            for (int j = 0; j < childrenArr.count; j++) {
                [_cityDicArray addObject:childrenArr[j]];
            }
        }
        else{
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:dataArray[i][@"Id"] forKey:@"Id"];
            [dic setObject:dataArray[i][@"Name"] forKey:@"Name"];
            
            [_cityDicArray addObject:dic];
        }
    }
    NSLog(@"%@",_cityDicArray);
    for (int i=0; i<_cityDicArray.count; i++) {
        [_datalist addObject:_cityDicArray[i][@"Name"]];
    }
    self.indexArray = [ChineseString IndexArray:_datalist];
    self.LetterResultArr = [ChineseString LetterSortArray:_datalist];
    
    [self createViews];
    [SVProgressHUD dismiss];
}

-(void)createViews{
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 30)];// 初始化，不解释
    self.searchBar.delegate=self;
    [self.searchBar setPlaceholder:@"请输入您要搜索的城市名称"];// 搜索框的占位符
    [self.searchBar setBarStyle:UIBarStyleDefault];// 搜索框样式
    [self.searchBar setTintColor:[UIColor blackColor]];// 搜索框的颜色，当设置此属性时，barStyle将失效
    [self.searchBar setTranslucent:YES];// 设置是否透明
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"image0"]];// 设置背景图片
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"image3"] forState:UIControlStateNormal];// 设置搜索框中文本框的背景
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"image0"] forState:UIControlStateHighlighted];
    [self.searchBar setSearchFieldBackgroundPositionAdjustment:UIOffsetMake(0, 0)];// 设置搜索框中文本框的背景的偏移量
    
    [self.searchBar setSearchResultsButtonSelected:NO];// 设置搜索结果按钮是否选中
    [self.searchBar setShowsSearchResultsButton:NO];// 是否显示搜索结果按钮
    
    [self.searchBar setSearchTextPositionAdjustment:UIOffsetMake(0, 0)];// 设置搜索框中文本框的文本偏移量
    
    
    
//    [self.searchBar setInputAccessoryView:_btnHide];// 提供一个遮盖视图
    [self.searchBar setKeyboardType:UIKeyboardTypeEmailAddress];// 设置键盘样式
    [self.view addSubview:self.searchBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height+42, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.tableHeaderView = [self createTableHeaderView];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"---%@",searchBar.text);
    [self.searchBar resignFirstResponder];// 放弃第一响应者
    
    
    if (_cityDicArray) {
        for (NSDictionary * cityname in _cityDicArray) {
            NSRange range=[cityname[@"Name"] rangeOfString:searchBar.text];
            if (range.length>0) {
                UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"搜索结果" message:cityname[@"Name"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
                [alert show];
                searchIndex=[[NSDictionary alloc] initWithDictionary:cityname];
                break;
            }
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        set_sp(@"city_Id",ZY_NSStringFromFormat(@"%@",searchIndex[@"Id"]));
        set_sp(@"city_Name", searchIndex[@"Name"]);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeCity" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (UIView *)createTableHeaderView {
    
    UIView *tableHeaderVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    tableHeaderVeiw.backgroundColor=[UIColor whiteColor];
    
    UILabel *locatingLbl =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 25)];
    locatingLbl.text = @"当前定位城市";
    locatingLbl.font = [UIFont systemFontOfSize:14];
    [tableHeaderVeiw addSubview:locatingLbl];

    UIView *locateBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(locatingLbl.frame), SCREEN_WIDTH, 40)];
    locateBackView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [tableHeaderVeiw addSubview:locateBackView];

    locateBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(locateBackView.frame)+8, 100, 24)];
    [locateBtn setTitle:@"正在定位中..." forState:UIControlStateNormal];
    locateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [locateBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    locateBtn.backgroundColor = [UIColor whiteColor];
    locateBtn.tag = 0;
    [locateBtn addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
    [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {
        DLog(@"%@",addressString);
        
        DataProviderOther * dataproviderother=[[DataProviderOther alloc] init];
        [dataproviderother setDelegateObject:self setSucceedBackFunctionName:@"GetCityInfoCallBack:" setFailBackFunctionName:nil];
        [dataproviderother GetCityInfo:addressString];
    }];
    [tableHeaderVeiw addSubview:locateBtn];

    UILabel *latelyCity = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(locateBackView.frame), SCREEN_WIDTH-20, 25)];
    latelyCity.text = @"最近访问的城市";
    latelyCity.font = [UIFont systemFontOfSize:14];
    [tableHeaderVeiw addSubview:latelyCity];

    UIView *latelyBackView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(latelyCity.frame), SCREEN_WIDTH, 40)];
    latelyBackView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [tableHeaderVeiw addSubview:latelyBackView];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
    cityinfoWithFile = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *array = [[NSArray alloc] initWithArray:cityinfoWithFile[@"history"]];
    if (cityinfoWithFile[@"history"]) {
        if (array.count > 0) {
            CGFloat width = (SCREEN_WIDTH-40)/3;
            int num = 0;
            if (array.count >= 3) {
                num = 3;
            }
            else
            {
                num = (int)array.count;
            }
            for (int i = (int)array.count-1; i > ((int)array.count-num-1); i--) {
                UIButton *btn_historyItem = [[UIButton alloc] initWithFrame:CGRectMake(width * (( array.count  - i -1 )%3)+10*((array.count - i -1)%3+1), CGRectGetMaxY(latelyCity.frame)+8,width, 24)];
                btn_historyItem.titleLabel.font = [UIFont systemFontOfSize:15];
                NSString *cityName = array[i][@"Name"];
                NSInteger tag = [array[i][@"Id"] intValue];
                if(tag == 0)
                {
                    tag = [array[i][@"id"] intValue];
                }
                [btn_historyItem setTitle:cityName forState:UIControlStateNormal];
                btn_historyItem.tag=tag;
                
                [btn_historyItem setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
                btn_historyItem.backgroundColor=[UIColor whiteColor];
                [btn_historyItem addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
                [tableHeaderVeiw addSubview:btn_historyItem];
            }
        }
    }
    return tableHeaderVeiw;
}

- (void)btn_click:(UIButton *)button {
    if (button.tag != 0) {
        BOOL isExist = NO;
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:cityinfoWithFile[@"history"]];
        if (array) {
            for (NSDictionary *item in array) {
                if ([item[@"Name"] isEqualToString:button.currentTitle]) {
                    isExist=YES;
                    break;
                }
            }
            if (!isExist) {
                NSDictionary * dict=[[ NSDictionary alloc] initWithObjectsAndKeys:button.currentTitle,@"Name",
                                     [NSString stringWithFormat:@"%ld",(long)button.tag],@"Id", nil];
                [array addObject:dict];
            }
            
            NSDictionary * areaData=@{@"Id":[NSString stringWithFormat:@"%ld",(long)button.tag],@"Name":button.currentTitle,@"history":array};
            [self saveCityInfo:areaData andIsClose:YES];
            set_sp(@"city_Id",ZY_NSStringFromFormat(@"%ld",(long)button.tag));
            set_sp(@"city_Name", button.currentTitle);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeCity" object:nil];
        }
    }
}
-(void)GetCityInfoCallBack:(id)dict
{
//    if (RequestSuccess(dict)) {
//        DLog(@"%@",dict);
//        [locateBtn setTitle:dict[@"data"][@"Name"] forState:UIControlStateNormal];
//        locateBtn.tag=[dict[@"data"][@"Id"] integerValue];
//    }
    @try {
        if (RequestSuccess(dict)) {
            DLog(@"%@",dict);
            [locateBtn setTitle:dict[@"data"][@"Name"] forState:UIControlStateNormal];
            locateBtn.tag=[dict[@"data"][@"Id"] integerValue];
        }
    } @catch (NSException *exception) {
        
        [locateBtn setTitle:@"临沂市" forState:UIControlStateNormal];
        locateBtn.tag=30887;
    } @finally {
    }
}
#pragma mark ----- titleForHeaderInSection -----
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [_indexArray objectAtIndex:section];
    return key;
}

#pragma mark ----- 右方索引数组 -----
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexArray;
}

#pragma mark ----- sectionForSectionIndexTitle -----
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
#pragma mark ----- number of row and section -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.LetterResultArr objectAtIndex:section] count];
}

#pragma mark ----- height for row and section -----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

#pragma mark ----- cellForRowAtIndexPath -----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[[NSDictionary alloc] init];
    @try {
        NSLog(@"---->%@",[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
        //保存点击选中的城市名
        NSString *strCityName=[[self.LetterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        //保存选中的城市名所在的信息字典
        
        for (NSDictionary *item in _cityDicArray) {
            if ([item[@"Name"] isEqualToString:strCityName]) {
                dict=item;
            }
        }
        BOOL isExist = NO;
        NSMutableArray *array=[[NSMutableArray alloc] initWithArray:cityinfoWithFile[@"history"]];
        if (array) {
            for (NSDictionary *item in array) {
                if ([item[@"Name"] isEqualToString:dict[@"Name"]]) {
                    isExist=YES;
                    break;
                }
            }
            if (!isExist) {
                [array addObject:dict];
            }
            NSDictionary *areaData = @{@"Id":dict[@"Id"],@"Name":dict[@"Name"],@"history":array};
            [self saveCityInfo:areaData andIsClose:YES];
        }
        else
        {
            NSMutableArray * myarr=[[NSMutableArray alloc] initWithObjects:dict, nil];
            array=myarr;
        }
        NSDictionary * prm=[[NSDictionary alloc] initWithObjectsAndKeys:dict[@"Id"],@"Id",
                            dict[@"Name"],@"Name",
                            array,@"history",nil];
        [self saveCityInfo:prm andIsClose:YES];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        set_sp(@"city_Id", dict[@"Id"]);
        set_sp(@"city_Name", dict[@"Name"]);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeCity" object:nil];
    }
}

-(BOOL)saveCityInfo:(NSDictionary *)dict andIsClose:(BOOL) isClose
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
    BOOL result= [dict writeToFile:plistPath atomically:YES];
    if (result) {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CityInfo.plist"];
        cityinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        
        if (isClose) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        if([self.delegate respondsToSelector:@selector(outCitySetting:)])
        {
            [self.delegate outCitySetting:dict[@"Name"]];
        }
        
        
        
        
    }
    return result;
}

@end
