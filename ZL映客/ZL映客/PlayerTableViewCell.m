//
//  PlayerTableViewCell.m
//  ZL映客
//
//  Created by fengei on 16/8/4.
//  Copyright © 2016年 fengei. All rights reserved.
//

#import "PlayerTableViewCell.h"
#import "UIImageView+WebCache.h"
#define Ratio 618/480
#define UIScreen_Width [UIScreen mainScreen].bounds.size.width
#define UIScreen_Height [UIScreen mainScreen].bounds.size.height
@implementation PlayerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self addSubview:self.iconImage];
        [self addSubview:self.nameLabel];
        [self addSubview:self.address];
        [self addSubview:self.peopleNumber];
        [self addSubview:self.coverImage];
    }
    return self;
}
- (UIImageView *)iconImage
{
    if(!_iconImage)
    {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
        _iconImage.layer.cornerRadius = _iconImage.frame.size.width / 2;
        _iconImage.layer.masksToBounds = YES;
        CALayer *layer = [_iconImage layer];
        layer.borderColor = [UIColor purpleColor].CGColor;
        layer.borderWidth = 1.5;
    }
    return _iconImage;
}
- (UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImage.frame.origin.x+CGRectGetWidth(_iconImage.frame)+10, _iconImage.frame.origin.y, UIScreen_Width, CGRectGetHeight(_iconImage.frame)/2)];
        _nameLabel.text = @"映客";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}
- (UIButton *)address
{
    if(!_address)
    {
        _address = [UIButton buttonWithType:UIButtonTypeCustom];
        _address.frame = CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height, UIScreen_Width/2, _nameLabel.frame.size.height);
        [_address setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
        [_address setTitle:@"中国" forState:UIControlStateNormal];
        [_address setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _address.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _address.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _address.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _address;
}
- (UILabel *)peopleNumber
{
    if(!_peopleNumber)
    {
        _peopleNumber = [[UILabel alloc]initWithFrame:CGRectMake(_address.frame.origin.x+_address.frame.size.width, _address.frame.origin.y, UIScreen_Width/3-40, _address.frame.size.height)];
        _peopleNumber.textColor = [UIColor purpleColor];
        _peopleNumber.text = @"9999";
        _peopleNumber.font = [UIFont systemFontOfSize:15];
        _peopleNumber.textAlignment = NSTextAlignmentRight;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_peopleNumber.frame.origin.x+_peopleNumber.frame.size.width, _peopleNumber.frame.origin.y+1.5, 30, _peopleNumber.frame.size.height)];
        label.text = @" 在看";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
    }
    return _peopleNumber;
}
- (UIImageView *)coverImage
{
    if(!_coverImage)
    {
        _coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, _iconImage.frame.origin.y+_iconImage.frame.size.height+10, UIScreen_Width, ([UIScreen mainScreen].bounds.size.width * Ratio)+1 - _iconImage.frame.size.height - 20)];
    }
    return _coverImage;
}
- (void)setModel:(PlayerModel *)model
{
    _model = model;
    _nameLabel.text = model.name;
    //用户所在的城市
    if([model.city isEqualToString:@""])
    {
        [_address setTitle:@"难道在火星" forState:UIControlStateNormal];
    }else
    {
        [_address setTitle:model.city forState:UIControlStateNormal];
    }
    
    //用户Image
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",model.portrait]]];
    //封面
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",model.portrait]]];
    // 观看的人数
    _peopleNumber.text = [NSString stringWithFormat:@"%d",model.online_users];
}
@end
