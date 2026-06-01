//
//  CateModel.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/5/21.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CateModel : NSObject
@property(nonatomic) NSString *cateName;
@property(nonatomic) NSString *cateDescirpe;
@property(nonatomic) NSString *cateId;
@property(nonatomic) NSString *cateCode;//用于排序


+(instancetype)CateModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
