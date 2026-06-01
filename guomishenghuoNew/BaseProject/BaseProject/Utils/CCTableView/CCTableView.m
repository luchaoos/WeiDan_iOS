//
//  CCTableView.m
//  CCdoubleTableView
//
//  Created by 陈程 on 15/6/2.
//  Copyright (c) 2015年 陈程. All rights reserved.
//

#import "CCTableView.h"
#import "TakeOutModel.h"
#import "TakeOutViewCell.h"
#import "TakeOutHeader.h"
#import "CCBadgeButton.h"
#import "ShoppingCartModel.h"
#import "ShoppingCartManager.h"



@interface CCTableView()<UITableViewDataSource,UITableViewDelegate,TakeOutViewCellDelegate>
@property (nonatomic,weak) UITableView *leftTableView;
@property (nonatomic,weak) UITableView *rightTableView;
@property (nonatomic,weak) UILabel *totalPriceLabel;
@property (nonatomic,assign) NSInteger totalPrice;
@property (nonatomic,weak) CCBadgeButton *badge;
@property (nonatomic,strong) NSMutableArray *orderArray;
@property (nonatomic,strong) NSMutableArray * gaoduToScrollArray;
@end

@implementation CCTableView
{
    float lastContentOffset;
}

- (void)awakeFromNib
{
    self.orderArray = [NSMutableArray array];
    self.gaoduToScrollArray=[NSMutableArray array];
    [self initInterface];
}

- (void)initInterface
{
    
//    self.bounds=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TabBar_HEIGHT-44);
    //左边的tableview
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, 70*(SCREEN_WIDTH/320), SCREEN_HEIGHT-TabBar_HEIGHT-44-64) style:UITableViewStylePlain];
    leftTableView.tag = 1;
    leftTableView.dataSource = self;
    leftTableView.delegate = self;
    self.leftTableView = leftTableView;
    self.leftTableView.tableFooterView = [[UIView alloc] init];
    leftTableView.showsVerticalScrollIndicator = NO;
    if ([leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [leftTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([leftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [leftTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self addSubview:leftTableView];
    //右边tableview
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(80*(SCREEN_WIDTH/320), 0, [UIScreen mainScreen].bounds.size.width-80, SCREEN_HEIGHT-TabBar_HEIGHT-44-64) style:UITableViewStylePlain];
    rightTableView.tag = 2;
    rightTableView.dataSource = self;
    rightTableView.delegate = self;
    self.rightTableView = rightTableView;
    rightTableView.bounces = NO;
    rightTableView.showsVerticalScrollIndicator = NO;
    if ([rightTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [rightTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([rightTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [rightTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self addSubview:rightTableView];
    
    
    
//    [self initFooter];
}

-(void)JiSuanGaoDu
{
    CGFloat height_contentOffSet=0;
    for (NSDictionary * item in self.dataArray) {
        height_contentOffSet=[item[@"content"] count]*80+25+height_contentOffSet;
        [self.gaoduToScrollArray addObject:[NSNumber numberWithFloat:height_contentOffSet]];
    }
}



/**
 * 界面下方的条形栏
 */
- (void)initFooter
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40)];
    footer.backgroundColor = [UIColor clearColor];
    CALayer *back = [CALayer layer];
    back.frame = CGRectMake(0, 10, self.frame.size.width,30);
    back.backgroundColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:241/255.0 alpha:1].CGColor;
    [footer.layer addSublayer:back];
    [self addSubview:footer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(25, 0, 34, 34);
    button.layer.cornerRadius = 17;
    button.clipsToBounds = YES;
    [button setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [footer addSubview:button];
    
    UILabel *totleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+6, 24, 200, 10)];
    totleLabel.font = [UIFont systemFontOfSize:11];
    self.totalPriceLabel = totleLabel;
    [footer addSubview:totleLabel];
    
    UIButton *overbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    overbutton.frame = CGRectMake(self.frame.size.width-70, 10, 70, 30);
    overbutton.backgroundColor = [UIColor orangeColor];
    [overbutton setTitle:@"还差￥120起送" forState:UIControlStateNormal];
    [overbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    overbutton.titleLabel.font = [UIFont systemFontOfSize:9];
//    [overbutton addTarget:self action:@selector(overButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:overbutton];
    //购物车右上方的标记
    CCBadgeButton *badge = [[CCBadgeButton alloc] initWithFrame:CGRectMake(50, 3, 1, 1)];
    self.badge = badge;
    [footer addSubview:badge];
    
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    [self JiSuanGaoDu];
}
#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableView.tag==1 ? 1 :self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag==1 ? self.dataArray.count : [self.dataArray[section][@"content"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==1) {
        static NSString *ID = @"tabkeOutLeftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
                
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
        cell.contentView.backgroundColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:241/255.0 alpha:1];
        return cell;
    }else
    {
        TakeOutViewCell *cell = [[TakeOutViewCell alloc] cellWithTableView:tableView];
        cell.model = self.dataArray[indexPath.section][@"content"][indexPath.row];
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
}
#pragma mark - tableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        TakeOutHeader *header = [TakeOutHeader headerWithTableView:tableView];
        header.titleStr = self.dataArray[section][@"title"];
        return header;
    }else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableView.tag == 1 ? 0 : 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag== 1 ? 44:80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor orangeColor];
        NSArray * array=[[NSArray alloc] initWithArray:self.dataArray[indexPath.row][@"content"]];
        if ([array count]>0) {
            [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:UITableViewScrollPositionNone];
        }
        
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == 1 ? YES : NO;
}


/**
 *  滚动右侧，左侧联动
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollTag%lu",(unsigned long)self.gaoduToScrollArray.count);
    
    BOOL isset=NO;
    
    if (scrollView.tag==2) {
        
        for (int i=0; i<self.gaoduToScrollArray.count; i++) {
            NSNumber *floatNum=self.gaoduToScrollArray[i];
            if (scrollView.contentOffset.y<floatNum.floatValue) {
//                NSLog(@"%f",floatNum.floatValue);
                
                for (int j=0; j<self.dataArray.count; j++) {
                    UITableViewCell *cell = [self.leftTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
                    if (j==i) {
                        
                        cell.contentView.backgroundColor = [UIColor orangeColor];
                        [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
                        isset=YES;
                    }
                    else
                    {
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                }
                
                if (isset) {
                    if (lastContentOffset < scrollView.contentOffset.y) {
//                        NSLog(@"向上滚动");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"insideTableView_upTouch" object:nil];
                    }else{
//                        NSLog(@"向下滚动");
//                        NSLog(@"%f",scrollView.contentOffset.y);
                        if (scrollView.contentOffset.y>scrollView.contentSize.height) {
                            scrollView.contentOffset=CGPointMake(0, scrollView.contentSize.height);
                            return;
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"insideTableView_DownTouch" object:nil];
                    }
                    return;
                }
                
            }
        }
    }
    
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

#pragma mark - cell点击
/**
 * cell开始订购
 */
- (void)cellShowCountViewWithPath:(NSIndexPath *)indexPath
{
    TakeOutModel *model = self.dataArray[indexPath.section][@"content"][indexPath.row];
    model.showCount = YES;
    [self.orderArray addObject:model];
    self.badge.badgeValue = [NSString stringWithFormat:@"%ld",(unsigned long)self.orderArray.count];
    [self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
/**
 * cell取消订购
 */
- (void)cellNotShowCountViewWithPath:(NSIndexPath *)indexPath
{
    TakeOutModel *model = self.dataArray[indexPath.section][@"content"][indexPath.row];
    model.orderCount = 0;
    model.showCount = NO;
    if ([self.orderArray containsObject:model]) {
        [self.orderArray removeObject:model];
    }
    self.badge.badgeValue = [NSString stringWithFormat:@"%ld",(unsigned long)self.orderArray.count];
    [self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
/**
 * cell增加订购数量
 */
- (void)cellOrderAddPath:(NSIndexPath *)indexPath
{
    TakeOutModel *model = self.dataArray[indexPath.section][@"content"][indexPath.row];
    model.orderCount++;
    NSLog(@"%ld",(long)model.orderCount);
//    self.totalPrice = model.price + self.totalPrice;
    
    [ShoppingCartManager AddGood:[self TakeOutCellModelToShoppingCarModel:model]];
    [self priceChange];
}
/**
 * cell减少订购数量
 */
- (void)cellOrderSubPath:(NSIndexPath *)indexPath
{
    TakeOutModel *model = self.dataArray[indexPath.section][@"content"][indexPath.row];
    if (model.orderCount > 0) {
        model.orderCount--;
    }
    NSLog(@"%ld",(long)model.orderCount);
   
    
    if (model.guiGeArray!=nil) {
    }
    else
    {
        [ShoppingCartManager reduceGoodNumWithGoodId:[NSString stringWithFormat:@"%d",model.foodID] andGuigeId:nil];
    }
    
    
     [self priceChange];
    
}


-(ShoppingCartModel *)TakeOutCellModelToShoppingCarModel:(TakeOutModel *)takeoutmodel
{
    ShoppingCartModel * model=[[ShoppingCartModel alloc] init];
    
    model.ShoppingCartGoodName = takeoutmodel.title;
    model.ShoppingCartGoodId = [NSString stringWithFormat:@"%d",takeoutmodel.foodID];
    model.ShoppingCartGoodPrice = [NSString stringWithFormat:@"%.2f",takeoutmodel.price];
    if (takeoutmodel.guiGeArray.count>0) {
        model.ShoppingCartGuigeName = takeoutmodel.guiGeArray[0][@"Name"];
        model.ShoppingCartGuigeId = takeoutmodel.guiGeArray[0][@"Id"];
    }
//    model.ShoppingCartBuyNum = [NSString stringWithFormat:@"%d",takeoutmodel.orderCount];
    
    model.ShoppingCartBuyNum = @"1";
    return model;
}

/**
 * 总价格变化调用
 */
- (void)priceChange
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh_shoppingCar" object:nil];
//    self.totalPriceLabel.text = [NSString stringWithFormat:@"共￥%ld",(long)self.totalPrice];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.totalPriceLabel.text];
//    NSRange range = NSMakeRange(1, self.totalPriceLabel.text.length-1);
//    [str addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:range];
//    self.totalPriceLabel.attributedText = str;
}
@end
