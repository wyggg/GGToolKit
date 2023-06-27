//
//  GGBlankPage.m
//  GGToolKit
//
//  Created by yg on 2023/6/15.
//

#import "GGBlankPage.h"
#import <objc/runtime.h>

#define QUERY_TAG 1008823132

@interface GGBlankPage()

@property (nonatomic, strong) UIView *customEmptyPageView;
@property (nonatomic, strong) UIView *customLoadingView;

@end


@implementation GGBlankPage

@synthesize customEmptyPageView = _customEmptyPageView;
@synthesize customLoadingView = _customLoadingView;

+ (void)showLoadingInView:(UIView *)view customView:(UIView *)customView{
    GGBlankPage *pageView = [self queryPageViewInView:view];
    pageView.customLoadingView = customView;
    pageView.state = GGBlankPageStateLoding;
    [view addSubview:pageView];
    [view setNeedsLayout];
}

+ (void)showLoadingInView:(UIView *)view{
    [self showLoadingInView:view message:nil];
}

+ (void)showLoadingInView:(UIView *)view message:(NSString *)message{
    [self showLoadingInView:view config:^GGBlankPageLoadingConfig *(GGBlankPageLoadingConfig *config) {
        config.message = message;
        return config;
    }];
}

+ (void)showLoadingInView:(UIView *)view config:(GGBlankPageLoadingConfig *(^)(GGBlankPageLoadingConfig *config))config{
    GGBlankPage *pageView = [self queryPageViewInView:view];
    if (config){
        pageView.loadingView.config = config(pageView.loadingView.config);
    }
    pageView.state = GGBlankPageStateLoding;
    [view addSubview:pageView];
    [view setNeedsLayout];
}

+ (void)showEmptyPageInView:(UIView *)view{
    GGBlankPage *pageView = [self queryPageViewInView:view];
    pageView.state = GGBlankPageStateEmptyPage;
    [view addSubview:pageView];
    [view setNeedsLayout];
}

+ (void)showEmptyPageInView:(UIView *)view config:(GGBlankPageEmptyConfig *(^)(GGBlankPageEmptyConfig *config))config{
    GGBlankPage *pageView = [self queryPageViewInView:view];
    if (config){
        pageView.emptyPageView.config = config(pageView.emptyPageView.config);
    }
    pageView.state = GGBlankPageStateEmptyPage;
}

+ (void)showEmptyPageInView:(UIView *)view customView:(UIView *)customView{
    GGBlankPage *pageView = [self queryPageViewInView:view];
    pageView.customEmptyPageView = customView;
    pageView.state = GGBlankPageStateEmptyPage;
    [view addSubview:pageView];
    [view setNeedsLayout];
}

+ (void)dismissInView:(UIView *)view{
    NSArray *subViews = view.subviews;
    for (UIView *temp in subViews) {
        if ([temp isKindOfClass:[self class]]){
            [temp removeFromSuperview];
        }
    }
    view.gg_blankPage = nil;
}

+ (GGBlankPage *)queryPageViewInView:(UIView *)view{
    GGBlankPage *pageView = view.gg_blankPage;
    if (pageView == nil){
        pageView = [[GGBlankPage alloc] init];
        pageView.customLoadingView = nil;
        pageView.customEmptyPageView = nil;
        view.gg_blankPage = pageView;
    }
    return pageView;;
}

- (GGBlankPageEmpty *)emptyPageView{
    if ([self.customEmptyPageView isKindOfClass:[GGBlankPageEmpty class]]){
        return (GGBlankPageEmpty *)self.customEmptyPageView;
    }else{
        return nil;
    }
}

- (GGBlankPageLoading *)loadingView{
    if ([self.customLoadingView isKindOfClass:[GGBlankPageLoading class]]){
        return (GGBlankPageLoading *)self.customLoadingView;
    }else{
        return nil;
    }
}

- (UIView *)customLoadingView{
    if (_customLoadingView == nil){
        GGBlankPageLoading *loadingView = [[GGBlankPageLoading alloc] init];
        _customLoadingView = loadingView;
    }
    return _customLoadingView;
}

- (void)setCustomLoadingView:(UIView *)customLoadingView{
    [_customLoadingView removeFromSuperview];
    _customLoadingView = customLoadingView;
}

- (UIView *)customEmptyPageView{
    if (_customEmptyPageView == nil){
        GGBlankPageEmpty *pageView = [[GGBlankPageEmpty alloc] init];
        _customEmptyPageView = pageView;
    }
    return _customEmptyPageView;
}

- (void)setCustomEmptyPageView:(UIView *)customEmptyPageView{
    [_customEmptyPageView removeFromSuperview];
    _customEmptyPageView = customEmptyPageView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateFrames];
}

- (void)updateFrames{
    self.frame = CGRectMake(_leftOffset, _topOffset, self.superview.bounds.size.width - _leftOffset - _rightOffset, self.superview.bounds.size.height - _topOffset - _bottomOffset);
    [self.superview bringSubviewToFront:self];
    self.customLoadingView.frame = self.bounds;
    self.customEmptyPageView.frame = self.bounds;
}

- (void)setState:(GGBlankPageState)state{
    [self setState:state animate:YES];
}

- (void)setState:(GGBlankPageState)state animate:(BOOL)animate{
    _state = state;
    [self updateFrames];
    if (_state == GGBlankPageStateHidden){
        [self.customLoadingView removeFromSuperview];
        [self.customEmptyPageView removeFromSuperview];
    }else if (_state == GGBlankPageStateLoding){
        if (animate){
            [self addSubview:self.customLoadingView];
            self.customLoadingView.alpha = 0;
            self.customLoadingView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.customLoadingView.alpha = 1;
                self.customLoadingView.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                
            }];
            
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.customEmptyPageView.alpha = 0;
            } completion:^(BOOL finished) {
                self.customEmptyPageView.alpha = 1;
                [self.customEmptyPageView removeFromSuperview];
            }];
            
        }else{
            [self addSubview:self.customLoadingView];
            [self.customEmptyPageView removeFromSuperview];
        }
        
    }else if (_state == GGBlankPageStateEmptyPage){
        if (animate){
            [self addSubview:self.customEmptyPageView];
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.customLoadingView.alpha = 0;
            } completion:^(BOOL finished) {
                self.customLoadingView.alpha = 1;
                [self.customLoadingView removeFromSuperview];
            }];
            
            self.customEmptyPageView.alpha = 0;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.customEmptyPageView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [self addSubview:self.customEmptyPageView];
            [self.customLoadingView removeFromSuperview];
        }
    }
}

- (void)setcustomEmptyPageView:(GGBlankPageEmpty *)customEmptyPageView{
    if (self.customEmptyPageView){
        [self.customEmptyPageView removeFromSuperview];
    }
    _customEmptyPageView = customEmptyPageView;
    [self updateFrames];
    [self setState:_state];
}

- (void)setcustomLoadingView:(GGBlankPageLoading *)customLoadingView{
    if (self.customLoadingView){
        [self.customLoadingView removeFromSuperview];
    }
    _customLoadingView = customLoadingView;
    [self updateFrames];
    [self setState:_state];
}


@end


@implementation GGBlankPageEmpty

@synthesize config = _config;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = [UIColor systemGrayColor];
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.numberOfLines = 0;
    [self addSubview:_messageLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:14];
    _button.backgroundColor = [UIColor whiteColor];
    _button.layer.cornerRadius = 8;
    _button.layer.shadowColor = [UIColor blackColor].CGColor;
    _button.layer.shadowRadius = 2;
    _button.layer.shadowOffset = CGSizeMake(0, 1);
    _button.layer.shadowOpacity = 0.15;
    [_button addTarget:self action:@selector(buttonEvents) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
}

- (void)buttonEvents{
    if (self.config.restartButtonClick){
        self.config.restartButtonClick();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateFrames];
}

- (void)updateFrames{
    GGBlankPageEmptyConfig *config = self.config;
    
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
    }
    
    if (self.titleLabel.text.length != 0){
        CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(viewWidth, CGFLOAT_MAX)];
        self.titleLabel.frame = CGRectMake(leftRightSpacing, totalHeight, viewWidth, titleSize.height);
        totalHeight += CGRectGetHeight(self.titleLabel.frame) + config.subTitleSpacing;
    }
    
    if (self.messageLabel.text.length != 0){
        CGSize subTitleSize = [self.messageLabel sizeThatFits:CGSizeMake(viewWidth, CGFLOAT_MAX)];
        self.messageLabel.frame = CGRectMake(leftRightSpacing, totalHeight, viewWidth, subTitleSize.height);
        totalHeight += CGRectGetHeight(self.messageLabel.frame) + config.buttonSpacing;
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
    }
    
    // 将整个视图垂直居中
    CGFloat yOffset = 0;
    if (config.position == GGBlankPagePositionCenter){
        yOffset = (CGRectGetHeight(self.bounds) - totalHeight) / 2 + config.positionOffset;
    }else if (config.position == GGBlankPagePositionTop){
        yOffset = 0  + config.positionOffset;
    }else if (config.position == GGBlankPagePositionBottom){
        yOffset = CGRectGetHeight(self.bounds) - totalHeight + config.positionOffset;
    }
    self.imageView.frame = CGRectOffset(self.imageView.frame, 0, yOffset);
    self.titleLabel.frame = CGRectOffset(self.titleLabel.frame, 0, yOffset);
    self.messageLabel.frame = CGRectOffset(self.messageLabel.frame, 0, yOffset);
    self.button.frame = CGRectOffset(self.button.frame, 0, yOffset);
}

- (void)setConfig:(GGBlankPageEmptyConfig *)config{
    _config = config;
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
    [self updateFrames];
}

- (GGBlankPageEmptyConfig *)config{
    if (_config == nil){
        _config = [[GGBlankPageEmptyConfig alloc] init];
    }
    return _config;
}

@end

@implementation GGBlankPageEmptyConfig

- (instancetype)init{
    if (self = [super init]){
        _image = nil;
        _imageSize = CGSizeMake(0, 0);
        _title = @"加载失败";
        _titleFont = [UIFont boldSystemFontOfSize:20];
        _titleColor = [UIColor blackColor];
        _message = @"加载失败，点击按钮重试";
        _messageColor = [UIColor systemGrayColor];
        _messageFont = [UIFont systemFontOfSize:14];
        _restartButtonTitle = @"重试";
        _restartButtonFont = [UIFont systemFontOfSize:14];
        _restartButtonTitleColor = [UIColor blackColor];
        _restartButtonBackgroundColor = [UIColor whiteColor];
        _restartButtonSize = CGSizeMake(0, 0);
        _titleSpacing = 5;
        _subTitleSpacing = 10;
        _buttonSpacing = 20;
        _positionOffset = 0;
        _position = GGBlankPagePositionCenter;
    }
    return self;
}

@end

@implementation GGBlankPageLoading

@synthesize config = _config;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.numberOfLines = 0;
    [self addSubview:_messageLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateFrame];
}

- (void)updateFrame{
    
    GGBlankPageLoadingConfig *config = self.config;
    
    // 计算视图高度
    CGFloat totalHeight = 0;
    CGFloat leftRightSpacing = 35;
    CGFloat viewWidth = CGRectGetWidth(self.bounds) - leftRightSpacing*2;
    
    CGSize activityIndicatorSize = [self.activityIndicator sizeThatFits:CGSizeMake(viewWidth, CGFLOAT_MAX)];
    self.activityIndicator.frame = CGRectMake(self.frame.size.width/2 - activityIndicatorSize.width/2, totalHeight, activityIndicatorSize.width, activityIndicatorSize.height);
    totalHeight += CGRectGetHeight(self.activityIndicator.frame) + config.messageSpacing;
    
    if (self.messageLabel.text.length != 0){
        CGSize titleSize = [self.messageLabel sizeThatFits:CGSizeMake(viewWidth, CGFLOAT_MAX)];
        self.messageLabel.frame = CGRectMake(leftRightSpacing, totalHeight, viewWidth, titleSize.height);
        totalHeight += CGRectGetHeight(self.messageLabel.frame) + config.messageSpacing;
    }
    
    CGFloat yOffset = 0;
    if (config.position == GGBlankPagePositionCenter){
        yOffset = (CGRectGetHeight(self.bounds) - totalHeight) / 2 + config.positionOffset;
    }else if (config.position == GGBlankPagePositionTop){
        yOffset = 0  + config.positionOffset;
    }else if (config.position == GGBlankPagePositionBottom){
        yOffset = CGRectGetHeight(self.bounds) - totalHeight - config.positionOffset;
    }
    self.activityIndicator.frame = CGRectOffset(self.activityIndicator.frame, 0, yOffset);
    self.messageLabel.frame = CGRectOffset(self.messageLabel.frame, 0, yOffset);
}

- (void)setConfig:(GGBlankPageLoadingConfig *)config{
    _config = config;
    _messageLabel.text = config.message;
    _messageLabel.textColor = config.messageColor;
    _messageLabel.font = config.messageFont;
    [self updateFrame];
}

- (GGBlankPageLoadingConfig *)config{
    if (_config == nil){
        _config = [[GGBlankPageLoadingConfig alloc] init];
    }
    return _config;
}

@end

@implementation GGBlankPageLoadingConfig : NSObject

- (instancetype)init{
    if (self = [super init]){
        
        _messageSpacing = 5;
        _messageColor = [UIColor systemGrayColor];
        _messageFont = [UIFont systemFontOfSize:12];
        
    }
    return self;
}

@end


@implementation UIView (GGBlankPage)

- (GGBlankPage *)gg_blankPage
{
    return objc_getAssociatedObject(self, @selector(gg_blankPage));
}

- (void)setGg_blankPage:(GGBlankPage *)gg_blankPage
{
    if (self.gg_blankPage){
        [self.gg_blankPage removeFromSuperview];
    }
    objc_setAssociatedObject(self, @selector(gg_blankPage), gg_blankPage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

