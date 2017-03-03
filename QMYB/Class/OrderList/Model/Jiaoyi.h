//
//  Jiaoyi.h
//  QMYB
//
//  Created by 大家保 on 2017/3/2.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Jiaoyi : NSObject
//产品图片
@property (nonatomic,copy)NSString *productImage;
//产品名称
@property (nonatomic,copy)NSString *productName;
//状态（1 成单 ，2  退单）
@property (nonatomic,assign)NSInteger tradeType;
//价钱
@property (nonatomic,assign)CGFloat premium;
//时间
@property (nonatomic,assign)long long tradeTime;

@end
