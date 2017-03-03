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
    self.titleLabel.textColor=color3b3b3b;
    self.titleLabel.font=BoldSystemFont(GetWidth(15));
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.desLabel=[[UILabel alloc]init];
    self.desLabel.textColor=[UIColor darkGrayColor];
    self.desLabel.font=font12;
    self.desLabel.textAlignment=NSTextAlignmentCenter;
    self.desLabel.textColor=colorF57FF1;
    [self.contentView addSubview:self.desLabel];
    
    
    self.erweimaButton=[[UIButton alloc]init];
    [self.erweimaButton setImage:[UIImage imageNamed:@"二维码"] forState:0];
    [self.erweimaButton addTarget:self action:@selector(erweimaClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.erweimaButton];
    
    self.shareButton=[[UIButton alloc]init];
    [self.shareButton setImage:[UIImage imageNamed:@"分享"] forState:0];
    [self.shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.shareButton];
}


- (void)bindConstraints{
    
//    self.topImageView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).topSpaceToView(self.contentView,0).heightIs(SCREEN_WIDTH*200/375.0);
//    
//    self.shareButton.sd_layout.rightSpaceToView(self.contentView,GetWidth(8)).topSpaceToView(self.topImageView,GetHeight(0)).heightIs(GetHeight(40)).widthEqualToHeight(self.shareButton);
//    
//    self.erweimaButton.sd_layout.rightSpaceToView(self.shareButton,GetWidth(0)).topEqualToView(self.shareButton).heightRatioToView(self.shareButton,1).widthEqualToHeight(self.erweimaButton);
//    
//    self.titleLabel.sd_layout.leftSpaceToView(self.contentView,GetWidth(15)).topSpaceToView(self.topImageView,0).bottomEqualToView(self.shareButton).maxWidthIs(SCREEN_WIDTH/2.0);
//    
//    self.desLabel.sd_layout.leftSpaceToView(self.titleLabel,GetWidth(15)).rightSpaceToView(self.erweimaButton,GetWidth(15)).topEqualToView(self.titleLabel).bottomEqualToView(self.titleLabel);
//    
//    [self setupAutoHeightWithBottomView:self.shareButton bottomMargin:GetHeight(0)];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(SCREEN_WIDTH*200/375.0);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImageView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-GetWidth(6));
        make.width.height.mas_equalTo(GetHeight(40));
    }];
    
    [self.erweimaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImageView.mas_bottom);
        make.right.mas_equalTo(self.shareButton.mas_left).offset(0);
        make.width.height.mas_equalTo(GetHeight(40));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImageView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(GetWidth(15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(GetWidth(10));
        make.height.mas_equalTo(GetHeight(20));
    }];
}


- (void)setModel:(QMYBShouYeModel *)model{
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.productImage]placeholderImage:[UIImage imageNamed:@"空白图"]];
    
    self.titleLabel.text=model.productName?model.productName:@"";
    
    self.desLabel.text=@"热销";
    
    CGFloat stringWidth=[self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, GetWidth(40)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font17} context:nil].size.width;
    
    CGFloat desWidth=[self.desLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, GetWidth(32)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font14} context:nil].size.width;
    
    [self.desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(desWidth+10);
    }];
    
    if (0<self.desLabel.text.length) {
        self.desLabel.layer.cornerRadius=2;
        self.desLabel.borderColor=colorF57FF1;
        self.desLabel.borderWidth=0.5;
    }
    
    if (stringWidth>=SCREEN_WIDTH-2*GetWidth(15)-GetWidth(10)-2*GetHeight(40)-GetWidth(6)-desWidth-10) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH-2*GetWidth(15)-GetWidth(10)-2*GetHeight(40)-GetWidth(6)-desWidth-10);
        }];
    }
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
