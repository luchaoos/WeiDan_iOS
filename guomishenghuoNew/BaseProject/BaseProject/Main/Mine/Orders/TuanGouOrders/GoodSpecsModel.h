//
//  GoodSpecsModel.h
//  BaseProject
//
//  Created by Wangjc on 16/8/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodSpecsModel : NSObject
@property(nonatomic) NSString *specsName;
@property(nonatomic) NSString *specsId;
@property(nonatomic) NSString *specsSelected;
@property(nonatomic) NSMutableArray <NSString *> *specsSpecs;
@end
