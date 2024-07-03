//
//  UIButton+GG.h
//  unzip
//
//  Created by yg on 2021/11/21.
//

#import <UIKit/UIKit.h>

@interface UIButton (GG)

- (void)gg_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;//设背景颜色图片
- (void)gg_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;//扩大点击范围

@end

#pragma mark - 设置按钮文字和图片的间距
typedef NS_ENUM(NSInteger, UIButtonImagePosition) {
	UIButtonImagePositionTop = 0, // 图片在上，标题在下
	UIButtonImagePositionLeft = 1, // 图片在左，标题在右
	UIButtonImagePositionBottom = 2, // 图片在下，标题在上
	UIButtonImagePositionRight = 3 // 图片在右，标题在左
};
@interface UIButton (GGPosition)

- (void)gg_setPosition:(UIButtonImagePosition)position spacing:(CGFloat)spacing;

@end
