//
//  GGBlankPageLoading.h
//  GGToolKit_Example
//
//  Created by yg on 2023/6/14.
//  Copyright © 2023 yyyggg. All rights reserved.
//

#import "GGBlankPageComponent.h"

typedef NS_ENUM(NSUInteger, GGBlankPageLoadingPosition) {
    GGBlankPageLoadingPositionCenter,
    GGBlankPageLoadingPositionTopCenter,
    GGBlankPageLoadingPositionBottomCenter,
};

@interface GGBlankPageLoading : GGBlankPageComponent


@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, assign) GGBlankPageLoadingPosition position;
@property (nonatomic, assign) CGFloat messageSpacing;
@property (nonatomic, assign) CGFloat positionOffset;



+ (GGBlankPageLoading *)loading;
+ (GGBlankPageLoading *)loadingWithMessage:(NSString *)message;
+ (GGBlankPageLoading *)loadingWithWithMessage:(NSString *)message position:(GGBlankPageLoadingPosition)position;
+ (GGBlankPageLoading *)loadingWithWithMessage:(NSString *)message position:(GGBlankPageLoadingPosition)position offset:(CGFloat)offset;


@end

