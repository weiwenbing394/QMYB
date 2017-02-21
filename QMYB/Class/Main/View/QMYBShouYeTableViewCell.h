//
//  QMYBShouYeTableViewCell.h
//  QMYB
//
//  Created by 大家保 on 2017/2/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QMYBShouYeModel;

typedef void (^erweimaBlock) ();

typedef void (^shareBlock) ();

@interface QMYBShouYeTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *topImageView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *desLabel;

@property (nonatomic,strong)UIButton *erweimaButton;

@property (nonatomic,strong)UIButton *shareButton;

@property (nonatomic,strong)QMYBShouYeModel *model;

@property (nonatomic,copy)erweimaBlock erweimablock;

@property (nonatomic,copy)shareBlock  shareblock;

@end
