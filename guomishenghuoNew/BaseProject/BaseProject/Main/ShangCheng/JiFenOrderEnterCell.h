//
//  JiFenOrderEnterCell.h
//  BaseProject
//
//  Created by 陆超 on 2017/7/14.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiFenOrderEnterCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, copy) void(^peisongBlock)();
@property (nonatomic, copy) void(^msgEditBlock)(NSString *msg);
@end
