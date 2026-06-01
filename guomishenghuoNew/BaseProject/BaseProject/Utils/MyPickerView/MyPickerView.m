//
//  MyPickerView.m
//  DacheProject
//
//  Created by Wangjc on 16/6/30.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MyPickerView.h"

#define ViewHeight      200

@interface MyPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL dateMode;
}
@property(nonatomic) NSString *selectStr;
@property(nonatomic) UIPickerView *pickerView;
@property(nonatomic) UIView *showView;
@property(nonatomic) UIView *coverView;
@property(nonatomic) NSArray *dataArr;
@property(nonatomic) NSArray *multiArr;

#ifdef SUPPORT_DATEPICKER
@property(nonatomic) UUDatePicker *datepicker;
#endif

@end

@implementation MyPickerView
{
    NSInteger firstIndex;
    NSInteger secondIndex;
}

+(instancetype)PickerViewWithDataArr:(NSArray *)arr
{
    return [[self alloc] initWithDataArr:arr];
}

+(instancetype)PickerViewWithMultiArr:(NSArray *)arr
{
    return [[self alloc] initWithMultiArr:arr];
}


-(instancetype)initWithDataArr:(NSArray *)arr
{
    if (self = [super init]) {
        if (arr != nil) {
            self.dataArr = arr;
            self.selectStr = self.dataArr[0];
            self.multiArr = [NSArray arrayWithObjects:self.dataArr,nil];
            [self buildView];
        }
    }
    
    return self;
}


-(instancetype)initWithMultiArr:(NSArray *)multiArr
{
    if(self = [super init])
    {
        self.multiArr = multiArr;
        [self buildView];
        
    }
    
    return self;
}

-(void)buildView
{
    

    for (int i = 0; i<self.multiArr.count; i++) {
        [self.selectComponentIndexs addObject:[NSString stringWithFormat:@"%d",0]];
    }
    self.frame = [[UIScreen mainScreen] bounds];
    [self addSubview:self.showView];
    [self.showView addSubview:self.pickerView];
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 30)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:cancelBtn];
    
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 40, 10, 40, 30)];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.showView addSubview:sureBtn];
}



#pragma mark - datePicker
#ifdef SUPPORT_DATEPICKER
-(instancetype)initWithDATE
{
    if (self = [super init]) {
        [self buildViewWithDatePicker];
    }
    
    return self;
}


-(void)buildViewWithDatePicker
{
    
    
    self.frame = [[UIScreen mainScreen] bounds];
    [self addSubview:self.showView];
    
    
    [self.showView addSubview:self.datepicker];
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
    cancelBtn.titleLabel.font = BaseFont;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:cancelBtn];
    
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 50, 10, 50, 30)];
    sureBtn.titleLabel.font = BaseFont;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.showView addSubview:sureBtn];
    
    dateMode = YES;
}

#endif

- (void)show
{
    
    if (self.multiArr==nil && self.dataArr == nil && dateMode == NO) {
        return;
    }
    
    [[Toolkit topView] addSubview:self.coverView];
    [[Toolkit topView] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT - ViewHeight, SCREEN_WIDTH, ViewHeight);
    } completion:^(BOOL finished) {
        
    }];
    
}


-(void)dismiss
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ViewHeight);
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    }];
   
}

#pragma mark - actions

-(void)sureBtnClick:(UIButton *)sender
{
//    if ([self.delegate respondsToSelector:@selector(pickerView:selectedStr:)]) {
//        [self.delegate pickerView:self selectedStr:self.selectStr];
//    }
    if ([self.delegate respondsToSelector:@selector(pickerView:selectComFirstIndex:andselectComSecondIndex:)]) {
        
        [self.delegate pickerView:self selectComFirstIndex:firstIndex andselectComSecondIndex:secondIndex];
    }
    [self dismiss];
}

-(void)cancelBtnClick:(UIButton *)sender
{
    [self dismiss];
}

#pragma mark - picker delegate & datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    @try {
        if (component==0) {
            self.dataArr = self.multiArr[component];
            
            return self.dataArr.count;
        }
        else
        {
            self.dataArr = self.multiArr[firstIndex][@"Children"];
            if (self.dataArr.count>0) {
                return self.dataArr.count;
            }
            return 0;
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    @try {
        if (component==0) {
            
            return self.multiArr[row][@"Name"];
            
        }
        else
        {
            self.dataArr = self.multiArr[firstIndex][@"Children"];
            if (self.dataArr.count>0) {
                return self.dataArr[row][@"Name"];
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return @"";
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH/2;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    self.dataArr = self.multiArr[component];
//    self.selectStr = self.dataArr[row];
    
    [self.selectComponentIndexs replaceObjectAtIndex:component withObject:ZY_NSStringFromFormat(@"%ld",row)];
    if (component==0) {
        firstIndex=row;
        [pickerView reloadComponent:1];
    }
    else
    {
        secondIndex=row;
    }
    
    
}

#pragma mark - property


#ifdef  SUPPORT_DATEPICKER

-(UUDatePicker *)datepicker
{
    if (_datepicker == nil) {
        
        __unsafe_unretained __typeof(self) weakSelf = self;
        
        _datepicker
        = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 40, SCREEN_WIDTH, ViewHeight - 40)
                                 PickerStyle:UUDateStyle_YearMonthDay
                                 didSelected:^(NSString *year,
                                               NSString *month,
                                               NSString *day,
                                               NSString *hour,
                                               NSString *minute,
                                               NSString *weekDay) {
                                     
                                     NSString *timeStr = ZY_NSStringFromFormat(@"%@-%@-%@",year,month,day);
                                     weakSelf.selectStr = timeStr;
                                     
//                                     if ([weakSelf.delegate respondsToSelector:@selector(pickerView:selectedStr:)])
//                                     {
//                                         [weakSelf.delegate pickerView:self selectedStr:timeStr];
//                                     }
                                     
                                 }];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _datepicker.minLimitDate = [formatter dateFromString:@"1900-01-01"];
        _datepicker.maxLimitDate = [NSDate date];
        
        _datepicker.ScrollToDate = [NSDate date];
        self.selectStr = [ZY_NSStringFromFormat(@"%@",[NSDate date]) substringToIndex:10];

    }
    
    
    return _datepicker;
    
}

#endif

-(NSMutableArray *)selectComponentIndexs
{
    if (_selectComponentIndexs == nil) {
        _selectComponentIndexs = [NSMutableArray array];
    }
    
    return _selectComponentIndexs;
}


-(UIView *)coverView
{
    
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.5;
    }
    
    return _coverView;
}

-(UIView *)showView
{
    if (_showView == nil) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, ViewHeight)];
        _showView.backgroundColor = [UIColor whiteColor];
    }
    
    return _showView;
}

-(UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, ViewHeight - 40)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    
    return _pickerView;
}

@end
