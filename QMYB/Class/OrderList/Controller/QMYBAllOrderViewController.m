//
//  QMYBAllOrderViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBAllOrderViewController.h"
#import "QMYBTestViewController.h"

@interface QMYBAllOrderViewController ()

@property (nonatomic,strong)UIViewController *pushVC;

@end

@implementation QMYBAllOrderViewController

- (instancetype)initWithPushViewController:(UIViewController *)pushVC{
    if (self=[super init]) {
        self.pushVC=pushVC;
    }
    return self;
};

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    UIButton *b=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 50)];
    [b setTitle:@"测试" forState:0];
    [b setTitleColor:[UIColor darkGrayColor] forState:0];
    [b addTarget:self action:@selector(pushNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)pushNext{
    QMYBTestViewController *test=[[QMYBTestViewController alloc]init];
    test.hidesBottomBarWhenPushed=YES;
    [self.pushVC.navigationController pushViewController:test animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
