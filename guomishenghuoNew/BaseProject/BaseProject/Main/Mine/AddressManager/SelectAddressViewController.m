//
//  SelectAddressViewController.m
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/20.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "AddressTableViewCell.h"


@interface SelectAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic) UITableView *mainTableView;
@property(nonatomic) AddressModel *selectAddr;
@end

@implementation SelectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}


-(void)initViews
{
    [self addLeftButton:@"fanhui"];
    self.navtitle = @"选择地址";
    [self.view addSubview:self.mainTableView];
}

#pragma mark -  tableview  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.addressArr.count;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

#pragma mark - setting for cell

#define ViewsGaptoLine 20
//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier = ZY_NSStringFromFormat(@"Cell%ld",(long)indexPath.section);
    
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = ZY_NSStringFromFormat(@"%@    %@",self.addressArr[indexPath.section].Address_name,self.addressArr[indexPath.section].Address_phone);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.detailTextLabel.text = self.addressArr[indexPath.section].Address_addr;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    cell.tag = indexPath.section;
    return cell;
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark - setting for section
//设置section footer的高度

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
    
}

#pragma mark - 去掉粘连
- (void)scrollViewDidScroll:(UIScrollView *)scrollView//取消tableview的粘连
{
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark - property
-(UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height , SCREEN_WIDTH, SCREEN_HEIGHT -Header_Height  )];
        _mainTableView.backgroundColor = BACKGROUND_COLOR;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        
    }
    
    return _mainTableView;
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
