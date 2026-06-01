//
//  ShopGoodsListCell.h
//  BaseProject
//
//  Created by 陆超 on 2017/6/17.
//  Copyright © 2017年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopGoodsListCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *data;

@end

@interface ShopGoodsTopCell : UITableViewCell

@property (nonatomic, strong) NSArray <NSString *>*imgURLs;
@property (nonatomic, strong) NSArray <NSString *>*imgTitles;

@end

