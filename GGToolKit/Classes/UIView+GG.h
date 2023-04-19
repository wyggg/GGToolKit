	//
	//  UIView+GG.h
	//  unzip
	//
	//  Created by yg on 2021/11/15.
	//

#import <UIKit/UIKit.h>


@class GGLineView;

@interface UIView (GG)

@property (nonatomic, readonly) CGRect gg_absoluteFrame;
@property (nonatomic) CGFloat gg_left;    //x
@property (nonatomic) CGFloat gg_top;     //y
@property (nonatomic) CGFloat gg_width;   //w
@property (nonatomic) CGFloat gg_height;  //h
@property (nonatomic) CGFloat gg_right;   //x+w
@property (nonatomic) CGFloat gg_bottom;  //y+h
@property (nonatomic) CGFloat gg_centerX; //x+w/2
@property (nonatomic) CGFloat gg_centerY; //y+h/2
@property (nonatomic) CGPoint gg_origin;  //(x,y)
@property (nonatomic) CGSize  gg_size;    //(w,h)

- (void)gg_removeAllSubviews;

- (UIViewController *)gg_viewController;

- (UIImage *)gg_imageWithIsScroll:(BOOL)isScroll;

//设置View.layer本身的边框
- (void)gg_layerBorderWidth:(CGFloat )width
				 color:(UIColor *)color;

//设置View.layer本身的阴影
-(void)gg_layerShadowColor: (UIColor *)color offset:(CGSize)offset opacity: (CGFloat)opacity radius: (CGFloat)radius;

//设置View.layer本身的圆角
- (void)gg_layerCornerRadius:(CGFloat)radius masksToBounds:(BOOL)masksToBounds;


@end

#pragma mark - 手势

typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);
@interface UIView (GGGestures)

//添加轻触点击事件
- (void)gg_addTapActionWithBlock:(GestureActionBlock)block;

//添加长按点击事件
- (void)gg_addLongPressActionWithBlock:(GestureActionBlock)block;

@end



#pragma mark - 渐变背景

typedef NS_ENUM(NSInteger, GradientDirection) {
	GradientDirectionTopToBottom,   // 从上到下
	GradientDirectionLeftToRight,   // 从左到右
	GradientDirectionBottomToTop,   // 从下到上
	GradientDirectionRightToLeft    // 从右到左
};

@interface UIView (GGGradientBackground)

@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;

//向一个视图添加一个渐变背景，设置之前要确定View的frame
- (void)gg_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors direction:(GradientDirection)direction viewSize:(CGSize)viewSize;
- (void)gg_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors direction:(GradientDirection)direction;

//立即同步渐变背景的位置
- (void)gg_updateGradientLayerLayout;

@end


@interface GGLineView : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, copy)   NSArray *dashArray;

@end

#pragma mark - 分隔符

typedef NS_ENUM(NSInteger, GGLineViewDirection) {
	GGLineViewDirectionLeft = 0,
	GGLineViewDirectionTop = 1,
	GGLineViewDirectionRight = 2,
	GGLineViewDirectionBottom = 3
};
@interface UIView (GGList)

- (GGLineView *)gg_addBottomLineWithColor:(UIColor *)color margin:(CGFloat)margin;

- (GGLineView *)gg_addSubLineViewByBorderWidth:(CGFloat)borderWidth
											borderColor:(UIColor *)borderColor
												 offset:(CGFloat)offset
												 margin:(CGFloat)margin
											  dashArray:(NSArray *)dashArray
											  direction:(GGLineViewDirection)direction;
- (void)gg_removeAllSubLineView;//移除掉所有的线
- (void)gg_removeSubLineViewBydirection:(GGLineViewDirection)direction;//移除掉指定类型的线

@end
