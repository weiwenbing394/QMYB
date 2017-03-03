//
//  QMYBMonthSelectView.m
//  QMYB
//
//  Created by 大家保 on 2017/2/27.
//  Copyright © 2017年 大家保. All rights reserved.
//



#import "QMYBMonthSelectView.h"

@interface QMYBMonthSelectView ()

@property (nonatomic,strong)UIButton *selectedButtom;

@end

@implementation QMYBMonthSelectView

- (id)initWithArray:(NSArray<NSString *> *)view selectendIndex:(NSInteger )index onRect:(CGRect )on{
    self=[super init];
    if(self){
        
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        UIView *zhezhaoceng=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        zhezhaoceng.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        tap.numberOfTapsRequired=1;
        tap.numberOfTouchesRequired=1;
        [zhezhaoceng addGestureRecognizer:tap];
        [self addSubview:zhezhaoceng];
        
        
        CGFloat buttonWidth=GetWidth(100);
        CGFloat buttonHeight=GetHeight(35);
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-buttonWidth-GetWidth(10)*2, on.origin.y, buttonWidth+GetWidth(10), buttonHeight*view.count)];
        whiteView.backgroundColor=[UIColor whiteColor];
        whiteView.layer.borderColor=color0086ff.CGColor;
        whiteView.layer.borderWidth=1;
        whiteView.cornerRadius=3;
        whiteView.clipsToBounds=YES;
        
        [zhezhaoceng addSubview:whiteView];
        
        for (int i=0; i<view.count; i++) {
            UIButton *button=[[UIButton alloc]init];
            button.frame=CGRectMake(GetWidth(10), i*buttonHeight, buttonWidth, buttonHeight);
            button.backgroundColor=[UIColor clearColor];
            [button setTitle:view[i] forState:0];
            button.tag=100+i;
            [button.titleLabel setFont:font14];
            [button setTitleColor:color595959 forState:0];
            [button setTitleColor:color0086ff forState:UIControlStateDisabled];
            [button setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateDisabled];
            [button setImage:[UIImage imageNamed:@"勾选-1"] forState:UIControlStateNormal];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            if (i==index) {
                button.enabled=NO;
                self.selectedButtom=button;
            }
            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GetWidth(3)];
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:button];
        }
    }
    return self;

};

- (void)click:(UIButton *)sender{
    self.selectedButtom.enabled=YES;
    sender.enabled=NO;
    [sender layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GetWidth(3)];
    self.selectedButtom=sender;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectButtomAtIndex:)]) {
        [self.delegate selectButtomAtIndex:sender.tag-100];
    }
}

- (void)showInView:(UIViewController *)Sview{
    if (Sview==nil) {
        [KeyWindow.rootViewController.view addSubview:self ];
    }else{
        [Sview.view addSubview:self];
    }
};

- (void)tappedCancel{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tappedCancel)]) {
        [self.delegate tappedCancel];
    }
};


@end
