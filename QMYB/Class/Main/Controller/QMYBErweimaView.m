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
        
        UIImageView *imageView=[[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        imageView.backgroundColor=[UIColor lightGrayColor];
        imageView.layer.cornerRadius=3;
        imageView.clipsToBounds=YES;
        [self addSubview:imageView];
        imageView.sd_layout.topSpaceToView(self,0).leftSpaceToView(self,0).rightSpaceToView(self,0).bottomSpaceToView(self,65);
        self.erweimaImageView=imageView;
        
        UIButton *cancelButton=[[UIButton alloc]init];
        cancelButton.backgroundColor=[UIColor redColor];
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
