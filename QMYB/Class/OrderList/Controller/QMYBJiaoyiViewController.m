//
//  QMYBJiaoyiViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBJiaoyiViewController.h"
#import "QMYBAllOrderViewController.h"
#import "QMYBCompletedViewController.h"
#import "QMYBRebackViewController.h"

@interface QMYBJiaoyiViewController ()

@end

@implementation QMYBJiaoyiViewController

- (instancetype)initWithPushViewController:(UIViewController *)pushVC{
    if (self=[super init]) {
        self=[[QMYBJiaoyiViewController alloc]initWithViewControllerClasses:@[[[QMYBAllOrderViewController alloc]initWithPushViewController:pushVC],[[QMYBCompletedViewController alloc]initWithPushViewController:pushVC],[[QMYBRebackViewController alloc]initWithPushViewController:pushVC]] andTheirTitles:@[@"全部",@"已完成",@"已退单"]];
        self.menuViewStyle=WMMenuViewStyleLine;
        self.menuBGColor=[UIColor lightGrayColor];
        self.menuHeight=GetHeight(44);
        self.progressHeight=GetHeight(2);
        self.titleSizeNormal=GetWidth(15);
        self.titleSizeSelected=GetWidth(17);
        self.progressViewCornerRadius=GetHeight(2);
        self.progressViewIsNaughty=YES;
        self.automaticallyCalculatesItemWidths=YES;
        self.titleColorSelected=[UIColor redColor];
        self.itemsWidths=@[@(SCREEN_WIDTH/3.0),@(SCREEN_WIDTH/3.0),@(SCREEN_WIDTH/3.0)];
        self.viewFrame=CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    }
    return self;
};


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    NSLog(@"交易记录");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
