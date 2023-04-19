//
//  CALayer+GG.h
//  GGToolKit_Example
//
//  Created by yg on 2023/4/19.
//  Copyright © 2023 yyyggg. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, GGLayerGradientDirection) {
	GGLayerGradientDirectionTopToBottom,
	GGLayerGradientDirectionLeftToRight,
	GGLayerGradientDirectionTopLeftToBottomRight,
	GGLayerGradientDirectionBottomLeftToTopRight
};


@interface CALayer (GG)

//虚线/直线边框Layer
+ (CAShapeLayer *)gg_borderLayerWithFrame:(CGRect)frame
								lineWidth:(CGFloat)lineWidth
							  strokeColor:(UIColor *)strokeColor
								fillColor:(UIColor *)fillColor
							 cornerRadius:(CGFloat)cornerRadius
						  lineDashPattern:(NSArray *)lineDashPattern;

//虚线/直线Layer
+ (CAShapeLayer *)gg_lineLayerWithFrame:(CGRect)frame
							  lineColor:(UIColor *)lineColor
							isHorizonal:(BOOL)isHorizonal
						lineDashPattern:(NSArray *)lineDashPattern;

//渐变色Layer
+ (CAGradientLayer *)gg_gradientLayerWithFrame:(CGRect)frame
									 direction:(GGLayerGradientDirection)direction
										colors:(NSArray *)colors
									 locations:(NSArray *)locations;


@end
