//
//  UIImage+GG.m
//  unzip
//
//  Created by yg on 2021/11/16.
//

#import "UIImage+GG.h"
#import "UIColor+GG.h"

@implementation UIImage (GG)

- (UIImage *)gg_setSize:(CGSize)size scale:(CGFloat)scale{
	return [self gg_setSize:size scale:scale orientation:UIImageOrientationUp];
}

- (UIImage *)gg_setSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation{
	if (scale < 1) {
		scale = 1;
	}
	UIGraphicsBeginImageContext(size);
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	newImage = [UIImage imageWithCGImage:newImage.CGImage scale:scale orientation:orientation];
	return newImage;
}

- (UIImage *)gg_setTintColor:(UIColor *)tintColor{
	UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
	CGContextRef context = UIGraphicsGetCurrentContext() ;
	CGContextTranslateCTM(context, 0, self.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextSetBlendMode(context, kCGBlendModeNormal);
	CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
	CGContextClipToMask(context, rect, self.CGImage);
	[tintColor setFill];
	CGContextFillRect(context, rect);
	UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

//图像转到颜色
- (UIColor *)gg_imageToColor{
	return [UIColor gg_colorWithImage:self precision:1];
}

+ (UIImage *)gg_gradientImageWithColors:(NSArray<UIColor *> *)colors
							  direction:(GGGradientDirection)direction
							  imageSize:(CGSize)imageSize
							   location:(NSArray <NSNumber *>*)location {

	CGSize size = imageSize;
	CGFloat locations[location.count];
	for (int i=0; i<location.count; i++) {
		CGFloat value = [location[i] doubleValue];
		locations[i] = value;
	}

	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();

	NSMutableArray *cgColors = [NSMutableArray array];
	for (UIColor *color in colors) {
		[cgColors addObject:(id)color.CGColor];
	}
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)cgColors, locations);

	CGPoint startPoint, endPoint;
	switch (direction) {
		case GGGradientDirectionVertical:{
			startPoint = CGPointMake(size.width / 2.0, 0.0);
			endPoint = CGPointMake(size.width / 2.0, size.height);
			break;
		}
		case GGGradientDirectionHorizontal:{
			startPoint = CGPointMake(0.0, size.height / 2.0);
			endPoint = CGPointMake(size.width, size.height / 2.0);
			break;
		}
		case GGGradientDirectionTopLeftToBottomRight:{
			startPoint = CGPointMake(0.0, 0.0);
			endPoint = CGPointMake(size.width, size.height);
			break;
		}
		case GGGradientDirectionBottomLeftToTopRight:{
			startPoint = CGPointMake(0.0, size.height);
			endPoint = CGPointMake(size.width, 0.0);
			break;
		}
		default:{
			startPoint = CGPointMake(size.width / 2.0, 0.0);
			endPoint = CGPointMake(size.width / 2.0, size.height);
			break;
		}
	}

	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
	UIGraphicsEndImageContext();

	return image;
}

- (BOOL)gg_saveToPath:(NSString *)path{
	BOOL result = [UIImagePNGRepresentation(self) writeToFile:path  atomically:YES];
	return result;
}

@end
