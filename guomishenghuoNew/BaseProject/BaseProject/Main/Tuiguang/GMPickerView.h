//
//  GMPickerView.h
//  BaseProject
//
//  Created by 陆超 on 2017/6/5.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMPickerView : UIPickerView

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, copy) NSString *textProperty;

@property (nonatomic, copy) void (^selected)(id obj);

@property (nonatomic, strong) id currentSelectedObj;

@end
