//
//  SelectCityViewController.h
//  BaseProject
//
//  Created by zhylycn@163.com on 16/10/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectCityDelegate  <NSObject>

-(void)outCitySetting:(NSString *)City;

@end

@interface SelectCityViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) id<SelectCityDelegate> delegate;

@end
