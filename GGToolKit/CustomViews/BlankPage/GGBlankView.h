//
//  GGBlankViewView.h
//  GGToolKit
//
//  Created by yg on 2023/6/15.
//

#import "GGBlankBaseView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GGBlankView : GGBlankBaseView

+ (void)showInView:(UIView *)view
             image:(UIImage *)image
             title:(NSString *)title
          subTitle:(NSString *)subTitle
     contentOffset:(CGFloat)contentOffset
       buttonTitle:(NSString *)buttonTitle
      buttonEvents:(void(^)(void))buttonEvents;

+ (void)bindScrollView:(UIScrollView *)scrollView
                inView:(UIView *)inView
                 image:(UIImage *)image
                 title:(NSString *)title
              subTitle:(NSString *)subTitle
         contentOffset:(CGFloat)contentOffset
           buttonTitle:(NSString *)buttonTitle
          buttonEvents:(void(^)(void))buttonEvents;

@end


typedef NS_ENUM(NSUInteger, GGBlankViewPosition) {
    GGBlankViewPositionTop,
    GGBlankViewPositionCenter,
    GGBlankViewPositionBottom,
};

@interface GGBlankConfig : GGBlankBaseConfig

@property (nonatomic, strong) UIImage *_Nullable image;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, copy) NSString *_Nullable title;
@property (nonatomic, copy) UIFont *_Nullable titleFont;
@property (nonatomic, copy) UIColor *_Nullable titleColor;
@property (nonatomic, copy) void(^titleLabelMoreConfig)(UILabel *titleLabel);
@property (nonatomic, copy) NSString *_Nullable message;
@property (nonatomic, copy) UIFont *_Nullable messageFont;
@property (nonatomic, copy) UIColor *_Nullable messageColor;
@property (nonatomic, copy) void(^messageLabelMoreConfig)(UILabel *messageLabel);
@property (nonatomic, copy) NSString *_Nullable restartButtonTitle;
@property (nonatomic, assign) CGSize restartButtonSize;
@property (nonatomic, strong) UIFont *_Nullable restartButtonFont;
@property (nonatomic, strong) UIColor *_Nullable restartButtonTitleColor;
@property (nonatomic, strong) UIColor *_Nullable restartButtonBackgroundColor;
@property (nonatomic, copy) void(^restartButtonMoreConfig)(UIButton *restartButton);
@property (nonatomic, assign) CGFloat titleSpacing;
@property (nonatomic, assign) CGFloat subTitleSpacing;
@property (nonatomic, assign) CGFloat buttonSpacing;
@property (nonatomic, assign) GGBlankViewPosition position;
@property (nonatomic, assign) CGFloat positionOffset;
@property (nonatomic, copy) void(^restartButtonClick)(void);

@end

NS_ASSUME_NONNULL_END
