//
//  EditAddressViewController.h
//  ChengJiaXiaoChi
//
//  Created by Wangjc on 16/6/7.
//  Copyright © 2016年 于金祥. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"

@interface EditAddressViewController : BaseViewController
@property(nonatomic) AddressModel *addressModel;
@property(nonatomic)BOOL isEdit;
@end
