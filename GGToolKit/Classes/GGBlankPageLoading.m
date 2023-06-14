//
//  GGBlankPageLoading.m
//  GGToolKit_Example
//
//  Created by yg on 2023/6/14.
//  Copyright © 2023 yyyggg. All rights reserved.
//

#import "GGBlankPageLoading.h"

@interface GGBlankPageLoading()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation GGBlankPageLoading

+ (GGBlankPageLoading *)loading{
    GGBlankPageLoading *loading = [[GGBlankPageLoading alloc] init];
    return loading;
}

+ (GGBlankPageLoading *)loadingWithMessage:(NSString *)message{
    GGBlankPageLoading *loading = [[GGBlankPageLoading alloc] init];
    loading.messageLabel.text = message;
    return loading;
}

+ (GGBlankPageLoading *)loadingWithWithMessage:(NSString *)message position:(GGBlankPageLoadingPosition)position{
    GGBlankPageLoading *loading = [[GGBlankPageLoading alloc] init];
    loading.position = position;
    loading.messageLabel.text = message;
    return loading;
}

+ (GGBlankPageLoading *)loadingWithWithMessage:(NSString *)message position:(GGBlankPageLoadingPosition)position offset:(CGFloat)offset{
    GGBlankPageLoading *loading = [[GGBlankPageLoading alloc] init];
    loading.position = position;
    loading.positionOffset = offset;
    loading.messageLabel.text = message;
    return loading;
}

- (UIActivityIndicatorView *)activityIndicator{
    return _activityIndicatorView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _messageSpacing = 5;
        [self configUI];
    }
    return self;
}

- (void)configUI{
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textColor = [UIColor systemGrayColor];
    _messageLabel.font = [UIFont systemFontOfSize:12];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.numberOfLines = 0;
    [self addSubview:_messageLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateFrame];
}

- (void)updateFrame{
    
    // 计算视图高度
    CGFloat totalHeight = 0;
    CGFloat leftRightSpacing = 35;
    CGFloat viewWidth = CGRectGetWidth(self.bounds) - leftRightSpacing*2;
    
    CGSize activityIndicatorSize = [self.activityIndicatorView sizeThatFits:CGSizeMake(viewWidth, CGFLOAT_MAX)];
    self.activityIndicatorView.frame = CGRectMake(self.frame.size.width/2 - activityIndicatorSize.width/2, totalHeight, activityIndicatorSize.width, activityIndicatorSize.height);
    totalHeight += CGRectGetHeight(self.activityIndicatorView.frame) + self.messageSpacing;
    
    
    if (self.messageLabel.text.length != 0){
        CGSize titleSize = [self.messageLabel sizeThatFits:CGSizeMake(viewWidth, CGFLOAT_MAX)];
        self.messageLabel.frame = CGRectMake(leftRightSpacing, totalHeight, viewWidth, titleSize.height);
        totalHeight += CGRectGetHeight(self.messageLabel.frame) + self.messageSpacing;
    }
    
    CGFloat yOffset = 0;
    if (self.position == GGBlankPageLoadingPositionCenter){
        yOffset = (CGRectGetHeight(self.bounds) - totalHeight) / 2 + _positionOffset;
    }else if (self.position == GGBlankPageLoadingPositionTopCenter){
        yOffset = 0  + _positionOffset;
    }else if (self.position == GGBlankPageLoadingPositionBottomCenter){
        yOffset = CGRectGetHeight(self.bounds) - totalHeight - _positionOffset;
    }
    self.activityIndicatorView.frame = CGRectOffset(self.activityIndicatorView.frame, 0, yOffset);
    self.messageLabel.frame = CGRectOffset(self.messageLabel.frame, 0, yOffset);
}

- (void)setPosition:(GGBlankPageLoadingPosition)position{
    _position = position;
    [self updateFrame];
}

- (void)setPositionOffset:(CGFloat)positionOffset{
    _positionOffset = positionOffset;
    [self updateFrame];
}

@end
