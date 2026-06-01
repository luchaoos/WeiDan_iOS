//
//  ShopApraiseTableView.h
//  BaseProject
//
//  Created by 刘顺 on 16/11/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLevelView.h"
#import "JSTextView.h"


@protocol ShopApraiseTableViewDelegate <NSObject>

- (void)postPic:(JSTextView *)view;

@end

@interface ShopApraiseTableView : UITableView<UITableViewDelegate, UITableViewDataSource, JSTextViewDelegate>
@property (nonatomic, strong)LPLevelView *lView;
@property (nonatomic, strong)JSTextView *jsView;
@property (nonatomic) NSInteger cellNum;

@property (nonatomic, weak)id<ShopApraiseTableViewDelegate>appraiseDelegate;
@end
