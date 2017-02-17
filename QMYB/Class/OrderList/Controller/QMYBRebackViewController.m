//
//  QMYBRebackViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBRebackViewController.h"

@interface QMYBRebackViewController ()

@property (nonatomic,strong)UIViewController *pushVC;

@end

@implementation QMYBRebackViewController

- (instancetype)initWithPushViewController:(UIViewController *)pushVC{
    if (self=[super init]) {
        self.pushVC=pushVC;
    }
    return self;
};


- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
