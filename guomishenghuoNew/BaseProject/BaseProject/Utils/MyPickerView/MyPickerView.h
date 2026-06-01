//
//  MyPickerView.h
//  DacheProject
//
//  Created by Wangjc on 16/6/30.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>


//#define SUPPORT_DATEPICKER  // 支持时间选择  这里基于UUDatePicker

#ifdef SUPPORT_DATEPICKER
#import "UUDatePicker.h"
#endif

@class MyPickerView;
@protocol MyPickerViewDelegate <NSObject>

-(void)pickerView:(MyPickerView *)pickerView selectedStr:(NSString *)str;
-(void)pickerView:(MyPickerView *)pickerView selectComFirstIndex:(NSInteger)firstComIndex andselectComSecondIndex:(NSInteger)SecondComIndex;

@end

@interface MyPickerView : UIView

@property(nonatomic) id<MyPickerViewDelegate> delegate;


#ifdef SUPPORT_DATEPICKER
-(instancetype) initWithDATE;
#endif

@property(nonatomic) NSMutableArray *selectComponentIndexs;

+(instancetype)PickerViewWithDataArr:(NSArray *)arr;
+(instancetype)PickerViewWithMultiArr:(NSArray *)arr;

-(instancetype)initWithDataArr:(NSArray *)arr;
-(instancetype)initWithMultiArr:(NSArray *)multiArr;

-(void)show;
-(void)dismiss;

@end
