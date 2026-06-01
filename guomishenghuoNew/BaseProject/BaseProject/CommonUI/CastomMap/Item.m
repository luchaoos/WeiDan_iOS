//
//  Item.m
//  CustomMKAnnotationView
//
//  Created by JianYe on 14-2-8.
//  Copyright (c) 2014年 Jian-Ye. All rights reserved.
//

#import "Item.h"

@implementation Item
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.latitude = [dictionary objectForKey:@"latitude"];
        self.longitude = [dictionary objectForKey:@"longitude"];
        self.title = [dictionary objectForKey:@"title"];
        self.subtitle = [dictionary objectForKey:@"subtitle"];
    }
    return self;
}
@end
