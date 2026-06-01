//
//  Item.h
//  CustomMKAnnotationView
//
//  Created by JianYe on 14-2-8.
//  Copyright (c) 2014年 Jian-Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longitude;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subtitle;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end