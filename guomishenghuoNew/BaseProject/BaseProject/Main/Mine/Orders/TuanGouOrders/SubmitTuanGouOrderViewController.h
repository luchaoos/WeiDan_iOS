//
//  SubmitTuanGouOrderViewController.h
//  BaseProject
//
//  Created by Wangjc on 16/10/8.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodDetailModel.h"
#import "RoundButton.h"


@interface SubmitTuanGouOrderViewController : BaseViewController
@property (nonatomic,strong) NSDictionary * orderDetial;
@property(nonatomic) NSArray <GoodDetailModel*>*goodArr;
@property (nonatomic ,assign)float fandian;
@end
