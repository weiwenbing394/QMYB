//
//  QMYBOrderListViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBOrderListViewController.h"
#import "OrderCollectionViewCell.h"
#import "QMYBShouyiViewController.h"
#import "QMYBJiaoyiViewController.h"

@interface QMYBOrderListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    UISegmentedControl *segment;
}

/** *  控制器对应的字典*/
@property (nonatomic,strong)NSMutableDictionary *controllersDict;
/** collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titlesArray;
/** 控制器缓存池 */
@property (nonatomic, strong) NSMutableDictionary *controllerCache;

@end

@implementation QMYBOrderListViewController

/** 重用cell ID */
static NSString *const CollectionCell = @"CollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
};


- (void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 64)];
    topView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:topView];
    segment=[[UISegmentedControl alloc]initWithItems:self.titlesArray];
    segment.selectedSegmentIndex=0;
    segment.tintColor=[UIColor whiteColor];
    segment.frame=CGRectMake(SCREEN_WIDTH/2.0-100, 27, 200, 30);
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [topView addSubview:segment];
    
    // 创建一个流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //cell间距
    flowLayout.minimumInteritemSpacing = 0;
    //cell行距
    flowLayout.minimumLineSpacing = 0;
    // 修改属性
    flowLayout.itemSize =CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    // 创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,  SCREEN_HEIGHT-64-49) collectionViewLayout:flowLayout];
    // 注册一个cell
    [collectionView registerClass:[OrderCollectionViewCell class] forCellWithReuseIdentifier:CollectionCell];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator=NO;
    // 设置数据源对象
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces=NO;
    [self.view insertSubview:collectionView atIndex:0];
    self.collectionView = collectionView;

}

#pragma mark segementControl的方法
- (void)change:(UISegmentedControl *)segument {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:segument.selectedSegmentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 1. 创建一个Cell
    OrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (cell.showsVc==nil) {
        // 根据标题去缓存池获得对应的需要显示控制器
        UIViewController *showsVc = [self showsVc:self.titlesArray[indexPath.item]];
        cell.showsVc = showsVc;
    }
    // 2. 返回一个Cell
    return cell;
}

/**
 *  根据文字获得对应的需要显示控制器
 */
- (UIViewController *)showsVc:(NSString *)titile {
    UIViewController *showsVc = self.controllerCache[titile];
    if (showsVc == nil) {
        // 创建控制器
        UIViewController *typeVc = [self.controllersDict objectForKey:titile] ;
        // 将产品列表控制器添加到缓冲池中
        [self.controllerCache setObject:typeVc forKey:titile];
        return typeVc;
    }
    return showsVc;
}


#pragma mark - UIScrollViewDelegate
/**
 * scrollView结束了滚动动画以后就会调用这个方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 一些临时变量
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat offsetX = self.collectionView.contentOffset.x;
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    segment.selectedSegmentIndex=index;
}

#pragma mark 懒加载
- (NSMutableDictionary *)controllerCache {
    if (_controllerCache == nil) {
        _controllerCache = [[NSMutableDictionary alloc] init];
    }
    return _controllerCache;
}

- (NSArray *)titlesArray {
    if (!_titlesArray) {
        self.titlesArray = @[@"收益记录",@"交易记录"];
    }
    return _titlesArray;
}

- (NSMutableDictionary *)controllersDict {
    if (_controllersDict == nil) {
        NSMutableArray *objectsArray = [[NSMutableArray alloc] initWithObjects:[[QMYBShouyiViewController alloc]initWithPushViewController:self ], [[QMYBJiaoyiViewController alloc]initWithPushViewController:self], nil];
        _controllersDict = [[NSMutableDictionary alloc] initWithObjects:objectsArray forKeys:self.titlesArray];
    }
    return _controllersDict;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
