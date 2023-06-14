//
//  GGBlankPageEmpty.h
//  GGToolKit_Example
//
//  Created by yg on 2023/6/14.
//  Copyright © 2023 yyyggg. All rights reserved.
//

#import "GGBlankPageLoading.h"


typedef NS_ENUM(NSUInteger, GGBlankPageEmptyPosition) {
    GGBlankPageEmptyPositionCenter,
    GGBlankPageEmptyPositionTop,
    GGBlankPageEmptyPositionBottom,
};

@interface GGBlankPageEmpty : GGBlankPageComponent

@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGSize buttonSize;
@property (nonatomic, assign) CGFloat titleSpacing;
@property (nonatomic, assign) CGFloat subTitleSpacing;
@property (nonatomic, assign) CGFloat buttonSpacing;

@property (nonatomic, assign) GGBlankPageEmptyPosition position;
@property (nonatomic, assign) CGFloat positionOffset;
@property (nonatomic, copy) void(^restartButtonClick)(void);

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *button;

+ (GGBlankPageEmpty *)emptyWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle buttonTitle:(NSString *)buttonTitle click:(void(^)(void))click;

@end

