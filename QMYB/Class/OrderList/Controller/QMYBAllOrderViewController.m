//
//  QMYBAllOrderViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBAllOrderViewController.h"
#import "QMYBTestViewController.h"
#import "QMYBJiaoyiTableViewCell.h"

@interface QMYBAllOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIViewController *pushVC;

@property (nonatomic,strong)UITableView *myTableview;

@end

@implementation QMYBAllOrderViewController

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
    [self.myTableview reloadData];
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMYBJiaoyiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GetWidth(15)*2+GetWidth(60);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
        _myTableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableview.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableview.sectionHeaderHeight=0.0001;
        _myTableview.sectionFooterHeight=0.0001;
        _myTableview.separatorInset=UIEdgeInsetsMake(0, GetWidth(15), 0, 0);
        _myTableview.separatorColor=colorc2c3c4;
        [_myTableview registerClass:[QMYBJiaoyiTableViewCell class] forCellReuseIdentifier:tableviewCellIndentifer];
        [self.view addSubview:_myTableview];
        _myTableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
