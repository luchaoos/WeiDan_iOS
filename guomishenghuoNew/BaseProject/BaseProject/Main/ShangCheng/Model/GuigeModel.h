//
//  GuigeModel.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/5/24.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuigeModel : NSObject
@property(nonatomic) NSString *guigeId;
@property(nonatomic) NSString *guigeName;
@property(nonatomic) NSString *guigePrice;
@property(nonatomic) NSString *guigeStorNum;//库存
@property(nonatomic) NSString *guigePicketNum;//打包带数量
@property(nonatomic) NSString *guigePicketPrice;//打包袋价格


+(instancetype)GuigeModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
