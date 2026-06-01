//
//  PhotoLibraryViewController.m
//  BaseProject
//
//  Created by 于金祥 on 2016/12/3.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PhotoLibraryViewController.h"
#import "DataProviderOther.h"
#import "VOSegmentedControl.h"
#import "PhotoItemCollectionViewCell.h"
#import "BigImageShowViewController.h"

#define CELL_ID @"Photo_cell"

@interface PhotoLibraryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * mainCollectionView;
@end

@implementation PhotoLibraryViewController
{
    NSArray * allData;
    NSArray * photoListArray;
    
    UIImageView * btn_all;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"相册";
    DataProviderOther * dataproviderOther=[[DataProviderOther alloc] init];
    [dataproviderOther setDelegateObject:self setSucceedBackFunctionName:@"GetPhotoCallBack:" setFailBackFunctionName:nil];
    [dataproviderOther GetShopPhotoLibraryWithShopID:self.shopID];
}
-(void)GetPhotoCallBack:(id)dict
{
    if (RequestSuccess(dict)) {
        allData=[[NSArray alloc] initWithArray:dict[@"data"]];
        if (allData.count<=0) {
            [YJXStatusHUD showError:@"未获取到数据"];
            return;
        }
        photoListArray=[[NSArray alloc] initWithArray:[allData firstObject][@"Children"]];
        NSMutableArray * controlArray=[[NSMutableArray alloc] init];
        for (NSDictionary * itemdict in allData) {
            [controlArray addObject:@{VOSegmentText: ZY_NSStringFromFormat(@"%@",itemdict[@"Name"])}];
        }
        VOSegmentedControl *segctrl1 = [[VOSegmentedControl alloc] initWithSegments:controlArray];
        segctrl1.contentStyle = VOContentStyleTextAlone;
        segctrl1.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        segctrl1.backgroundColor = [UIColor whiteColor];
        segctrl1.selectedBackgroundColor = segctrl1.backgroundColor;
        segctrl1.selectedIndicatorColor=AppMainColor;
        segctrl1.allowNoSelection = NO;
        segctrl1.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
        segctrl1.indicatorThickness = 4;
        segctrl1.scrollBounce=NO;
        segctrl1.textColor=[UIColor blackColor];
        segctrl1.tag = 1;
        [segctrl1 addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segctrl1];
        
        [self.view addSubview:self.mainCollectionView];
    }
    else
    {
        [YJXStatusHUD showError:@"未获取到数据"];
    }
}

-(void)segmentCtrlValuechange:(VOSegmentedControl *)sender
{
    photoListArray=[[NSArray alloc] initWithArray:allData[sender.selectedSegmentIndex][@"Children"]];
    [self.mainCollectionView reloadData];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (photoListArray) {
        return photoListArray.count;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoItemCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    if (photoListArray.count>0) {
        [cell.image sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,photoListArray[indexPath.item][@"Path"])] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
        cell.detail.text=Zy_JudgeIsNull(photoListArray[indexPath.item][@"Name"]);
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BigImageShowViewController * bigimgVC=[[BigImageShowViewController alloc] init];
    NSMutableArray * itemarray=[[NSMutableArray alloc] init];
    for (NSDictionary * itemdict in photoListArray) {
        [itemarray addObject:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,itemdict[@"Path"])];
    }
    bigimgVC.imgUrl=itemarray;
    [self.navigationController pushViewController:bigimgVC animated:YES];
//    btn_all=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    btn_all.userInteractionEnabled=YES;
//    btn_all.contentMode=UIViewContentModeScaleAspectFit;
////    btn_all.image=[UIImage imageWithData:[NSData dataWithContentsOfURL: ]];
//    [btn_all sd_setImageWithURL:[NSURL URLWithString:ZY_NSStringFromFormat(@"%@%@",BaseImgUrl,photoListArray[indexPath.item][@"Path"])] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
//    [btn_all  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageButton)]];
////    [btn_all addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
//    btn_all.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:btn_all];
}
-(void)clickImageButton
{
    [btn_all removeFromSuperview];
}

-(UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        //每个item的大小
        int  item_length = (SCREEN_WIDTH -40) / 2;
        layout.itemSize = CGSizeMake(item_length, item_length);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104) collectionViewLayout:layout];
        self.mainCollectionView.backgroundColor=[UIColor whiteColor];
        [self.mainCollectionView registerClass:[PhotoItemCollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
        //4.设置代理
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
    }
    return _mainCollectionView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
