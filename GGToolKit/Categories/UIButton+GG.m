//
//  UIButton+GG.m
//  unzip
//
//  Created by yg on 2021/11/21.
//

#import "UIButton+GG.h"
#import <objc/runtime.h>

@implementation UIButton (GG)


- (void)gg_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
	UIImage *image = [UIButton imageWithColor:backgroundColor];
	[self setBackgroundImage:image forState:state];
}

//color转image方法
+ (UIImage *)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

#pragma mark - 扩大按钮点击范围

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)gg_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
	objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
	objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
	objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
	objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
	NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
	NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
	NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
	NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
	if (topEdge && rightEdge && bottomEdge && leftEdge) {
		return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
						  self.bounds.origin.y - topEdge.floatValue,
						  self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
						  self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
	}
	else
	{
		return self.bounds;
	}
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	CGRect rect = [self enlargedRect];
	if (CGRectEqualToRect(rect, self.bounds)) {
		return [super hitTest:point withEvent:event];
	}
	return CGRectContainsPoint(rect, point) ? self : nil;
}

@end

@implementation UIButton (GGPosition)

- (void)gg_setPosition:(UIButtonImagePosition)position spacing:(CGFloat)spacing{
	CGSize imageSize = self.imageView.image.size;
	CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeZero];
	CGFloat totalHeight = imageSize.height + titleSize.height + spacing;
//	CGFloat totalWidth = imageSize.width + titleSize.width + spacing;

	switch (position) {
		case UIButtonImagePositionTop:
			self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0, 0, - titleSize.width);
			self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
			break;
		case UIButtonImagePositionLeft:
			self.imageEdgeInsets = UIEdgeInsetsMake(0, - spacing / 2, 0, spacing / 2);
			self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, - spacing / 2);
			break;
		case UIButtonImagePositionBottom:
			self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, - (totalHeight - imageSize.height), - titleSize.width);
			self.titleEdgeInsets = UIEdgeInsetsMake(- (totalHeight - titleSize.height), - imageSize.width, 0, 0);
			break;
		case UIButtonImagePositionRight:
			self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + spacing / 2, 0, - (titleSize.width + spacing / 2));
			self.titleEdgeInsets = UIEdgeInsetsMake(0, - (imageSize.width + spacing / 2), 0, imageSize.width + spacing / 2);
			break;
		default:
			break;
	}
}



@end
