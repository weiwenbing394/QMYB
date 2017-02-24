//
//  QMYBShouyiViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBShouyiViewController.h"
#import "QMYBShouyiTableViewCell.h"

@interface QMYBShouyiViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *topView;
}

@property (nonatomic,strong)UIViewController *pushVC;

@property (nonatomic,strong)UITableView *myTableview;

@end

@implementation QMYBShouyiViewController

static NSString *const tableviewCellIndentifer=@"Cell";

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
    [self.myTableview reloadData];
}

- (void)initUI{
    topView=[[UIView alloc]init];
    topView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue-gradient"]];
    [self.view addSubview:topView];
    topView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(GetHeight(35));
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
            [button setImage:[UIImage imageNamed:@"arr-down"] forState:UIControlStateNormal];
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

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMYBShouyiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GetHeight(50);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark 懒加载
- (UITableView *)myTableview{
    if (!_myTableview) {
        _myTableview=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableview.backgroundColor=[UIColor clearColor];
        _myTableview.delegate=self;
        _myTableview.dataSource=self;
        _myTableview.tableFooterView=[self tableFootView];
        _myTableview.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableview.sectionHeaderHeight=0.0001;
        _myTableview.sectionFooterHeight=0.0001;
        _myTableview.separatorInset=UIEdgeInsetsMake(0, GetWidth(15), 0, 0);
        _myTableview.separatorColor=colorc2c3c4;
        [_myTableview registerClass:[QMYBShouyiTableViewCell class] forCellReuseIdentifier:tableviewCellIndentifer];
        [self.view addSubview:_myTableview];
        _myTableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,GetHeight(35)).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
        MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_myTableview.mj_header endRefreshing];
                [_myTableview.mj_footer endRefreshing];
                
            });
        }];
        _myTableview.mj_header=mjHeader;
        
        MJFooter *mjFooter=[MJFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_myTableview.mj_header endRefreshing];
                [_myTableview.mj_footer endRefreshing];
            });
        }];
        _myTableview.mj_footer=mjFooter;
        
       
        
    }
    return _myTableview;
}

- (UIView *)tableFootView{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(70))];
    footView.backgroundColor=[UIColor clearColor];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor=RGB(181, 175, 168);
    [footView addSubview:line];
    
    UILabel *huizong=[UILabel labelWithTitle:@"汇总：" color:[UIColor lightGrayColor] font:font12];
    [footView addSubview:huizong];
    [huizong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(footView).offset(GetWidth(15));
    }];
    
    UILabel *dangyue=[UILabel labelWithTitle:@"当月总收益：30000元" color:[UIColor lightGrayColor] font:font12];
    [footView addSubview:dangyue];
    [dangyue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(huizong.mas_right).offset(GetWidth(2));
        make.top.mas_equalTo(huizong);
    }];
    
    UILabel *jinri=[UILabel labelWithTitle:@"今日总收益：30000元" color:[UIColor lightGrayColor] font:font12];
    [footView addSubview:jinri];
    [jinri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(huizong.mas_right).offset(GetWidth(2));
        make.top.mas_equalTo(huizong.mas_bottom).offset(GetHeight(5));
    }];
    
    UILabel *tuidan=[UILabel labelWithTitle:@"今日退单金额：30000元" color:[UIColor lightGrayColor] font:font12];
    [footView addSubview:tuidan];
    [tuidan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(huizong.mas_right).offset(GetWidth(2));
        make.top.mas_equalTo(jinri.mas_bottom).offset(GetHeight(5));
    }];
    
    return footView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
