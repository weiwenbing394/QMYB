//
//  QMYBErweimaView.m
//  QMYB
//
//  Created by 大家保 on 2017/2/22.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBErweimaView.h"

@interface QMYBErweimaView ()

@property (nonatomic,strong)UIImageView *erweimaImageView;

@property (nonatomic,strong)UIButton *cancelButton;

@end

@implementation QMYBErweimaView


- (instancetype)initWithFrame:(CGRect)frame withImageUrlStr:(NSString *)imageStr{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        
        UIView *whiteView=[[UIView alloc]init];
        whiteView.layer.cornerRadius=GetWidth(10);
        whiteView.clipsToBounds=YES;
        whiteView.backgroundColor=[UIColor colorWithHexString:@"#cfebff"];
        [self addSubview:whiteView];
        whiteView.sd_layout.topSpaceToView(self,0).leftSpaceToView(self,0).rightSpaceToView(self,0).bottomSpaceToView(self,65);
        
        UIView *whiteView2=[[UIView alloc]init];
        whiteView2.backgroundColor=[UIColor whiteColor];
        whiteView2.borderWidth=0.5;
        whiteView2.borderColor=[UIColor colorWithHexString:@"#cfebff"];
        [whiteView addSubview:whiteView2];
        whiteView2.sd_layout.topSpaceToView(whiteView,GetWidth(12)).leftSpaceToView(whiteView,GetWidth(12)).rightSpaceToView(whiteView,GetWidth(12)).bottomSpaceToView(whiteView,GetWidth(12));
        
        UIImageView *imageView=[[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"空白图"]];
        imageView.backgroundColor=[UIColor whiteColor];
        imageView.layer.cornerRadius=0;
        imageView.clipsToBounds=YES;
        [whiteView addSubview:imageView];
        imageView.sd_layout.topSpaceToView(whiteView,GetWidth(20)).leftSpaceToView(whiteView,GetWidth(20)).rightSpaceToView(whiteView,GetWidth(20)).bottomSpaceToView(whiteView,GetWidth(20));
        self.erweimaImageView=imageView;
        
        UIButton *cancelButton=[[UIButton alloc]init];
        cancelButton.backgroundColor=[UIColor clearColor];
        [cancelButton setImage:[UIImage imageNamed:@"gb"] forState:0];
        [cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.layer.cornerRadius=25;
        cancelButton.clipsToBounds=YES;
        [self addSubview:cancelButton];
        cancelButton.sd_layout.bottomSpaceToView(self,0).centerXEqualToView(self).widthIs(50).heightEqualToWidth(cancelButton);
        self.cancelButton=cancelButton;
        
    }
    return self;
}

- (void)cancelClick:(UIButton *)sender{
    self.cancelBlock?self.cancelBlock():nil;
}

@end
