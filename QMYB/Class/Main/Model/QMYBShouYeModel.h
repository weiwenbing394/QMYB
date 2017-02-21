//
//  QMYBShouYeModel.h
//  QMYB
//
//  Created by 大家保 on 2017/2/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QMYBShareModel;

@interface QMYBShouYeModel : NSObject

@property (nonatomic,copy)NSString *imageURL;

@property (nonatomic,copy)NSString *titleStr;

@property (nonatomic,copy)NSString *price;

@property (nonatomic,copy)NSString *oldPrice;

@property (nonatomic,copy)NSString *erweimaStr;

@property (nonatomic,copy)NSString *contentStr;

@property (nonatomic,strong)QMYBShareModel *shareModel;

@end
