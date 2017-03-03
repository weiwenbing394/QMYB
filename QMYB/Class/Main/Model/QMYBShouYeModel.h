//
//  QMYBShouYeModel.h
//  QMYB
//
//  Created by 大家保 on 2017/2/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QMYBShouYeModel : NSObject
//图片
@property (nonatomic,copy)NSString *productImage;
//产品名称
@property (nonatomic,copy)NSString *productName;
//内容url
@property (nonatomic,copy)NSString *saleUrl;
//二维码
@property (nonatomic,copy)NSString *qrUrl;
//分享的标题
@property (nonatomic,copy)NSString *title;
//分享的副标题
@property (nonatomic,copy)NSString *subhead;
//分享的图片地址
@property (nonatomic,copy)NSString *shareImagePath;
//分享的内容点击地址
@property (nonatomic,copy)NSString *shareUrl;



@end
