//
//  QMYBShouyiViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBShouyiViewController.h"

@interface QMYBShouyiViewController (){
    UIView *topView;
}

@property (nonatomic,strong)UIViewController *pushVC;

@end

@implementation QMYBShouyiViewController

- (instancetype)initWithPushViewController:(UIViewController *)pushVC{
    if (self=[super init]) {
        self.pushVC=pushVC;
    }
    return self;
};

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self initUI];
    NSLog(@"收益记录");
}

- (void)initUI{
    topView=[[UIView alloc]init];
    topView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:topView];
    topView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(GetHeight(44));
    NSArray *titleArray=@[@"姓名",@"账号",@"日收益",@"当月收益"];
    CGFloat buttonWidth=SCREEN_WIDTH/4.0;
    for (int i=0; i<titleArray.count; i++) {
        UIButton *button=[[UIButton alloc]init];
        button.frame=CGRectMake(buttonWidth*i, 0, buttonWidth, topView.height);
        [button setTitle:titleArray[i] forState:0];
        [button setTitleColor:[UIColor blackColor] forState:0];
        [button.titleLabel setFont:font15];
        if (i==3) {
            button.tag=1002;
            [button addTarget:self action:@selector(selectMonth:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:@"arr2"] forState:UIControlStateNormal];
            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GetWidth(3)];
        }
        [topView addSubview:button];
    }
}

//选择月份
- (void)selectMonth:(UIButton *)sender{
    NSArray * menuArray = @[[KxMenuItem menuItem:@"当月收益" image:nil target:self action:@selector(thisMonth)],[ KxMenuItem menuItem:@"上月收益" image:nil target:self action:@selector(preMonth)],[ KxMenuItem menuItem:@"上上月收益" image:nil target:self action:@selector(preSecondMonth)]];
    [KxMenu setTitleFont:font15];
    Color c={.R= 1, .G= 1, .B= 1};
    Color c2={.R=0, .G=0, .B= 0};
    OptionalConfiguration  options ={
        .arrowSize= GetWidth(9),  //指示箭头大小
        .marginXSpacing= GetWidth(7),  //MenuItem左右边距
        .marginYSpacing= GetWidth(7),  //MenuItem上下边距
        .intervalSpacing= GetWidth(25),  //MenuItemImage与MenuItemTitle的间距
        .menuCornerRadius=GetWidth(3),  //菜单圆角半径
        .maskToBackground= true,  //是否添加覆盖在原View上的半透明遮罩
        .shadowOfMenu= false,  //是否添加菜单阴影
        .hasSeperatorLine= true,  //是否设置分割线
        .seperatorLineHasInsets= false,  //是否在分割线两侧留下Insets
        .textColor=c,  //menuItem字体颜色
        .menuBackgroundColor=c2   //菜单的底色
    };
    CGRect frame = [self.view convertRect:sender.frame toView:KeyWindow];
    [KxMenu showMenuInView:KeyWindow fromRect:frame menuItems:menuArray withOptions:options];
}

//当月收益
- (void)thisMonth{
    UIButton *sender=[topView viewWithTag:1002];
    [sender setTitle:@"当月收益" forState:0];
    [sender layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GetWidth(3)];
}

//上月收益
- (void)preMonth{
    UIButton *sender=[topView viewWithTag:1002];
    [sender setTitle:@"上月收益" forState:0];
    [sender layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GetWidth(3)];
}

//上上月收益
- (void)preSecondMonth{
    UIButton *sender=[topView viewWithTag:1002];
    [sender setTitle:@"上月月收益" forState:0];
    [sender layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GetWidth(3)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
