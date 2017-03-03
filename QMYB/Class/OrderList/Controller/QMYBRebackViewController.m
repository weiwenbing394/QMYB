//
//  QMYBRebackViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBRebackViewController.h"
#import "QMYBJiaoyiTableViewCell.h"
#import "Jiaoyi.h"

@interface QMYBRebackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIViewController *pushVC;

@property (nonatomic,strong)UITableView *myTableview;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) NSInteger maxSize;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong)UIView *noDataView;


@end

@implementation QMYBRebackViewController

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
    self.pageSize=10;
    [self.myTableview.mj_header beginRefreshing];

}


#pragma mark 下拉刷新
- (void)savelist:(id)response{
    NSLog(@"%@",response);
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD showError:errorMsg];
        }else{
            [self.dataSourceArray removeAllObjects];
            self.maxSize=[response[@"data"] integerForKey:@"totalAmount"];
            NSArray *jiaoyiArray=[Jiaoyi mj_objectArrayWithKeyValuesArray:response[@"data"][@"orderList"]];
            [self.dataSourceArray addObjectsFromArray:jiaoyiArray];
            if (self.dataSourceArray.count<self.maxSize) {
                [self addMJ_Footer];
            }
            if (self.dataSourceArray.count==0) {
                [self.myTableview addSubview:self.noDataView];
            }else{
                [self.noDataView removeFromSuperview];
            }
            [self.myTableview reloadData];
        }
    }
}


#pragma mark 获取更多产品数据
- (void)addlist:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD showError:errorMsg];
        }else{
            self.maxSize=[response[@"data"] integerForKey:@"totalAmount"];
            NSArray *jiaoyiArray=[Jiaoyi mj_objectArrayWithKeyValuesArray:response[@"data"][@"orderList"]];
            [self.dataSourceArray addObjectsFromArray:jiaoyiArray];
            if (self.dataSourceArray.count>=self.maxSize) {
                [self.myTableview.mj_footer endRefreshingWithNoMoreData];
            }
            [self.myTableview reloadData];
        }
    }
}



#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMYBJiaoyiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    Jiaoyi *model=self.dataSourceArray[indexPath.row];
    cell.model=model;
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GetWidth(15)*2+GetWidth(60);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
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
        
        [self addMJheader];
        
    }
    return _myTableview;
}

#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        self.page=1;
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getBusiness];
        NSDictionary *dic=@{@"page":@(self.page),@"pageSize":@(self.pageSize),@"type":@(3)};
        [XWNetworking postJsonWithUrl:url params:dic responseCache:^(id responseCache) {
            if ([self isNetworkRunning]==NO) {
                [self savelist:responseCache];
                [self endFreshAndLoadMore];
            }
        } success:^(id response) {
            [self savelist:response];
            [self endFreshAndLoadMore];
        } fail:^(NSError *error) {
            [MBProgressHUD showError:@"获取数据失败"];
            [self endFreshAndLoadMore];
        } showHud:NO];
    }];
    self.myTableview.mj_header=mjHeader;
}

#pragma mark 增加addMJ_Footer
- (void)addMJ_Footer{
    MJFooter *mjFooter=[MJFooter footerWithRefreshingBlock:^{
        self.page++;
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getBusiness];
        NSDictionary *dic=@{@"page":@(self.page),@"pageSize":@(self.pageSize),@"type":@(3)};
        [XWNetworking postJsonWithUrl:url params:dic responseCache:^(id responseCache) {
            if ([self isNetworkRunning]==NO) {
                [self addlist:responseCache];
                [self endFreshAndLoadMore];
            }
        } success:^(id response) {
            [self addlist:response];
            [self endFreshAndLoadMore];
        } fail:^(NSError *error) {
            [MBProgressHUD showError:@"获取数据失败"];
            [self endFreshAndLoadMore];
        } showHud:NO];
    }];
    self.myTableview.mj_footer=mjFooter;
}

#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [self.myTableview.mj_header endRefreshing];
    if (self.dataSourceArray.count>=self.maxSize) {
        [self.myTableview.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.myTableview.mj_footer endRefreshing];
    }
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[NSMutableArray array];
    }
    return _dataSourceArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (UIView *)noDataView{
    if (!_noDataView) {
        _noDataView=[self noMessageView:@"暂无记录哦"];
        CGRect oldRect=_noDataView.frame;
        CGRect newRect=CGRectMake(SCREEN_WIDTH/2.0-oldRect.size.width/2.0, GetHeight(60), oldRect.size.width, oldRect.size.height);
        _noDataView.frame=newRect;
    }
    return _noDataView;
}


@end
