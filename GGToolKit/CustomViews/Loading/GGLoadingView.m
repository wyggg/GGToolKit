//
//  GGLoadingView.m
//  GGToolKit
//
//  Created by yg on 2023/10/13.
//

#import "GGLoadingView.h"

#define QUERY_TAG 1008823133

@interface GGLoadingView ()

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIView *loadingContentView;
@property (nonatomic, strong) UILabel *loadingMessageLabel;
@property (nonatomic, strong) UIView *loadingBodyView;


@end

@implementation GGLoadingView

+ (void)showSystemLoading{
    UIView *superView = [self getCurrentWindow].rootViewController.view;
    [self showInView:superView configBlock:^GGLoadingBaseConfig * _Nonnull(__kindof GGLoadingViewConfig * _Nonnull baseConfig) {
        baseConfig = [[GGLoadingViewConfig alloc] init];
        baseConfig.arrangementMode = GGLoadingViewArrangementModeHorizontal;
        baseConfig.enabledInteraction = NO;
        baseConfig.contentBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        baseConfig.bodyPosition = GGLoadingViewPositionCenter;
        baseConfig.bodyPositionOffsetX = 0;
        baseConfig.bodyPositionOffsetY = 0;
        baseConfig.bodyBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        baseConfig.bodyMargin = UIEdgeInsetsMake(10, 15, 10, 15);
        baseConfig.bodyCornerRadius = 10;
        baseConfig.message = @"加载中...";
        baseConfig.messageSpacing = 10;
        baseConfig.messageMaxWidth = 100;
        baseConfig.messageColor = [UIColor whiteColor];
        baseConfig.messageFont = [UIFont systemFontOfSize:12];
        baseConfig.loadingSize = CGSizeMake(15, 15);
        baseConfig.loadingView = [GGLoadingSystemStyleView create:^(GGLoadingSystemStyleView * _Nonnull view) {
            view.tintColor = baseConfig.messageColor;
        }];
        return baseConfig;
    }];
}

+ (void)showImageLoadingWithImage:(UIImage *)image{
    UIView *superView = [self getCurrentWindow].rootViewController.view;
    [self showInView:superView configBlock:^GGLoadingBaseConfig * _Nonnull(__kindof GGLoadingViewConfig * _Nonnull baseConfig) {
        baseConfig = [[GGLoadingViewConfig alloc] init];
        baseConfig.arrangementMode = GGLoadingViewArrangementModeHorizontal;
        baseConfig.enabledInteraction = NO;
        baseConfig.contentBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        baseConfig.bodyPosition = GGLoadingViewPositionCenter;
        baseConfig.bodyPositionOffsetX = 0;
        baseConfig.bodyPositionOffsetY = 0;
        baseConfig.bodyBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        baseConfig.bodyMargin = UIEdgeInsetsMake(20, 20, 20, 20);
        baseConfig.bodyCornerRadius = 20;
        baseConfig.message = @"";
        baseConfig.messageSpacing = 10;
        baseConfig.messageMaxWidth = 100;
        baseConfig.messageColor = [UIColor whiteColor];
        baseConfig.messageFont = [UIFont systemFontOfSize:14];
        baseConfig.loadingSize = image.size;
        baseConfig.loadingView = [GGLoadingImageStyleView create:^(GGLoadingImageStyleView * _Nonnull view) {
            view.image = image;
            view.tintColor = baseConfig.messageColor;
            view.rotationSpeed = 1;
        }];
        return baseConfig;
    }];
}

//初始化配置类
- (__kindof GGLoadingBaseConfig *)initializeConfig{
    GGLoadingViewConfig *config = [[GGLoadingViewConfig alloc] init];
    config.arrangementMode = GGLoadingViewArrangementModeHorizontal;
    config.enabledInteraction = NO;
    config.contentBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    config.bodyPosition = GGLoadingViewPositionCenter;
    config.bodyPositionOffsetX = 0;
    config.bodyPositionOffsetY = 0;
    config.bodyBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    config.bodyMargin = UIEdgeInsetsMake(10, 15, 10, 15);
    config.bodyCornerRadius = 10;
    config.message = @"加载中...";
    config.messageSpacing = 10;
    config.messageMaxWidth = 100;
    config.messageColor = [UIColor whiteColor];
    config.messageFont = [UIFont systemFontOfSize:12];
    config.loadingSize = CGSizeMake(15, 15);
    config.loadingView = [GGLoadingSystemStyleView create:^(GGLoadingSystemStyleView * _Nonnull view) {
        view.tintColor = config.messageColor;
    }];
//    config.loadingView = [GGLoadingImageStyleView create:^(GGLoadingImageStyleView * _Nonnull view) {
//        view.image = [UIImage imageNamed:@"loading"];
//        view.tintColor = config.messageColor;
//        view.rotationSpeed = 1;
//    }];
    return config;
}

//初始化子视图
- (void)initializeViews{
    [super initializeViews];
    
    _loadingContentView = [[UIView alloc] init];
    [self addSubview:_loadingContentView];
    
    _loadingMessageLabel = [[UILabel alloc] init];
    _loadingMessageLabel.textAlignment = NSTextAlignmentCenter;
    _loadingMessageLabel.numberOfLines = 0;
    [_loadingContentView addSubview:_loadingMessageLabel];
    
    _loadingBodyView = [[UIView alloc] init];
    [self insertSubview:_loadingBodyView belowSubview:_loadingContentView];
}

//刷新子视图frame
- (void)reloadFrames:(__kindof GGLoadingBaseConfig *)baseConfig{
    [super reloadFrames:baseConfig];
    GGLoadingViewConfig *config = baseConfig;
    //控制内容框大小
    if (config.arrangementMode == GGLoadingViewArrangementModeVertical){
        CGSize loadingSize = config.loadingSize;
        CGSize messageSize = [_loadingMessageLabel sizeThatFits:CGSizeMake(config.messageMaxWidth, CGFLOAT_MAX)];
        CGSize contentSize = CGSizeMake(MAX(loadingSize.width, messageSize.width), _loadingMessageLabel.text.length?loadingSize.height + messageSize.height + config.messageSpacing:loadingSize.height);
        _loadingView.frame = CGRectMake(contentSize.width/2 - loadingSize.width/2, 0, config.loadingSize.width, config.loadingSize.height);
        _loadingMessageLabel.frame = CGRectMake(contentSize.width/2 - messageSize.width/2, loadingSize.height + config.messageSpacing ,messageSize.width,messageSize.height);
        _loadingContentView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
        
    }else if (config.arrangementMode == GGLoadingViewArrangementModeHorizontal){
        CGSize loadingSize = config.loadingSize;
        CGSize messageSize = [_loadingMessageLabel sizeThatFits:CGSizeMake(config.messageMaxWidth, CGFLOAT_MAX)];
        CGSize contentSize = CGSizeMake(_loadingMessageLabel.text.length?loadingSize.width + messageSize.width + config.messageSpacing:loadingSize.width,MAX(loadingSize.height, messageSize.height));
        _loadingView.frame = CGRectMake(0, contentSize.height/2 - loadingSize.height/2, config.loadingSize.width, config.loadingSize.height);
        _loadingMessageLabel.frame = CGRectMake(loadingSize.width + config.messageSpacing, contentSize.height/2 - messageSize.height/2 ,messageSize.width,messageSize.height);
        _loadingContentView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    }
    
    //控制内容框显示位置
    if (config.bodyPosition == GGLoadingViewPositionCenter) {
        _loadingContentView.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - CGRectGetWidth(self.loadingContentView.frame)/2,
                                               CGRectGetHeight(self.frame)/2 - CGRectGetHeight(self.loadingContentView.frame)/2,
                                               CGRectGetWidth(self.loadingContentView.frame),
                                               CGRectGetHeight(self.loadingContentView.frame));
        _loadingContentView.frame = CGRectOffset(_loadingContentView.frame, config.bodyPositionOffsetX, config.bodyPositionOffsetY);
    }else if (config.bodyPosition == GGLoadingViewPositionLeft){
        CGFloat leftOffset = (self.frame.size.width - self.superview.frame.size.width) / 2;
        _loadingContentView.frame = CGRectMake(0,
                                               CGRectGetHeight(self.frame)/2 - CGRectGetHeight(self.loadingContentView.frame)/2,
                                               CGRectGetWidth(self.loadingContentView.frame),
                                               CGRectGetHeight(self.loadingContentView.frame));
        _loadingContentView.frame = CGRectOffset(_loadingContentView.frame, config.bodyPositionOffsetX + leftOffset, config.bodyPositionOffsetY);
    }else if (config.bodyPosition == GGLoadingViewPositionRight){
        CGFloat rightOffset = (self.frame.size.width - self.superview.frame.size.width) / 2 * -1;
        _loadingContentView.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.loadingContentView.frame),
                                               CGRectGetHeight(self.frame)/2 - CGRectGetHeight(self.loadingContentView.frame)/2,
                                               CGRectGetWidth(self.loadingContentView.frame),
                                               CGRectGetHeight(self.loadingContentView.frame));
        _loadingContentView.frame = CGRectOffset(_loadingContentView.frame, -config.bodyPositionOffsetX + rightOffset, config.bodyPositionOffsetY);
    }else if (config.bodyPosition == GGLoadingViewPositionTop){
        CGFloat topOffset = (self.frame.size.height - self.superview.frame.size.height) / 2;
        _loadingContentView.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - CGRectGetWidth(self.loadingContentView.frame)/2,
                                               0,
                                               CGRectGetWidth(self.loadingContentView.frame),
                                               CGRectGetHeight(self.loadingContentView.frame));
        _loadingContentView.frame = CGRectOffset(_loadingContentView.frame, config.bodyPositionOffsetX, config.bodyPositionOffsetY + topOffset);
    }else if (config.bodyPosition == GGLoadingViewPositionBottom){
        CGFloat bottomOffset = (self.frame.size.height - self.superview.frame.size.height) / 2 * -1;
        _loadingContentView.frame = CGRectMake(CGRectGetWidth(self.frame)/2 - CGRectGetWidth(self.loadingContentView.frame)/2,
                                               CGRectGetHeight(self.frame) - CGRectGetHeight(self.loadingContentView.frame),
                                               CGRectGetWidth(self.loadingContentView.frame),
                                               CGRectGetHeight(self.loadingContentView.frame));
        _loadingContentView.frame = CGRectOffset(_loadingContentView.frame, config.bodyPositionOffsetX, -config.bodyPositionOffsetY + bottomOffset);
    }
    
    //边框
    _loadingBodyView.frame = CGRectMake(_loadingContentView.frame.origin.x - config.bodyMargin.left, _loadingContentView.frame.origin.y - config.bodyMargin.top, _loadingContentView.frame.size.width + config.bodyMargin.left + config.bodyMargin.right, _loadingContentView.frame.size.height + config.bodyMargin.top + config.bodyMargin.bottom);
    
}

//刷新子视图显示
- (void)reloadData:(GGLoadingViewConfig *)config{
    [super reloadData:config];
    _loadingMessageLabel.text = config.message;
    _loadingMessageLabel.textColor = config.messageColor;
    _loadingMessageLabel.font = config.messageFont;
    _loadingBodyView.backgroundColor = config.bodyBackgroundColor;
    _loadingBodyView.layer.cornerRadius = config.bodyCornerRadius;
    if (config.loadingView == nil){
        config.loadingView = [GGLoadingSystemStyleView new];
    }
    [self configLoadingView:config.loadingView];
}

- (void)configLoadingView:(UIView *)loadingView{
    for (UIView *temp in self.loadingContentView.subviews) {
        if (![temp isKindOfClass:[UILabel class]]){
            [temp removeFromSuperview];
        }
    }
    _loadingView = loadingView;
    [self.loadingContentView addSubview:_loadingView];
}

+ (UIWindow *)getCurrentWindow{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

@end

@implementation GGLoadingViewConfig : GGLoadingBaseConfig

+ (GGLoadingViewConfig *)systemStyleWithTintColor:(UIColor *)tintColor message:(NSString *)message{
    GGLoadingViewConfig *config = [[GGLoadingViewConfig alloc] init];
    config.arrangementMode = GGLoadingViewArrangementModeHorizontal;
    config.enabledInteraction = NO;
    config.contentBackgroundColor = [UIColor clearColor];
    config.bodyPosition = GGLoadingViewPositionCenter;
    config.bodyPositionOffsetX = 0;
    config.bodyPositionOffsetY = 0;
    config.bodyBackgroundColor = [UIColor clearColor];
    config.bodyMargin = UIEdgeInsetsMake(10, 10, 10, 15);
    config.bodyCornerRadius = 0;
    config.message = @"message";
    config.messageSpacing = 10;
    config.messageMaxWidth = 100;
    config.messageColor = tintColor;
    config.messageFont = [UIFont systemFontOfSize:12];
    config.loadingSize = CGSizeMake(15, 15);
    config.loadingView = [GGLoadingSystemStyleView create:^(GGLoadingSystemStyleView * _Nonnull view) {
        view.tintColor = tintColor;
    }];
    return config;
}

+ (GGLoadingViewConfig *)imageStyleWithImage:(UIImage *)image tintColor:(UIColor *)tintColor{
    GGLoadingViewConfig *config = [[GGLoadingViewConfig alloc] init];
    config.arrangementMode = GGLoadingViewArrangementModeHorizontal;
    config.enabledInteraction = NO;
    config.contentBackgroundColor = [UIColor clearColor];
    config.bodyPosition = GGLoadingViewPositionCenter;
    config.bodyPositionOffsetX = 0;
    config.bodyPositionOffsetY = 0;
    config.bodyBackgroundColor = [UIColor clearColor];
    config.bodyMargin = UIEdgeInsetsMake(10, 10, 10, 15);
    config.bodyCornerRadius = 0;
    config.message = @"";
    config.messageSpacing = 10;
    config.messageMaxWidth = 100;
    config.messageColor = [UIColor whiteColor];
    config.messageFont = [UIFont systemFontOfSize:12];
    config.loadingSize = CGSizeMake(15, 15);
    config.loadingView = [GGLoadingImageStyleView create:^(GGLoadingImageStyleView * _Nonnull view) {
        view.image = image;
        view.rotationSpeed = 1;
        view.tintColor = config.messageColor;
    }];
    return config;
}


@end

@interface GGLoadingImageStyleView()

@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic) BOOL isAnimating;


@end

@implementation GGLoadingImageStyleView

+ (GGLoadingImageStyleView *)create:(void(^)(GGLoadingImageStyleView *view))block{
    GGLoadingImageStyleView *view = [[GGLoadingImageStyleView alloc] init];
    block(view);
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 创建并配置UIImageView
        self.loadingImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.loadingImageView];
        
        self.rotationSpeed = 1.0; // 默认旋转速度
        self.isAnimating = NO;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.loadingImageView.frame = self.bounds;
}

- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    [self reloadImage];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    [self reloadImage];
}

- (void)reloadImage{
    if (self.image == nil){
        return;
    }
    if (_tintColor == nil){
        _loadingImageView.tintColor = nil;
        _loadingImageView.image = [_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        _loadingImageView.tintColor = _tintColor;
        _loadingImageView.image = [_image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    [self stop];
    [self start];
}

- (void)setRotationSpeed:(CGFloat)rotationSpeed{
    if (rotationSpeed == _rotationSpeed){
        return;
    }
    _rotationSpeed = rotationSpeed;
    [self reloadImage];
}

- (void)start {
    if (!self.isAnimating) {
        [self rotateImageView];
        self.isAnimating = YES;
    }
}

- (void)stop {
    if (self.isAnimating) {
        [self.loadingImageView.layer removeAllAnimations];
        self.isAnimating = NO;
    }
}

- (void)rotateImageView {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1 / self.rotationSpeed; // 调整旋转速度
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end

@interface GGLoadingSystemStyleView()

@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicator;

@end

@implementation GGLoadingSystemStyleView

+ (GGLoadingSystemStyleView *)create:(void(^)(GGLoadingSystemStyleView *view))block{
    GGLoadingSystemStyleView *view = [[GGLoadingSystemStyleView alloc] init];
    block(view);
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        [self addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize activityIndicatorSize = [self.activityIndicator sizeThatFits:CGSizeZero];
    self.activityIndicator.frame = CGRectMake(self.frame.size.width/2 - activityIndicatorSize.width/2,
                                              self.frame.size.height/2 - activityIndicatorSize.height/2,
                                              activityIndicatorSize.width,
                                              activityIndicatorSize.height);
}

- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    self.activityIndicator.color = tintColor;
}

@end


