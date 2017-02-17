//
//  QMYBViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBTabBarController.h"
#import "QMYBNavigationController.h"
#import "QMYBMainViewController.h"
#import "QMYBOrderWriteViewController.h"
#import "QMYBOrderListViewController.h"
#import "QMYBMeViewController.h"


@interface QMYBTabBarController ()

@end

@implementation QMYBTabBarController


+ (void)initialize {
    // 通过appearance统一设置所有的UIBarBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法，都可以用appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    UITabBar *bar=[UITabBar appearance];
    [bar setTintColor:[UIColor redColor]];
    [bar setBarTintColor:[UIColor whiteColor]];
    [bar setTranslucent:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控制器
    [self setupChildVc:[[QMYBMainViewController alloc] init] title:@"主页" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    [self setupChildVc:[[QMYBOrderWriteViewController alloc] init] title:@"录单" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self setupChildVc:[[QMYBOrderListViewController alloc] init] title:@"订单列表" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    [self setupChildVc:[[QMYBMeViewController alloc] init] title:@"个人中心" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    
    
}

/**
 *  初始化控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置文字图片
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    //vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    vc.tabBarItem.titlePositionAdjustment=UIOffsetMake(0, -2);
    // 包装一个导航控制器，添加导航控制器为tabBarController的子控制器
    QMYBNavigationController *nav = [[QMYBNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
