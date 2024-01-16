//
//  GGBlankBaseView.h
//  GGToolKit
//
//  Created by yg on 2023/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GGBlankViewBindMode) {
    GGBlankViewBindModeCellTotal,
    GGBlankViewBindModeSectionsTotal
};

typedef NS_ENUM(NSUInteger, GGBlankViewDisplayStatus) {
    GGBlankViewDisplayStatusShow,
    GGBlankViewDisplayStatusHidden
};

@class GGBlankBaseConfig;

typedef __kindof GGBlankBaseConfig *_Nonnull(^GGBlankConfigBlock)(__kindof GGBlankBaseConfig *config);


@interface GGBlankBaseView : UIView

@property (nonatomic, strong) __kindof GGBlankBaseConfig *config;

+ (void)showInView:(UIView *)view configBlock:(GGBlankConfigBlock)configBlock;
+ (void)showInView:(UIView *)view custom:(UIView *)custom;
+ (void)dismissInView:(UIView *)view;

+ (void)bindScrollView:(UIScrollView *)scrollView inView:(UIView *)view mode:(GGBlankViewBindMode)mode configBlock:(GGBlankConfigBlock)configBlock;
+ (void)bindScrollView:(UIScrollView *)scrollView inView:(UIView *)view mode:(GGBlankViewBindMode)mode custom:(UIView *)custom;
+ (void)bindScrollView:(UIScrollView *)scrollView mode:(GGBlankViewBindMode)mode configBlock:(GGBlankConfigBlock)configBlock;
+ (void)bindScrollView:(UIScrollView *)scrollView mode:(GGBlankViewBindMode)mode custom:(UIView *)custom;
+ (void)unBingScrollViewInView:(UIView *)view;

- (__kindof GGBlankBaseConfig *)initializeConfig;
- (void)initializeUI;
- (void)updateFrames:(__kindof GGBlankBaseConfig *)baseConfig;
- (void)reloadData:(__kindof GGBlankBaseConfig *)baseConfig;

@end


@interface GGBlankBaseConfig : NSObject

@property (nonatomic, assign)  UIEdgeInsets contentInset;
@property (nonatomic, strong) UIColor *contentBackgroundColor;
@property (nonatomic, strong) UIView *customView;

@end

NS_ASSUME_NONNULL_END
