//
//  QMYBShouYeTableViewCell.m
//  QMYB
//
//  Created by 大家保 on 2017/2/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBShouYeTableViewCell.h"
#import "QMYBShouYeModel.h"


@implementation QMYBShouYeTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self bindConstraints];
    }
    return self;
}


- (void)initUI{

    self.backgroundColor=[UIColor whiteColor];
   
    self.topImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_topImageView];
    
    self.titleLabel=[[UILabel alloc]init];
    self.titleLabel.textColor=[UIColor blackColor];
    self.titleLabel.font=font17;
    [self.contentView addSubview:self.titleLabel];
    
    self.desLabel=[[UILabel alloc]init];
    self.desLabel.textColor=[UIColor darkGrayColor];
    self.desLabel.font=font15;
    [self.contentView addSubview:self.desLabel];
    
    
    self.erweimaButton=[[UIButton alloc]init];
    [self.erweimaButton setImage:[UIImage imageNamed:@"tabBar_essence_click_icon"] forState:0];
    [self.erweimaButton addTarget:self action:@selector(erweimaClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.erweimaButton];
    
    self.shareButton=[[UIButton alloc]init];
    [self.shareButton setImage:[UIImage imageNamed:@"tabBar_essence_click_icon"] forState:0];
    [self.shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.shareButton];
}


- (void)bindConstraints{
    
    self.topImageView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).topSpaceToView(self.contentView,0).heightIs(GetHeight(250));
    
    self.shareButton.sd_layout.rightSpaceToView(self.contentView,GetWidth(0)).topSpaceToView(self.topImageView,GetHeight(0)).heightIs(GetHeight(60)).widthEqualToHeight(self.shareButton);
    
    self.erweimaButton.sd_layout.rightSpaceToView(self.shareButton,GetWidth(0)).topEqualToView(self.shareButton).heightRatioToView(self.shareButton,1).widthEqualToHeight(self.erweimaButton);
    
    self.titleLabel.sd_layout.leftSpaceToView(self.contentView,GetWidth(12)).rightSpaceToView(self.erweimaButton,GetWidth(0)).topSpaceToView(self.topImageView,GetHeight(10)).heightIs(GetWidth(17));
    
    self.desLabel.sd_layout.leftSpaceToView(self.contentView,GetWidth(12)).rightSpaceToView(self.erweimaButton,GetWidth(0)).topSpaceToView(self.titleLabel,GetHeight(6)).heightIs(GetWidth(15));
    
    [self setupAutoHeightWithBottomView:self.shareButton bottomMargin:GetHeight(0)];
}


- (void)setModel:(QMYBShouYeModel *)model{
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]placeholderImage:nil];
    self.titleLabel.text=model.titleStr?model.titleStr:@"";
    self.desLabel.text=model.price?model.price:@"";
}

- (void)erweimaClick:(UIButton *)sender{
    _erweimablock?_erweimablock():nil;
}

- (void)shareClick:(UIButton *)sender{
    _shareblock?_shareblock():nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
