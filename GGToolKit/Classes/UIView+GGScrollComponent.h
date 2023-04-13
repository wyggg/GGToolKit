//
//  UIView+GGScrollComponent.h
//  unzip
//
//  Created by yg on 2021/11/27.
//

#import <UIKit/UIKit.h>

//为一个View添加滚动能力，需要将视图添加到view.gg_contentView
@class GGScrollContentView;

typedef NS_ENUM(NSInteger, GGScrollComponentDirection) {
	GGScrollComponentDirectionVertical = 0, //只支持垂直方向滚动
	GGScrollComponentDirectionHorizontal = 1,//只支持水平方向滚动
	GGScrollComponentDirectionAny = 9,//支持任意方向滚动
};

//把任意一个View视作一个滚动视图 内部自动计算contentSize
@interface UIView (GGScrollComponent)

@property (nonatomic, strong ,readonly) GGScrollContentView *gg_contentView;
@property (nonatomic, strong ,readonly) UIScrollView *gg_scrollView;
@property (nonatomic, assign) GGScrollComponentDirection gg_scrollDirection;

@end


@interface GGScrollContentView : UIView

@property (nonatomic, assign) CGFloat currentBottom;
@property (nonatomic, assign) CGFloat currentRight;
@property (nonatomic, strong) void(^didLayoutSubViewsBlock)(CGFloat right, CGFloat bottom);

@end
