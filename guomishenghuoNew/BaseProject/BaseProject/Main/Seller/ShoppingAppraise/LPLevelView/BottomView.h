//
//  BottomView.h
//  Grade
//
//  Created by 刘顺 on 16/10/13.
//  Copyright © 2016年 LiuShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>

- (void)commit;

@end

@interface BottomView : UIView
@property (nonatomic, weak)id<BottomViewDelegate>delegate;
@end
