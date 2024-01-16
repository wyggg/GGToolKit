//
//  GGLoadingBaseView.h
//  GGToolKit
//
//  Created by yg on 2023/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GGLoadingBaseConfig;

typedef GGLoadingBaseConfig *_Nonnull(^GGBlankLoadingConfigBlock)(__kindof GGLoadingBaseConfig *baseConfig);

@interface GGLoadingBaseView : UIView

+ (void)show;
+ (void)showInView:(UIView *_Nullable)view;
+ (void)showInView:(UIView *_Nullable)view configBlock:(_Nullable GGBlankLoadingConfigBlock)configBlock;
+ (void)reloadInView:(UIView *_Nullable)view configBlock:(_Nullable GGBlankLoadingConfigBlock)configBlock;

+ (void)dismiss;
+ (void)dismissInView:(UIView *_Nullable)view;

- (__kindof GGLoadingBaseConfig *)initializeConfig;
- (void)initializeViews;
- (void)reloadFrames:(__kindof GGLoadingBaseConfig *)baseConfig;
- (void)reloadData:(__kindof GGLoadingBaseConfig *_Nonnull)baseConfig;

@end

@interface GGLoadingBaseConfig : NSObject

@property (nonatomic, assign) BOOL enabledInteraction;
@property (nonatomic, strong) UIColor *contentBackgroundColor;

@end

NS_ASSUME_NONNULL_END
