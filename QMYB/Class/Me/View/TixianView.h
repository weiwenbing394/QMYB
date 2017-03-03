//
//  TixianView.h
//  QMYB
//
//  Created by 大家保 on 2017/3/3.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CancelBlock) ();

@interface TixianView : UIView

@property (nonatomic,copy)CancelBlock cancelBlock;

- (instancetype)initWithFrame:(CGRect)frame withImageUrlStr:(NSString *)imageStr;

@end
