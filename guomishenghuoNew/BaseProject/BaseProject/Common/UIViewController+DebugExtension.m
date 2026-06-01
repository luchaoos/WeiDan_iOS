//
//  UIViewController+DebugExtension.m
//  BaseDev
//
//  Created by jereh on 16/4/11.
//  Copyright © 2016年 jerehsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation UIViewController (DebugExtension)

#ifdef DEBUG
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method ex_viewDidLoad = class_getInstanceMethod(self, @selector(ex_viewDidLoad));
        method_exchangeImplementations(viewDidLoad, ex_viewDidLoad);
    });
}

- (void)ex_viewDidLoad {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@ viewDidLoad", self);
    });
    [self ex_viewDidLoad];
}
#endif
@end
