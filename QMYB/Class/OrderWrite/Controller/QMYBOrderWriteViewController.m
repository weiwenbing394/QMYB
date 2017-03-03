//
//  QMYBOrderWriteViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBOrderWriteViewController.h"
#import "WXApi.h"
#import "QMYBShouYeTableViewCell.h"
#import "QMYBShouYeModel.h"
#import "QMYBWebViewController.h"
#import "QMYBErweimaView.h"
#import "User.h"

@interface QMYBOrderWriteViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *shouyeTableview;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong)JCAlertView *erweimaAlert;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) NSInteger maxSize;

@property (nonatomic,strong)UIView *noDataView;

@end

static NSString *const tableviewCellIndentifer=@"Cell";

@implementation QMYBOrderWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"录单产品"];
    self.pageSize=10;
    [self.shouyeTableview.mj_header beginRefreshing];
}

#pragma mark 下拉刷新
- (void)savelist:(id)response{
    //NSLog(@"%@",response);
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD showError:errorMsg];
        }else{
            [self.dataSourceArray removeAllObjects];
            self.maxSize=[response[@"data"] integerForKey:@"totalAmount"];
            NSArray *dataArray=[QMYBShouYeModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"productList"]];
            [self.dataSourceArray addObjectsFromArray:dataArray];
            if (self.dataSourceArray.count<self.maxSize) {
                [self addMJ_Footer];
            }
            if (self.dataSourceArray.count==0) {
                [self.shouyeTableview addSubview:self.noDataView];
            }else{
                [self.noDataView removeFromSuperview];
            }
            [self.shouyeTableview reloadData];
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
            NSArray *dataArray=[QMYBShouYeModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"productList"]];
            [self.dataSourceArray addObjectsFromArray:dataArray];
            if (self.dataSourceArray.count>=self.maxSize) {
                [_shouyeTableview.mj_footer endRefreshingWithNoMoreData];
            }
            [self.shouyeTableview reloadData];
        }
    }
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    QMYBShouYeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    QMYBShouYeModel *model=weakSelf.dataSourceArray[indexPath.section];
    cell.model=model;
    cell.erweimablock=^(){
        QMYBErweimaView *erweimaView=[[QMYBErweimaView alloc]initWithFrame:CGRectMake(0, 0, GetWidth(250), GetWidth(250)+65) withImageUrlStr:model.qrUrl];
        erweimaView.cancelBlock=^(){
            [weakSelf.erweimaAlert dismissWithCompletion:nil];
        };
        weakSelf.erweimaAlert=[[JCAlertView alloc]initWithCustomView:erweimaView dismissWhenTouchedBackground:NO];
        [weakSelf.erweimaAlert show];
    };
    cell.shareblock=^(){
        [weakSelf touch:model];
    };
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH*200/375.0+GetHeight(40);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QMYBShouYeModel *model=self.dataSourceArray[indexPath.section];
    QMYBWebViewController *webViewController=[[QMYBWebViewController alloc]init];
    webViewController.urlStr=model.saleUrl;
    [self.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark 分享到朋友圈
- (void)touch:(QMYBShouYeModel *)model{
    if ([WXApi isWXAppInstalled]) {
        WeakSelf;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [weakSelf shareWebPageToPlatformType:platformType withModel:model] ;
        }];
    }else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提醒" message:@"您尚未安装微信客户端，暂无法使用微信分享功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(QMYBShouYeModel *)shareModel{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  shareModel.shareImagePath;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareModel.title descr:shareModel.subhead thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = shareModel.shareUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBProgressHUD ToastInformation:@"分享失败"];
        }else{
            [MBProgressHUD ToastInformation:@"分享成功"];
        }
    }];
}


#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        self.page=1;
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,ProductList];
        NSDictionary *dic=@{@"page":@(self.page),@"pageSize":@(self.pageSize)};
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
    _shouyeTableview.mj_header=mjHeader;
}

#pragma mark 增加addMJ_Footer
- (void)addMJ_Footer{
    MJFooter *mjFooter=[MJFooter footerWithRefreshingBlock:^{
        self.page++;
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,ProductList];
        NSDictionary *dic=@{@"page":@(self.page),@"pageSize":@(self.pageSize)};
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
    _shouyeTableview.mj_footer=mjFooter;
}

#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [_shouyeTableview.mj_header endRefreshing];
    if (self.dataSourceArray.count>=self.maxSize) {
        [_shouyeTableview.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_shouyeTableview.mj_footer endRefreshing];
    }
}

#pragma mark 懒加载
- (UITableView *)shouyeTableview{
    if (!_shouyeTableview) {
        _shouyeTableview=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _shouyeTableview.backgroundColor=[UIColor clearColor];
        _shouyeTableview.delegate=self;
        _shouyeTableview.dataSource=self;
        _shouyeTableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _shouyeTableview.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _shouyeTableview.sectionHeaderHeight=0.0001;
        _shouyeTableview.sectionFooterHeight=GetHeight(10);
        _shouyeTableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _shouyeTableview.separatorColor=colorc3c3c3;
        [_shouyeTableview registerClass:[QMYBShouYeTableViewCell class] forCellReuseIdentifier:tableviewCellIndentifer];
        [self.view addSubview:_shouyeTableview];
        _shouyeTableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,64).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
        [self addMJheader];
    }
    return _shouyeTableview;
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
        _noDataView=[self noMessageView:@"暂无相关哦"];
        CGRect oldRect=_noDataView.frame;
        CGRect newRect=CGRectMake(SCREEN_WIDTH/2.0-oldRect.size.width/2.0, GetHeight(60), oldRect.size.width, oldRect.size.height);
        _noDataView.frame=newRect;
    }
    return _noDataView;
}

@end
