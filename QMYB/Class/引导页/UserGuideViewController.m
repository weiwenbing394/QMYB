//
//  LoginViewController.h
//  chenzi
//
//  Created by 大家保 on 16/5/2.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "UserGuideViewController.h"
#import "QMYBLoginViewController.h"

@implementation UserGuideViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //设置setupScrollView
    [self setupScrollView];
    //设置setupPageControl
    [self setupPageControl];
}
//内存警告处理
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    if (self.view.window==nil) {
        self.view=nil;
    }
}
// 设置uiScrollView
- (void)setupScrollView{
    NSArray *arr;
    if (SCREEN_HEIGHT==480) {
        arr=@[@"引导页1_small",@"引导页2_small",@"引导页3_small",@"引导页4_small"];
    }else{
        arr=@[@"引导页1",@"引导页2",@"引导页3",@"引导页4"];
    }

    scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.delegate =self;
    [self.view addSubview:scrollView];
    //关闭水平方向上的滚动条
    scrollView.showsHorizontalScrollIndicator =NO;
    scrollView.bounces=NO;
    //是否可以整屏滑动
    scrollView.pagingEnabled =YES;
    scrollView.tag =200;
    scrollView.contentSize =CGSizeMake([[UIScreen mainScreen] bounds].size.width *arr.count, [UIScreen mainScreen].bounds.size.height);
    for (int i = 0; i < arr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH* i,0,SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.contentMode= UIViewContentModeScaleAspectFit;
        [imageView setImage:[UIImage imageNamed:arr[i]]];
        [scrollView addSubview:imageView];
    }
}

//进入主页按钮
-(void)addButton
{
    UIButton *goButton;
    if (SCREEN_HEIGHT==480) {
        goButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 3+(SCREEN_WIDTH/2.0-(45*280/84.0)/2.0),SCREEN_HEIGHT-80 ,45*280/84.0, 45)];
    }else{
        goButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 3+(SCREEN_WIDTH/2.0-(45*280/84.0)/2.0),SCREEN_HEIGHT*0.85 ,45*280/84.0, 45)];
    }
    [goButton addTarget:self action:@selector(goMain) forControlEvents:UIControlEventTouchUpInside];
    [goButton setBackgroundImage:[UIImage imageNamed:@"btn_yindao"] forState:0];
    [goButton setBackgroundImage:[UIImage imageNamed:@"bt-normal_gouma"] forState:UIControlStateHighlighted];
    [UIView animateWithDuration:0.5 animations:^{
        goButton.alpha=1;
    }];
    [scrollView addSubview:goButton];
}

// 设置uiPageControl
- (void)setupPageControl
{
    // UIPageControl1.表示页数2.表示当前正处于第几页3.点击切换页数
    UIPageControl *pageControl;
    if (SCREEN_HEIGHT==480) {
         pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0, SCREEN_HEIGHT*0.75, 300, 20)];
    }else{
         pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0, SCREEN_HEIGHT*888/1134, 300, 20)];
    }
    pageControl.tag =100;
    //设置表示的页数
    pageControl.numberOfPages =4;
    //设置选中的页数
    pageControl.currentPage =0;
    //设置未选中点的颜色
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //设置选中点的颜色
    pageControl.currentPageIndicatorTintColor = colorf8ba12;
    //启用触摸响应
    [pageControl addTarget:self action:@selector(handlePageControl:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
}
//scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollview{
    UIPageControl *pagControl = (UIPageControl *)[self.view viewWithTag:100];
    pagControl.currentPage = scrollview.contentOffset.x / SCREEN_WIDTH ;
    if (scrollView.contentOffset.x>=SCREEN_WIDTH*2) {
        [self addButton];
    }
}
//uiPageControl代理
- (void)handlePageControl:(UIPageControl *)pageControl{
    //切换pageControl .对应切换scrollView不同的界面
    UIScrollView *scrollview = (UIScrollView *)[self.view viewWithTag:200];
    [scrollview setContentOffset:CGPointMake(SCREEN_WIDTH * pageControl.currentPage,0) animated:YES];
}

//切换到主页
- (void)goMain{
    [UserDefaults setBool:YES forKey:@"firstLanch"];
    [UserDefaults synchronize];
    QMYBLoginViewController *rootController = [[QMYBLoginViewController alloc]init];
    KeyWindow.rootViewController=rootController;
}

/**
 *  友盟统计页面打开开始时间
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"引导页"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"引导页"];
}

@end
