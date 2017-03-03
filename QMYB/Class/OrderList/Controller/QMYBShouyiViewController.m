//
//  QMYBShouyiViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBShouyiViewController.h"
#import "QMYBShouyiTableViewCell.h"
#import "QMYBMonthSelectView.h"
#import "Shouyi.h"
#import "UserShouyi.h"

@interface QMYBShouyiViewController ()<UITableViewDelegate,UITableViewDataSource,SelectView_delegate>{
    UIView *topView;
    QMYBMonthSelectView *selectView;
}

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) NSInteger maxSize;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong)UIViewController *pushVC;

@property (nonatomic,strong)UITableView *myTableview;

@property (nonatomic,strong)UserShouyi *userShouyi;

@property (nonatomic,strong)UIView *noDataView;

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
    self.pageSize=10;
    self.type=0;
    [self.myTableview.mj_header beginRefreshing];
}

- (void)initUI{
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"blue-gradient"] stretchableImageWithLeftCapWidth:181 topCapHeight:17]];
    bgImageView.userInteractionEnabled=YES;
    [self.view addSubview:bgImageView];
    bgImageView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(GetHeight(35));
    
    topView=[[UIView alloc]init];
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
            [button setTitleColor:color0086ff forState:0];
            [button setImage:[UIImage imageNamed:@"arr-down"] forState:UIControlStateNormal];
            button.layer.cornerRadius=3;
            button.layer.borderColor=color0086ff.CGColor;
            button.layer.borderWidth=1;
            button.clipsToBounds=YES;
            button.backgroundColor=[UIColor whiteColor];
            CGRect old=button.frame;
            CGRect new=CGRectMake(old.origin.x, old.size.height/2.0-GetHeight(25)/2.0, old.size.width-GetWidth(10), GetHeight(25));
            button.frame=new;
            [button.titleLabel setFont:font13];
            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GetWidth(2)];
        }
        [topView addSubview:button];
    }
}

//选择月份
- (void)selectMonth:(UIButton *)sender{
    NSArray *titleArray=@[@"当月收益",@"上月收益",@"上上月收益"];
    CGRect frame = [self.view convertRect:sender.frame toView:KeyWindow];
    selectView=[[QMYBMonthSelectView alloc]initWithArray:titleArray selectendIndex:[titleArray indexOfObject:sender.currentTitle] onRect:frame];
    selectView.delegate=self;
    [selectView showInView:nil];
}

#pragma mark 选择月份代理方法
- (void)tappedCancel{
    [selectView removeFromSuperview];
    selectView=nil;
};


- (void)selectButtomAtIndex:(NSInteger )index{
    UIButton *sender=[topView viewWithTag:1002];
    NSArray *titleArray=@[@"当月收益",@"上月收益",@"上上月收益"];
    [sender setTitle:titleArray[index] forState:0];
    [sender layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GetWidth(2)];
    [selectView removeFromSuperview];
    selectView=nil;
    
    self.type=index;
    [self.myTableview.mj_header beginRefreshing];
};

#pragma mark 下拉刷新
- (void)savelist:(id)response{
    NSLog(@"%@",response);
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD showError:errorMsg];
        }else{
            [self.userShouyi.emps removeAllObjects];
            self.maxSize=[response[@"data"] integerForKey:@"totalAmount"];
            self.userShouyi=[UserShouyi mj_objectWithKeyValues:response[@"data"]];
            if (self.userShouyi.emps.count<self.maxSize) {
                [self addMJ_Footer];
            }
            if (self.userShouyi.emps.count==0) {
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
            UserShouyi *moreUserShouyi=[UserShouyi mj_objectWithKeyValues:response[@"data"]];
            [self.userShouyi.emps addObjectsFromArray:moreUserShouyi.emps];
            if (self.userShouyi.emps.count>=self.maxSize) {
                [self.myTableview.mj_footer endRefreshingWithNoMoreData];
            }
            [self.myTableview reloadData];
        }
    }
}



#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMYBShouyiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    Shouyi *model=self.userShouyi.emps[indexPath.row];
    cell.model=model;
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GetHeight(50);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userShouyi.emps.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.userShouyi.emps.count>0) {
        UIView *footView=[self tableFootView];
        return footView;
    }else{
        UIView *view=[UIView new];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.userShouyi.emps.count>0) {
        return GetHeight(85);
    }else{
        return 0.0001;
    }
}


#pragma mark 懒加载
- (UITableView *)myTableview{
    if (!_myTableview) {
        _myTableview=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableview.backgroundColor=[UIColor clearColor];
        _myTableview.delegate=self;
        _myTableview.dataSource=self;
        _myTableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableview.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableview.sectionHeaderHeight=0.0001;
        _myTableview.sectionFooterHeight=0.0001;
        _myTableview.separatorInset=UIEdgeInsetsMake(0, GetWidth(15), 0, 0);
        _myTableview.separatorColor=colorc2c3c4;
        [_myTableview registerClass:[QMYBShouyiTableViewCell class] forCellReuseIdentifier:tableviewCellIndentifer];
        [self.view addSubview:_myTableview];
        _myTableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,GetHeight(35)).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
        [self addMJheader];
    }
    return _myTableview;
}

#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        self.page=1;
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getProfit];
        NSDictionary *dic=@{@"page":@(self.page),@"pageSize":@(self.pageSize),@"type":@(self.type)};
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
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getProfit];
        NSDictionary *dic=@{@"page":@(self.page),@"pageSize":@(self.pageSize),@"type":@(self.type)};
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
    if (self.userShouyi.emps.count>=self.maxSize) {
        [self.myTableview.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.myTableview.mj_footer endRefreshing];
    }
}


- (UIView *)tableFootView{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetHeight(70))];
    footView.backgroundColor=[UIColor clearColor];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0)];
    line.backgroundColor=RGB(181, 175, 168);
    [footView addSubview:line];
    
    UILabel *huizong=[UILabel labelWithTitle:@"汇总：" color:[UIColor lightGrayColor] font:font12];
    [footView addSubview:huizong];
    [huizong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(footView).offset(GetWidth(15));
    }];
    
    NSString *currentMonth=[NSString stringWithFormat:@"当月总收益：%.2f",self.userShouyi.sameMonthTotalCommission];
    UILabel *dangyue=[UILabel labelWithTitle:currentMonth color:[UIColor lightGrayColor] font:font12];
    [footView addSubview:dangyue];
    [dangyue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(huizong.mas_right).offset(GetWidth(2));
        make.top.mas_equalTo(huizong);
    }];
    
    NSString *today=[NSString stringWithFormat:@"今日总收益：%.2f",self.userShouyi.todayTotalCommission];
    UILabel *jinri=[UILabel labelWithTitle:today color:[UIColor lightGrayColor] font:font12];
    [footView addSubview:jinri];
    [jinri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(huizong.mas_right).offset(GetWidth(2));
        make.top.mas_equalTo(huizong.mas_bottom).offset(GetHeight(5));
    }];
    
    NSString *reback=[NSString stringWithFormat:@"今日退单金额：%.2f",self.userShouyi.surrenderTotalAmt];
    UILabel *tuidan=[UILabel labelWithTitle:reback color:[UIColor lightGrayColor] font:font12];
    [footView addSubview:tuidan];
    [tuidan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(huizong.mas_right).offset(GetWidth(2));
        make.top.mas_equalTo(jinri.mas_bottom).offset(GetHeight(5));
    }];
    
    return footView;
}

- (UserShouyi *)userShouyi{
    if (!_userShouyi) {
        _userShouyi=[[UserShouyi alloc]init];
    }
    return _userShouyi;
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
