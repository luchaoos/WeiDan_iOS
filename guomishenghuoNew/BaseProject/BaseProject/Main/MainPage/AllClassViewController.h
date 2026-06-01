//
//  AllClassViewController.h
//  LikeAttention
//
//  Created by 王建成 on 15/11/19.
//  Copyright © 2015年 zykj.LikeAttention. All rights reserved.
//

#import "BaseViewController.h"
#import "DataProviderOther.h"
@interface AllClassViewController :BaseViewController <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) NSString * type_title;
@end
