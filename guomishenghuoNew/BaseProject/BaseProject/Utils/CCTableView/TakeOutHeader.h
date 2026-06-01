//
//  TakeOutHeader.h
//  智慧社区
//
//  Created by 陈程 on 15/5/26.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakeOutHeader : UITableViewHeaderFooterView
@property (nonatomic,copy) NSString *titleStr;
+ (instancetype)headerWithTableView:(UITableView *)tableview;
@end
