//
//  QMYBMainViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBMainViewController.h"
#import "WXApi.h"
#import "QMYBShouYeTableViewCell.h"
#import "QMYBShouYeModel.h"
#import "QMYBShareModel.h"
#import "QMYBWebViewController.h"


@interface QMYBMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *shouyeTableview;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@end

static NSString *const tableviewCellIndentifer=@"Cell";

@implementation QMYBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"精选产品"];
    [self.shouyeTableview reloadData];
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMYBShouYeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    QMYBShouYeModel *model=self.dataSourceArray[indexPath.section];
    cell.model=model;
    
    QMYBShareModel *shareModel=model.shareModel;
    WeakSelf;
    cell.erweimablock=^(){
        
    };
    cell.shareblock=^(){
        [weakSelf touch:shareModel];
    };
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMYBShouYeModel *model=self.dataSourceArray[indexPath.section];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[QMYBShouYeTableViewCell class] contentViewWidth:SCREEN_WIDTH];
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
    webViewController.urlStr=model.contentStr;
    [self.navigationController pushViewController:webViewController animated:YES];
}


//分享到朋友圈
- (void)touch:(QMYBShareModel *)shareModel{
    if ([WXApi isWXAppInstalled]) {
        WeakSelf;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [weakSelf shareWebPageToPlatformType:platformType withModel:shareModel] ;
        }];
    }else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提醒" message:@"您尚未安装微信客户端，暂无法使用微信分享功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(QMYBShareModel *)shareModel{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  shareModel.shareImageStr;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareModel.shareTitle descr:shareModel.shareDes thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = shareModel.contentStr;
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
        _shouyeTableview.sectionFooterHeight=GetHeight(15);
        _shouyeTableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _shouyeTableview.separatorColor=[UIColor redColor];
        [_shouyeTableview registerClass:[QMYBShouYeTableViewCell class] forCellReuseIdentifier:tableviewCellIndentifer];
        [self.view addSubview:_shouyeTableview];
        _shouyeTableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,64).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    }
    return _shouyeTableview;
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[NSMutableArray array];
        for (int i=0; i<10; i++) {
            QMYBShouYeModel *model=[[QMYBShouYeModel alloc]init];
            model.imageURL=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487569575404&di=2153b9910844f3d3f7b9dae74cd4e3fc&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F6c224f4a20a44623c51afdd39a22720e0df3d7ab.jpg";
            model.titleStr=@"我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题我是标题";
            model.price=@"100.00";
            model.erweimaStr=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487569575404&di=2153b9910844f3d3f7b9dae74cd4e3fc&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F6c224f4a20a44623c51afdd39a22720e0df3d7ab.jpg";
            model.contentStr=@"http://m.qmyb.dajiabao.com/";
            
            QMYBShareModel *shareModel=[[QMYBShareModel alloc]init];
            shareModel.shareTitle=@"测试";
            shareModel.shareDes=@"分享描述";
            shareModel.shareImageStr=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487569575404&di=2153b9910844f3d3f7b9dae74cd4e3fc&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F6c224f4a20a44623c51afdd39a22720e0df3d7ab.jpg";
            shareModel.contentStr=@"http://m.qmyb.dajiabao.com/";
            
            model.shareModel=shareModel;
            
            [_dataSourceArray addObject:model];
        }
    }
    return _dataSourceArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
