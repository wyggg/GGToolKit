

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
- (UIImage *)gg_snapshotImageWithIsScrollView:(BOOL)isScrollView;
- (void)gg_layerBorderWidth:(CGFloat )width
				 color:(UIColor *)color;
- (void)gg_layerShadowColor:(UIColor *)color
                    offset:(CGSize)offset
                   opacity:(CGFloat)opacity
                    radius:(CGFloat)radius;
- (void)gg_layerCornerRadius:(CGFloat)radius
               masksToBounds:(BOOL)masksToBounds;
- (void)gg_layerCornerRadius:(CGFloat)cornerRadius
           byRoundingCorners:(UIRectCorner)byRoundingCorners;


@end

#pragma mark - 手势

typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);
@interface UIView (GGGestures)

//添加轻触点击事件
- (void)gg_addTapActionWithBlock:(GestureActionBlock)block;

//添加长按点击事件
- (void)gg_addLongPressActionWithBlock:(GestureActionBlock)block;

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


#pragma mark - 按下效果

@interface UIView (GGTouch)

- (void)gg_setHighlightBackgroundColor:(UIColor *)color showAnimationDuration:(CGFloat)showAnimationDuration dismissAnimationDuration:(CGFloat)dismissAnimationDuration;

- (void)gg_setHighlightZoomingScale:(CGFloat)scale showAnimationDuration:(CGFloat)showAnimationDuration dismissAnimationDuration:(CGFloat)dismissAnimationDuration;

@end
