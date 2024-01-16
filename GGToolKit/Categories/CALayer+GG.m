//
//  CALayer+GG.m
//  GGToolKit_Example
//
//  Created by yg on 2023/4/19.
//  Copyright © 2023 yyyggg. All rights reserved.
//

#import "CALayer+GG.h"

@implementation CALayer (GG)

+ (CAShapeLayer *)gg_borderLayerWithFrame:(CGRect)frame
								lineWidth:(CGFloat)lineWidth
							  strokeColor:(UIColor *)strokeColor
								fillColor:(UIColor *)fillColor
							 cornerRadius:(CGFloat)cornerRadius
						  lineDashPattern:(NSArray *)lineDashPattern{

	if (lineDashPattern == nil){
		lineDashPattern = @[@1];
	}

	CAShapeLayer *layer = [[CAShapeLayer alloc]init];
	layer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
	layer.path = [UIBezierPath bezierPathWithRoundedRect:layer.bounds cornerRadius:cornerRadius].CGPath;
	layer.lineWidth = lineWidth;
	layer.position = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
	layer.lineDashPattern = lineDashPattern;
	layer.lineDashPhase = 0.1;
	layer.fillColor = fillColor.CGColor;
	layer.strokeColor = strokeColor.CGColor;
	layer.frame = frame;
	return layer;
}

+ (CAShapeLayer *)gg_lineLayerWithFrame:(CGRect)frame
							  lineColor:(UIColor *)lineColor
							isHorizonal:(BOOL)isHorizonal
						lineDashPattern:(NSArray *)lineDashPattern {

	if (lineDashPattern == nil){
		lineDashPattern = @[@1,@0];
	}

	CAShapeLayer *layer = [CAShapeLayer layer];
	layer.frame = frame;

	if (isHorizonal) {
		[layer setPosition:CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame))];
	} else {
		[layer setPosition:CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2)];
	}

	layer.fillColor = UIColor.clearColor.CGColor;

	layer.strokeColor = lineColor.CGColor;

	if (isHorizonal) {
		layer.lineWidth = frame.size.height;
	} else {
		layer.lineWidth = frame.size.width;
	}

	layer.lineJoin = kCALineJoinRound;
	layer.lineDashPattern = lineDashPattern;
	// 设置路径
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, 0, 0);

	if (isHorizonal) {
		CGPathAddLineToPoint(path, NULL,CGRectGetWidth(frame), 0);
	} else {
		CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(frame));
	}
	layer.path = path;

	CGPathRelease(path);
	layer.frame = frame;
	return layer;
}


+ (CAGradientLayer *)gg_gradientLayerWithFrame:(CGRect)frame
									 direction:(GGLayerGradientDirection)direction
										colors:(NSArray *)colors
									 locations:(NSArray *)locations{

	CAGradientLayer *layer = [CAGradientLayer layer];
	layer.frame = frame;
	CGSize size = frame.size;
	CGPoint startPoint, endPoint;
	switch (direction) {
		case GGLayerGradientDirectionTopToBottom:{
			startPoint = CGPointMake(0, 0);
			endPoint = CGPointMake(0, 1);
			break;
		}
		case GGLayerGradientDirectionLeftToRight:{
			startPoint = CGPointMake(0, 0);
			endPoint = CGPointMake(1, 0);
			break;
		}
		case GGLayerGradientDirectionTopLeftToBottomRight:{
			startPoint = CGPointMake(0, 0);
			endPoint = CGPointMake(1, 1);
			break;
		}
		case GGLayerGradientDirectionBottomLeftToTopRight:{
			startPoint = CGPointMake(0, 1);
			endPoint = CGPointMake(1, 0);
			break;
		}
		default:{
			startPoint = CGPointMake(size.width / 2.0, 0.0);
			endPoint = CGPointMake(size.width / 2.0, size.height);
			break;
		}
	}

	layer.startPoint = startPoint;
	layer.endPoint = endPoint;
	NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
	for (UIColor *color in colors) {
		[cgColors addObject:(id)color.CGColor];
	}
	layer.colors = cgColors;
	layer.locations = locations;
	return layer;
}



@end
