//
//  SearchResultViewController.h
//  LikeAttention
//
//  Created by 王建成 on 15/11/20.
//  Copyright © 2015年 zykj.LikeAttention. All rights reserved.
//

#import "BaseViewController.h"
#import "SellerCell.h"
#import "UIImageView+WebCache.h"
#import "CWStarRateView.h"

@protocol SearchResultDeleagate <NSObject>

-(void)backToSearch;

@end

@interface SearchResultViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)id<SearchResultDeleagate> deleagate;
@property(nonatomic)NSArray *resultArr;
@property (nonatomic,strong)NSString * keyWorld;
@property(nonatomic)int type;
@end
