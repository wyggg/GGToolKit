//
//  GGLoadingView.h
//  GGToolKit
//
//  Created by yg on 2023/10/13.
//

#import "GGLoadingBaseView.h"



NS_ASSUME_NONNULL_BEGIN

@class GGLoadingViewConfig;


@interface GGLoadingView : GGLoadingBaseView

+ (void)showSystemLoading;
+ (void)showImageLoadingWithImage:(UIImage *)image;

@end

typedef NS_ENUM(NSUInteger, GGLoadingViewPosition) {
    GGLoadingViewPositionCenter,
    GGLoadingViewPositionTop,
    GGLoadingViewPositionLeft,
    GGLoadingViewPositionBottom,
    GGLoadingViewPositionRight,
};

typedef NS_ENUM(NSUInteger, GGLoadingViewArrangementMode) {
    GGLoadingViewArrangementModeHorizontal,
    GGLoadingViewArrangementModeVertical
};

@interface GGLoadingViewConfig : GGLoadingBaseConfig

@property (nonatomic, assign) GGLoadingViewArrangementMode arrangementMode;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, assign) CGSize loadingSize;

@property (nonatomic, assign) GGLoadingViewPosition bodyPosition;
@property (nonatomic, assign) CGFloat bodyPositionOffsetX;
@property (nonatomic, assign) CGFloat bodyPositionOffsetY;

@property (nonatomic, strong) UIColor *bodyBackgroundColor;
@property (nonatomic, assign) UIEdgeInsets bodyMargin;
@property (nonatomic, assign) CGFloat bodyCornerRadius;

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, assign) CGFloat messageMaxWidth;
@property (nonatomic, assign) CGFloat messageSpacing;

@end

@interface GGLoadingImageStyleView : UIView

@property (nonatomic) UIImage *image;
@property (nonatomic) UIColor *tintColor;
@property (nonatomic) CGFloat rotationSpeed;//推荐范围 0..1

+ (GGLoadingImageStyleView *)create:(void(^)(GGLoadingImageStyleView *view))block;

@end

@interface GGLoadingSystemStyleView : UIView

@property (nonatomic, strong) UIColor *tintColor;

+ (GGLoadingSystemStyleView *)create:(void(^)(GGLoadingSystemStyleView *view))block;

@end

NS_ASSUME_NONNULL_END
