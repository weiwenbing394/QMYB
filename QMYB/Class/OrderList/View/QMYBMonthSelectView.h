//
//  QMYBMonthSelectView.h
//  QMYB
//
//  Created by 大家保 on 2017/2/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectView_delegate <NSObject>

- (void)selectButtomAtIndex:(NSInteger )index;

- (void)tappedCancel;

@end

@interface QMYBMonthSelectView : UIView

@property (nonatomic,assign)id<SelectView_delegate> delegate;

- (id)initWithArray:(NSArray<NSString *> *)view selectendIndex:(NSInteger )index onRect:(CGRect )on;

- (void)showInView:(UIViewController *)Sview;


@end
