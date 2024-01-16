//
//  GGLoadingBaseView.m
//  GGToolKit
//
//  Created by yg on 2023/10/20.
//

#import "GGLoadingBaseView.h"

#define QUERY_TAG 1008823133

@interface GGLoadingBaseView ()

@property (nonatomic, strong) __kindof GGLoadingBaseConfig *config;
@property (nonatomic, strong) UIView *backgroundView;

- (void)showInView:(UIView *)view configBlock:(GGBlankLoadingConfigBlock)configBlock;
- (void)dismiss;

@end

@implementation GGLoadingBaseView

+ (void)show{
    UIView *view = [self getCurrentWindow].rootViewController.view;
    [self showInView:view configBlock:nil];
}

+ (void)showInView:(UIView *_Nullable)view{
    [self showInView:view configBlock:nil];
}

+ (void)showInView:(UIView *_Nullable)view configBlock:(_Nullable GGBlankLoadingConfigBlock)configBlock{
    GGLoadingBaseView *loadingView = [view viewWithTag:QUERY_TAG];
    if (loadingView == nil){
        loadingView = [[self alloc] init];
    }
    [loadingView showInView:view configBlock:configBlock];
}

+ (void)reloadInView:(UIView *_Nullable)view configBlock:(_Nullable GGBlankLoadingConfigBlock)configBlock{
    GGLoadingBaseView *loadingView = [view viewWithTag:QUERY_TAG];
    if (configBlock){
        configBlock(loadingView.config);
    }
    [loadingView reloadData:loadingView.config];
}

+ (void)dismiss{
    UIView *view = [self getCurrentWindow].rootViewController.view;
    [self dismissInView:view];
}

+ (void)dismissInView:(UIView *)view{
    GGLoadingBaseView *loadingView = [view viewWithTag:QUERY_TAG];
    [loadingView dismiss];
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = NO;
        [self initializeViews];
    }
    return self;
}

- (__kindof GGLoadingBaseConfig *)initializeConfig{
    GGLoadingBaseConfig *config = [[GGLoadingBaseConfig alloc] init];
    config.enabledInteraction = YES;
    config.contentBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    return config;
}

- (void)initializeViews{
    _backgroundView = [[UIView alloc] init];
    [self addSubview:_backgroundView];
}

- (void)reloadFrames:(__kindof GGLoadingBaseConfig *)baseConfig{
    CGSize backgroundSize = self.superview.frame.size;
    self.backgroundView.frame = CGRectMake(0, 0, backgroundSize.width, backgroundSize.height);
    self.backgroundView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)reloadData:(__kindof GGLoadingBaseConfig *)baseConfig{
    _backgroundView.backgroundColor = baseConfig.contentBackgroundColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_config.enabledInteraction){
        self.frame = CGRectMake(CGRectGetWidth(self.superview.frame)/2, CGRectGetHeight(self.superview.frame)/2, 0, 0);
    }else{
        self.frame = self.superview.bounds;
    }
    [self reloadFrames:_config];
}

- (void)setConfig:(__kindof GGLoadingBaseConfig *)config{
    _config = config;
    [self reloadData:config];
    [self reloadFrames:_config];
}

- (void)showInView:(UIView *)view configBlock:(GGBlankLoadingConfigBlock)configBlock{
    GGLoadingBaseView *oldLoadingView = [view viewWithTag:QUERY_TAG];
    if (oldLoadingView){
        [oldLoadingView dismiss];
    }
    if (self.config == nil){
        self.config = [self initializeConfig];
    }
    if (configBlock){
        self.config = configBlock(self.config);
    }
    self.tag = QUERY_TAG;
    [self reloadData:_config];
    [self reloadFrames:_config];
    [view addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
}


@end

@implementation GGLoadingBaseConfig

@end
