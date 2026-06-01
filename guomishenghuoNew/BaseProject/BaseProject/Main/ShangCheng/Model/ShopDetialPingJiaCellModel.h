//
//  ShopDetialPingJiaCellModel.h
//  ChengJiaXiaoChi
//
//  Created by 于金祥 on 16/4/27.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetialPingJiaCellModel : NSObject
@property(nonatomic,strong)NSString * img_Path;//评价人头像

@property(nonatomic,strong)NSString * pingJiaDate;//评价日期
/**
 *  评价星星数量
 */
@property(nonatomic)NSInteger starNum;
/**
 *  评价人昵称
 */
@property(nonatomic,strong)NSString * nickName;

/**
 *  送达时长
 */
@property (nonatomic,strong)NSString * timeLong;

/**
 *  评论内容
 */
@property(nonatomic,strong) NSString *pinglunContent;

/**
 *  追加评论
 */
@property (nonatomic,strong)NSString *addContent;

/**
 *  商家回复
 */
@property (nonatomic,strong) NSString *shopperWritBack;
@end
