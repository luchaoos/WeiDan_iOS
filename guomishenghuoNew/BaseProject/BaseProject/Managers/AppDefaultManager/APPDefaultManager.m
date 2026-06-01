//
//  UserDefaultKeys.m
//  YiShengDaoJia
//
//  Created by Wangjc on 16/4/18.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "APPDefaultManager.h"

#define remove_sp(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define get_sp(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define get_Dsp(key) [[NSUserDefaults standardUserDefaults]dictionaryForKey:key]
#define set_sp(key,obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key]
#define sp [NSUserDefaults standardUserDefaults]


@implementation APPDefaultManager

+(id)getDefaultByKey:(NSString *)key
{
    return get_sp(key);
}

+(void)setDefaultByKey:(NSString *)key andObject:(id)obj
{
    set_sp(key, obj);
}

+(void)removeDefaultByKey:(NSString *)key
{
    remove_sp(key);
}

@end
