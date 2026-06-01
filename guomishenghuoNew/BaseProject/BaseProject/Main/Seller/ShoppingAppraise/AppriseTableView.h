//
//  AppriseTableView.h
//  BaseProject
//
//  Created by 刘顺 on 16/11/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"
#import "JSTextView.h"

@protocol AppriseTableViewDelegate <NSObject>

- (void)postPic:(JSTextView *)view;

@end

@interface AppriseTableView : UITableView<UITableViewDelegate, UITableViewDataSource, JSTextViewDelegate>
@property (nonatomic, strong)CWStarRateView *lView;
@property (nonatomic, strong)JSTextView *jsView;

@property (nonatomic, assign) NSInteger btnTag;
@property (nonatomic) NSInteger cellNum;
@property (nonatomic, weak)id<AppriseTableViewDelegate>appDelegate;

@end
