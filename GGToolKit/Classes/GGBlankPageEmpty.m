//
//  GGBlankPageEmpty.m
//  GGToolKit_Example
//
//  Created by yg on 2023/6/14.
//  Copyright © 2023 yyyggg. All rights reserved.
//

#import "GGBlankPageEmpty.h"

@implementation GGBlankPageEmpty

+ (GGBlankPageEmpty *)emptyWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle buttonTitle:(NSString *)buttonTitle click:(void(^)(void))click{
    GGBlankPageEmpty *view = [[GGBlankPageEmpty alloc] init];
    view.imageView.image = image;
    view.titleLabel.text = title;
    view.subTitleLabel.text = subTitle;
    [view.button setTitle:buttonTitle forState:UIControlStateNormal];
    view.restartButtonClick = click;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleSpacing = 5;
        _subTitleSpacing = 10;
        _buttonSpacing = 20;
        _positionOffset = 0;
        [self configUI];
    }
    return self;
}

- (void)configUI{
    
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.textColor = [UIColor systemGrayColor];
    _subTitleLabel.font = [UIFont systemFontOfSize:14];
    _subTitleLabel.numberOfLines = 0;
    [self addSubview:_subTitleLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _button.backgroundColor = [UIColor whiteColor];
    _button.layer.cornerRadius = 8;
    _button.layer.shadowColor = [UIColor blackColor].CGColor;
    _button.layer.shadowRadius = 1;
    _button.layer.shadowOffset = CGSizeMake(0, 0);
    _button.layer.shadowOpacity = 0.1;
    [_button addTarget:self action:@selector(buttonEvents) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
}

- (void)buttonEvents{
    if (self.restartButtonClick){
        self.restartButtonClick();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 计算视图高度
    CGFloat totalHeight = 0;
    CGFloat leftRightSpacing = 35;
    CGFloat viewWidth = CGRectGetWidth(self.bounds) - leftRightSpacing*2;
    
    CGSize imageSize = self.imageView.image.size;
    if (self.imageSize.width > 0 || self.imageSize.height > 0){
        imageSize = self.imageSize;
    }
    if (imageSize.width > 0 && imageSize.height > 0){
        self.imageView.frame = CGRectMake(CGRectGetWidth(self.bounds)/2 - imageSize.width/2 , 0, imageSize.width, imageSize.height);
        totalHeight += CGRectGetMaxY(self.imageView.frame) + self.titleSpacing;
    }
    
    if (self.titleLabel.text.length != 0){
        CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(viewWidth, CGFLOAT_MAX)];
        self.titleLabel.frame = CGRectMake(leftRightSpacing, totalHeight, viewWidth, titleSize.height);
        totalHeight += CGRectGetHeight(self.titleLabel.frame) + self.subTitleSpacing;
    }
    
    if (self.subTitleLabel.text.length != 0){
        CGSize subTitleSize = [self.subTitleLabel sizeThatFits:CGSizeMake(viewWidth, CGFLOAT_MAX)];
        self.subTitleLabel.frame = CGRectMake(leftRightSpacing, totalHeight, viewWidth, subTitleSize.height);
        totalHeight += CGRectGetHeight(self.subTitleLabel.frame) + self.buttonSpacing;
    }
    
    if (self.button.titleLabel.text.length > 0){
        CGSize buttonSize = [self.button sizeThatFits:CGSizeMake(CGFLOAT_MAX, 35)];
        buttonSize.width = buttonSize.width + 50;
        buttonSize.height = buttonSize.height + 5;
        if (self.buttonSize.width > 0 && self.buttonSize.height > 0){
            buttonSize = self.buttonSize;
        }
        self.button.frame = CGRectMake(CGRectGetWidth(self.bounds)/2 - buttonSize.width/2 , totalHeight, buttonSize.width, buttonSize.height);
        totalHeight += CGRectGetHeight(self.button.frame);
    }
    
    
    // 将整个视图垂直居中
    CGFloat yOffset = 0;
    if (self.position == GGBlankPageEmptyPositionCenter){
        yOffset = (CGRectGetHeight(self.bounds) - totalHeight) / 2 + _positionOffset;
    }else if (self.position == GGBlankPageEmptyPositionTop){
        yOffset = 0  + _positionOffset;
    }else if (self.position == GGBlankPageEmptyPositionBottom){
        yOffset = CGRectGetHeight(self.bounds) - totalHeight + _positionOffset;
    }
    self.imageView.frame = CGRectOffset(self.imageView.frame, 0, yOffset);
    self.titleLabel.frame = CGRectOffset(self.titleLabel.frame, 0, yOffset);
    self.subTitleLabel.frame = CGRectOffset(self.subTitleLabel.frame, 0, yOffset);
    self.button.frame = CGRectOffset(self.button.frame, 0, yOffset);
}

@end
