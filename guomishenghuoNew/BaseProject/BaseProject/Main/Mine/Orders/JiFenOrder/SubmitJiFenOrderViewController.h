//
//  SubmitOrderViewController.h
//  BaseProject
//
//  Created by Wangjc on 16/10/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodDetailModel.h"
#import "RoundButton.h"

@interface SubmitJiFenOrderViewController : BaseViewController
@property (nonatomic,strong) NSDictionary * orderDetial;
@property(nonatomic) NSArray <GoodDetailModel*>*goodArr;
@end
