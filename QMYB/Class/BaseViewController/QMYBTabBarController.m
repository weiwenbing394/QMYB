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
    attrs[NSFontAttributeName] = SystemFont(10);
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#787878"];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#0096ff"];
    
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
    [self setupChildVc:[[QMYBMainViewController alloc] init] title:@"主页" image:@"首页-normal" selectedImage:@"首页-click"];
    
    [self setupChildVc:[[QMYBOrderWriteViewController alloc] init] title:@"录单" image:@"录单-normal" selectedImage:@"录单-click"];
    
    [self setupChildVc:[[QMYBOrderListViewController alloc] init] title:@"订单" image:@"订单-normal" selectedImage:@"订单-click"];
    
    [self setupChildVc:[[QMYBMeViewController alloc] init] title:@"个人中心" image:@"个人中心-normal" selectedImage:@"个人中心-click"];
    
    
    
}

/**
 *  初始化控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置文字图片
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.titlePositionAdjustment=UIOffsetMake(0, -2);
    // 包装一个导航控制器，添加导航控制器为tabBarController的子控制器
    QMYBNavigationController *nav = [[QMYBNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
