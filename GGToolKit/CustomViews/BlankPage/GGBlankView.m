//
//  GGBlankView.m
//  GGToolKit
//
//  Created by yg on 2023/6/15.
//

#import "GGBlankView.h"
#import <objc/runtime.h>

#define QUERY_TAG 1008823132

@interface GGBlankView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *button;

@end


@implementation GGBlankView

+ (void)showInView:(UIView *)view image:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle contentOffset:(CGFloat)contentOffset buttonTitle:(NSString *)buttonTitle buttonEvents:(void(^)(void))buttonEvents{
    [GGBlankView showInView:view configBlock:^__kindof GGBlankConfig * _Nonnull(__kindof GGBlankConfig * _Nonnull config) {
        config.contentBackgroundColor = view.backgroundColor;
        config.image = image;
        config.title = title;
        config.message = subTitle;
        config.restartButtonTitle = buttonTitle;
        config.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        config.position = GGBlankViewPositionCenter;
        config.positionOffset = contentOffset;
        config.restartButtonClick = buttonEvents;
        return config;
    }];
}

+ (void)bindScrollView:(UIScrollView *)scrollView inView:(UIView *)inView image:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle contentOffset:(CGFloat)contentOffset buttonTitle:(NSString *)buttonTitle buttonEvents:(void(^)(void))buttonEvents{
    [GGBlankView bindScrollView:scrollView inView:inView mode:GGBlankViewBindModeCellTotal configBlock:^__kindof GGBlankConfig * _Nonnull(__kindof GGBlankConfig * _Nonnull config) {
        config.contentBackgroundColor = scrollView.backgroundColor;
        config.image = image;
        config.title = title;
        config.message = subTitle;
        config.restartButtonTitle = buttonTitle;
        config.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        config.position = GGBlankViewPositionCenter;
        config.positionOffset = contentOffset;
        config.restartButtonClick = buttonEvents;
        return config;
    }];
}

#pragma mark - Public Methods

- (__kindof GGBlankBaseConfig *)initializeConfig{
    GGBlankConfig *config = [[GGBlankConfig alloc] init];
    config.contentBackgroundColor = [UIColor clearColor];
    config.image = nil;
    config.imageSize = CGSizeMake(0, 0);
    config.title = nil;
    config.titleFont = [UIFont boldSystemFontOfSize:20];
    config.titleColor = [UIColor blackColor];
    config.message = nil;
    config.messageColor = [UIColor systemGrayColor];
    config.messageFont = [UIFont systemFontOfSize:14];
    config.restartButtonTitle = nil;
    config.restartButtonFont = [UIFont systemFontOfSize:14];
    config.restartButtonTitleColor = [UIColor blackColor];
    config.restartButtonBackgroundColor = [UIColor whiteColor];
    config.restartButtonSize = CGSizeMake(0, 0);
    config.titleSpacing = 5;
    config.subTitleSpacing = 10;
    config.buttonSpacing = 20;
    config.positionOffset = 0;
    config.position = GGBlankViewPositionCenter;
    return config;
}

- (void)initializeUI{
    
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = [UIColor systemGrayColor];
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.numberOfLines = 0;
    [self addSubview:_messageLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    _button.backgroundColor = [UIColor whiteColor];
    _button.layer.cornerRadius = 5;
    _button.layer.shadowColor = [UIColor blackColor].CGColor;
    _button.layer.shadowRadius = 2;
    _button.layer.shadowOffset = CGSizeMake(0, 1);
    _button.layer.shadowOpacity = 0.15;
    [_button addTarget:self action:@selector(buttonEvents) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
}

- (void)buttonEvents{
    GGBlankConfig *config = [self config];
    if (config.restartButtonClick){
        config.restartButtonClick();
    }
}

- (void)updateFrames:(__kindof GGBlankBaseConfig *)baseConfig{
    GGBlankConfig *config = baseConfig;
    // 计算视图高度
    CGFloat totalHeight = 0;
    CGFloat leftRightSpacing = 35;
    CGFloat viewWidth = CGRectGetWidth(self.bounds) - leftRightSpacing*2;
    
    CGSize imageSize = self.imageView.image.size;
    if (config.imageSize.width > 0 || config.imageSize.height > 0){
        imageSize = config.imageSize;
    }
    
    if (imageSize.width > 0 && imageSize.height > 0){
        self.imageView.frame = CGRectMake(CGRectGetWidth(self.bounds)/2 - imageSize.width/2 , 0, imageSize.width, imageSize.height);
        totalHeight += CGRectGetMaxY(self.imageView.frame) + config.titleSpacing;
    }else{
        self.imageView.frame = CGRectMake(-100, 0, 0, 0);
    }
    
    if (self.titleLabel.text.length != 0){
        CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(viewWidth, CGFLOAT_MAX)];
        self.titleLabel.frame = CGRectMake(leftRightSpacing, totalHeight, viewWidth, titleSize.height);
        totalHeight += CGRectGetHeight(self.titleLabel.frame) + config.subTitleSpacing;
    }else{
        self.titleLabel.frame = CGRectMake(-100, 0, 0, 0);
    }
    
    if (self.messageLabel.text.length != 0){
        CGSize subTitleSize = [self.messageLabel sizeThatFits:CGSizeMake(viewWidth, CGFLOAT_MAX)];
        self.messageLabel.frame = CGRectMake(leftRightSpacing, totalHeight, viewWidth, subTitleSize.height);
        totalHeight += CGRectGetHeight(self.messageLabel.frame) + config.buttonSpacing;
    }else{
        self.messageLabel.frame = CGRectMake(-100, 0, 0, 0);
    }
    
    if (self.button.titleLabel.text.length > 0){
        CGSize buttonSize = [self.button sizeThatFits:CGSizeMake(CGFLOAT_MAX, 35)];
        buttonSize.width = buttonSize.width + 50;
        buttonSize.height = buttonSize.height + 5;
        if (config.restartButtonSize.width > 0 && config.restartButtonSize.height > 0){
            buttonSize = config.restartButtonSize;
        }
        self.button.frame = CGRectMake(CGRectGetWidth(self.bounds)/2 - buttonSize.width/2 , totalHeight, buttonSize.width, buttonSize.height);
        totalHeight += CGRectGetHeight(self.button.frame);
    }else{
        self.button.frame = CGRectMake(-100, 0, 0, 0);
    }
    
    // 将整个视图垂直居中
    CGFloat yOffset = 0;
    if (config.position == GGBlankViewPositionCenter){
        yOffset = (CGRectGetHeight(self.bounds) - totalHeight) / 2 + config.positionOffset;
    }else if (config.position == GGBlankViewPositionTop){
        yOffset = 0  + config.positionOffset;
    }else if (config.position == GGBlankViewPositionBottom){
        yOffset = CGRectGetHeight(self.bounds) - totalHeight + config.positionOffset;
    }
    self.imageView.frame = CGRectOffset(self.imageView.frame, 0, yOffset);
    self.titleLabel.frame = CGRectOffset(self.titleLabel.frame, 0, yOffset);
    self.messageLabel.frame = CGRectOffset(self.messageLabel.frame, 0, yOffset);
    self.button.frame = CGRectOffset(self.button.frame, 0, yOffset);
}

- (void)reloadData:(__kindof GGBlankBaseConfig *)baseConfig{
    [super reloadData:baseConfig];
    GGBlankConfig *config = baseConfig;
    _imageView.image = config.image;
    _titleLabel.text = config.title;
    _titleLabel.font = config.titleFont;
    _titleLabel.textColor = config.titleColor;
    _messageLabel.text = config.message;
    _messageLabel.font = config.messageFont;
    _messageLabel.textColor = config.messageColor;
    [_button setTitle:config.restartButtonTitle forState:UIControlStateNormal];
    [_button setTitleColor:config.restartButtonTitleColor forState:UIControlStateNormal];
    [_button setBackgroundColor:config.restartButtonBackgroundColor];
    _button.titleLabel.font = config.restartButtonFont;
    if (config.titleLabelMoreConfig){
        config.titleLabelMoreConfig(_titleLabel);
    }
    if (config.messageLabelMoreConfig){
        config.messageLabelMoreConfig(_messageLabel);
    }
    if (config.restartButtonMoreConfig){
        config.restartButtonMoreConfig(_button);
    }
}

@end

@implementation GGBlankConfig

@end





