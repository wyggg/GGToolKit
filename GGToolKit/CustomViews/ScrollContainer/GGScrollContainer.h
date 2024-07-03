//
//  GGScrollContainer.h
//  Operator
//
//  Created by yg on 2024/7/2.
//  Copyright © 2024 北京泰利玛营销顾问有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GGScrollContainerDirection) {
    GGScrollContainerDirectionVertical = 0, //只支持垂直方向滚动
    GGScrollContainerDirectionHorizontal = 1,//只支持水平方向滚动
    GGScrollContainerDirectionAny = 9,//支持任意方向滚动
};

@interface GGScrollContainer : UIView

@property (nonatomic, assign) GGScrollContainerDirection direction;
@property (nonatomic, strong ,readonly) UIView *contentView;
@property (nonatomic, strong ,readonly) UIScrollView *scrollView;

- (void)addComponentSubview:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
