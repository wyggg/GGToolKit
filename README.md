# GGToolKit

## 安装

在Podfile中添加以下行：

```ruby
pod 'GGToolKit'
```

## 描述

个人开发工具包使用到的类库，方便快速开发。

```objc
#import <UIKit/UIKit.h>

@class GGBlankPageEmpty,GGBlankPageLoading;

typedef NS_ENUM(NSUInteger, GGBlankPageState) {
    GGBlankPageStateHidden,
    GGBlankPageStateLoding,
    GGBlankPageStateEmptyPage,
};

typedef NS_ENUM(NSUInteger, GGBlankPagePosition) {
    GGBlankPagePositionCenter,
    GGBlankPagePositionTop,
    GGBlankPagePositionBottom,
};

typedef NS_ENUM(NSUInteger, GGBlankPageBindMode) {
    GGBlankPageBindModeSectionsTotal,
    GGBlankPageBindModeCellTotal
};

@class GGBlankPageEmptyConfig,GGBlankPageLoadingConfig;

typedef GGBlankPageEmptyConfig *(^GGBlankPageEmptyConfigBlock)(GGBlankPageEmptyConfig *config);
typedef GGBlankPageLoadingConfig *(^GGBlankPageLoadingConfigBlock)(GGBlankPageLoadingConfig *config);

@interface GGBlankPage : UIView

@property (nonatomic, strong ,readonly) GGBlankPageEmpty *emptyPageView;
@property (nonatomic, strong ,readonly) GGBlankPageLoading *loadingView;

@property (nonatomic, assign) GGBlankPageState state;
@property (nonatomic, assign) GGBlankPageBindMode bindMode;

+ (void)bindScrollView:(UIScrollView *)scrollView inView:(UIView *)view mode:(GGBlankPageBindMode)mode config:(GGBlankPageEmptyConfigBlock)config;
+ (void)bindScrollView:(UIScrollView *)scrollView inView:(UIView *)view mode:(GGBlankPageBindMode)mode;
+ (void)bindScrollView:(UIScrollView *)scrollView inView:(UIView *)view;
+ (void)unBingScrollViewInView:(UIView *)view;

+ (void)configEmptyPageWithView:(UIView *)view config:(GGBlankPageEmptyConfigBlock)config;
+ (void)configLoadingWithView:(UIView *)view config:(GGBlankPageLoadingConfigBlock)config;

+ (void)showLoadingInView:(UIView *)view;
+ (void)showLoadingInView:(UIView *)view message:(NSString *)message;
+ (void)showLoadingInView:(UIView *)view customView:(UIView *)customView;
+ (void)showLoadingInView:(UIView *)view config:(GGBlankPageLoadingConfigBlock)config;

+ (void)showEmptyPageInView:(UIView *)view;
+ (void)showEmptyPageInView:(UIView *)view config:(GGBlankPageEmptyConfigBlock)config;
+ (void)showEmptyPageInView:(UIView *)view customView:(UIView *)customView;

+ (void)dismissInView:(UIView *)view;

@end


//基础空页面占位
@interface GGBlankPageEmpty : UIView

@property (nonatomic, strong) GGBlankPageEmptyConfig *config;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *button;

@end

@interface GGBlankPageEmptyConfig : NSObject

@property (nonatomic, assign) CGFloat topOffset;
@property (nonatomic, assign) CGFloat leftOffset;
@property (nonatomic, assign) CGFloat rightOffset;
@property (nonatomic, assign) CGFloat bottomOffset;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIFont *titleFont;
@property (nonatomic, copy) UIColor *titleColor;
@property (nonatomic, copy) void(^titleLabelMoreConfig)(UILabel *titleLabel);
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) UIFont *messageFont;
@property (nonatomic, copy) UIColor *messageColor;
@property (nonatomic, copy) void(^messageLabelMoreConfig)(UILabel *messageLabel);
@property (nonatomic, copy) NSString *restartButtonTitle;
@property (nonatomic, assign) CGSize restartButtonSize;
@property (nonatomic, strong) UIFont *restartButtonFont;
@property (nonatomic, strong) UIColor *restartButtonTitleColor;
@property (nonatomic, strong) UIColor *restartButtonBackgroundColor;
@property (nonatomic, copy) void(^restartButtonMoreConfig)(UIButton *restartButton);
@property (nonatomic, assign) CGFloat titleSpacing;
@property (nonatomic, assign) CGFloat subTitleSpacing;
@property (nonatomic, assign) CGFloat buttonSpacing;
@property (nonatomic, assign) GGBlankPagePosition position;
@property (nonatomic, assign) CGFloat positionOffset;
@property (nonatomic, copy) void(^restartButtonClick)(void);
@end


//基础加载中页面
@interface GGBlankPageLoading : UIView
@property (nonatomic, strong) GGBlankPageLoadingConfig *config;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@end

@interface GGBlankPageLoadingConfig : NSObject

@property (nonatomic, assign) CGFloat topOffset;
@property (nonatomic, assign) CGFloat leftOffset;
@property (nonatomic, assign) CGFloat rightOffset;
@property (nonatomic, assign) CGFloat bottomOffset;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, assign) GGBlankPagePosition position;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, assign) CGFloat messageSpacing;
@property (nonatomic, assign) CGFloat positionOffset;


@end

@interface UIView (GGBlankPage)
@property (nonatomic, strong) GGBlankPage *gg_blankPage;
@end

```



## 作者

yyyggg, 773678819@qq.com

