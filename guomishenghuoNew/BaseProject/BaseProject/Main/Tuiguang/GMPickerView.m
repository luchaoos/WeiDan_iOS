//
//  GMPickerView.m
//  BaseProject
//
//  Created by 陆超 on 2017/6/5.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import "GMPickerView.h"
@interface GMPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation GMPickerView



//- (NSArray *)list {
//    if (_list == nil) {
//        _list = @[].copy;
//    }
//    return _list;
//}



- (void)setList:(NSArray *)list {
    if (!list) return;
    
    _list = list;
    
    [self reloadAllComponents];
    [self selectRow:0 inComponent:0 animated:NO];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_list) _list = @[];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.list.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.list[row][self.textProperty];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentSelectedObj = self.list[row];
    if (self.selected) {
        self.selected(self.list[row]);
    }
}



@end
