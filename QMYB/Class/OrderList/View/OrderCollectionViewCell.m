//
//  OrderCollectionViewCell.m
//  tianyi360
//
//  Created by 大家保 on 16/7/5.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "OrderCollectionViewCell.h"

@implementation OrderCollectionViewCell

- (void)setShowsVc:(UIViewController *)showsVc {
    _showsVc = showsVc;
    [self addSubview:showsVc.view];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.showsVc.view.frame=self.bounds;
}


@end
