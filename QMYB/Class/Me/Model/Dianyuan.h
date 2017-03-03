//
//  Dianyuan.h
//  QMYB
//
//  Created by 大家保 on 2017/3/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dianyuan : NSObject

//用户名
@property (nonatomic,copy)NSString *businessName;
//电话
@property (nonatomic,copy)NSString *phone;
//创建时间
@property (nonatomic,assign)long long createTime;

@end
