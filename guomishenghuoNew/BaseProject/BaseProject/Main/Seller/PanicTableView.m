//
//  PanicTableView.m
//  BaseProject
//
//  Created by 刘顺 on 16/10/15.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PanicTableView.h"
#import "PanBuyTableViewCell.h"


#import "BranchViewController.h"

@implementation PanicTableView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorColor = RGB(221, 221, 221);
        self.tableFooterView = [[UIView alloc]init];
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}
#pragma mark tabelViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"ident";
    PanBuyTableViewCell *pCell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!pCell) {
        pCell = [[PanBuyTableViewCell alloc]init];
        
    }
    return pCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}


@end
