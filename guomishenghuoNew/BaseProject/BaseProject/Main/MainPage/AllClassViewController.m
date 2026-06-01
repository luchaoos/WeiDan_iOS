//
//  AllClassViewController.m
//  LikeAttention
//
//  Created by 王建成 on 15/11/19.
//  Copyright © 2015年 zykj.LikeAttention. All rights reserved.
//

#import "AllClassViewController.h"
#import "IndexCateViewController.h"

@interface AllClassViewController ()
{
    
    //datas
    NSDictionary * fenleidict;
    
    
    //views
    UITableView *_mainTableView;
    NSInteger _cellCount;
    NSInteger _sectionCount;
    NSInteger _cellCollectionCount;
    
    
    CGFloat _cellHeight;
    CGFloat _cellCollectionHeight;
    CGFloat _sectionHeight;
   // NSMutableArray *_cellHeightArr;
    CGFloat _cellHeightArr[100];
}


@property (nonatomic, strong) NSMutableArray *classifys;
@end

#define _CELL @ "acell"

@implementation AllClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDatas];
    
    [self getCategoryList];
    
    [self initViews];
    
    // Do any additional setup after loading the view.
}

-(void)initDatas
{
    _cellHeight = SCREEN_HEIGHT /3;
    _cellCount  = 1;
    _sectionCount = 1;
    _sectionHeight = 34;
    _lblTitle.text = _type_title;
    _cellCollectionCount = 16;
    _cellCollectionHeight = 44;
   // _cellHeightArr= [NSMutableArray array];
    _classifys = [NSMutableArray array];
}

-(void) initViews
{
    _lblTitle.text=@"全部分类";
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//UITableViewCellSeparatorStyleSingleLine;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 44)];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 44)];
    titleLab.text = @"";
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    [headView addSubview:titleLab];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(titleLab.frame.size.width+20 +10, 44/2, SCREEN_WIDTH - (titleLab.frame.size.width+20 +10), 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [headView addSubview:lineView];
    
    
    _mainTableView.tableHeaderView =headView;
    
    _mainTableView.backgroundColor =  UIColorFromRGBValue(0xeeeeee);
    [self.view addSubview:_mainTableView];
}




#pragma mark - 数据获取

-(void)getCategoryList
{

    DataProviderOther * dataprovider=[[DataProviderOther alloc] init];
    [dataprovider setDelegateObject:self setSucceedBackFunctionName:@"GetCateGoryCallBack:" setFailBackFunctionName:nil];
    [dataprovider GetAllFenLei];

}


-(void)GetCateGoryCallBack:(id)dict
{
    DLog(@"%@",dict);
    if (RequestSuccess(dict)) {
        NSArray * itemArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        for (int i=0; i<itemArray.count; i++) {
            [_classifys addObject:itemArray[i]];
        }
        
        _sectionCount = _classifys.count;
        fenleidict=dict[@"data"];
        
        
        [self setCollection];
        [_mainTableView reloadData];
     //   [self buildLIstmenu];
    }
}

-(void)setCollection
{
    
    NSDictionary *tempDict;
    NSArray *tempArr ;
    NSInteger categoryid;
    
    for(int i = 0;i<self.classifys.count;i++)
    {

        @try {
            tempDict = self.classifys[i];
            
            
            tempArr = [[NSArray alloc] initWithArray:[tempDict objectForKey:@"Children"]];
            
            _cellCollectionCount = tempArr.count;
            
            //_cellHeight =;
            
            _cellHeightArr[i] =  (_cellCollectionCount/3 +( _cellCollectionCount%3?1:0) + 1)*_cellCollectionHeight;
            //[_cellHeightArr addObject:[NSString stringWithFormat:@"%f",_cellHeight]];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
}

#pragma mark - setting for cell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionCount;
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _cellCount;
}

//设置每行调用的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _cellHeightArr[indexPath.section])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromRGBValue(0xeeeeee);
    
    
    
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置collection
    
    //  layout.itemSize = CGSizeMake(318, 286);
    
    // layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
    layout.headerReferenceSize = CGSizeMake(320, 200);
    
    
    
    UICollectionView *classCollectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH -20*2, _cellHeightArr[indexPath.section]) collectionViewLayout:layout];
    
    [layout setHeaderReferenceSize:CGSizeMake(classCollectionView.frame.size.width, 0)];//暂不现实时间
    
    [classCollectionView registerClass :[ UICollectionViewCell class ] forCellWithReuseIdentifier : _CELL ];
    
    classCollectionView.delegate= self;
    classCollectionView.dataSource =self;
    classCollectionView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    classCollectionView.showsHorizontalScrollIndicator = YES;
    classCollectionView.showsVerticalScrollIndicator = NO;
    classCollectionView.backgroundColor = UIColorFromRGBValue(0xeeeeee);
    
    classCollectionView.tag = indexPath.section;
    
    [cell addSubview:classCollectionView];
    
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 )
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
    
    
    
}

//设置cell每行间隔的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return _cellHeightArr[indexPath.section];//一定要和collection view的高度匹配否则会显示不出来
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线，
    
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
    NSMutableArray *numberRowOfCellArray = [NSMutableArray array] ;
    [numberRowOfCellArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"点击了删除  Section  = %ld Row =%ld",(long)indexPath.section,(long)indexPath.row);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _sectionHeight)];
    headView.backgroundColor =UIColorFromRGBValue(0xeeeeee);
    
    if(section > self.classifys.count - 1 || self.classifys.count == 0 || self.classifys ==nil)
         return headView;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, _sectionHeight)];
   
    
    titleLab.text = self.classifys[section][@"Name"];
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    [headView addSubview:titleLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(titleLab.frame.size.width+20 +10, _sectionHeight/2, SCREEN_WIDTH - (titleLab.frame.size.width+20 +10), 1)];
    lineView.backgroundColor = [UIColor grayColor];
    
    [headView addSubview:lineView];
    return headView;
}

//设置section的footer view
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    if(section == 0)
    {
        tempView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        tempView.backgroundColor =[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];//[UIColor colorWithRed:189/255.0 green:170/255.0 blue:152/255.0 alpha:1.0];
    }
    return tempView;
    
}


//设置section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _sectionHeight;
}
//设置section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}


#pragma mark - UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{

    NSDictionary *tempDict;
    NSArray *tempArr ;
    
    @try {
        tempDict = self.classifys[collectionView.tag];
        
        tempArr = [[NSArray alloc] initWithArray:[tempDict objectForKey:@"Children"]];
        
        _cellCollectionCount = tempArr.count;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return _cellCollectionCount;
    }
 // return _cellCollectionCount;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section < 2)
        return CGSizeMake(self.view.frame.size.width, 0);
    else
        return CGSizeMake(self.view.frame.size.width, 30);
}

//定义展示的Section的个数

-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1 ;
}

//每个UICollectionView展示的内容

-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier : _CELL forIndexPath :indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.frame =CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height) ;
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.textAlignment = NSTextAlignmentCenter;
    
    [cell addSubview:textLab];
    
    
    NSDictionary *tempDict;
    NSArray *tempArr ;
    
    @try {
        tempDict = self.classifys[collectionView.tag];
        tempArr = [[NSArray alloc] initWithArray:[tempDict objectForKey:@"Children"]];
        
        
        NSDictionary *tempDictForCell;
        tempDictForCell = tempArr[indexPath.row];
        textLab.text = [tempDictForCell objectForKey:@"Name"];
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
         return cell;
    }
    
}



#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    NSLog(@"click cell");
    NSDictionary *tempDict;
    NSArray *tempArr ;
    NSInteger categoryid;
    
    tempDict = self.classifys[collectionView.tag];
    tempArr = [[NSArray alloc] initWithArray:[tempDict objectForKey:@"Children"]];
    
    
    NSDictionary *tempDictForCell;
    tempDictForCell = tempArr[indexPath.row];

    IndexCateViewController * indexCateVC=[[IndexCateViewController alloc] init];
    indexCateVC.ParientID=[NSString stringWithFormat:@"%@",tempDictForCell[@"Id"]];
    [self.navigationController pushViewController:indexCateVC animated:YES];
    
}

//返回这个UICollectionViewCell是否可以被选择

-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    return YES ;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    return CGSizeMake ( (SCREEN_WIDTH - 20*2)/3 -4 , _cellCollectionHeight);
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    //return UIEdgeInsetsMake ( 1 , 0.5 , 1 , 0.5 );
    return UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );
}


-(void)viewWillAppear:(BOOL)animated
{
    [_app_ hiddenTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
