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

- (UIImage *)gg_setWidth:(CGFloat)width scale:(CGFloat)scale{
	CGSize size = self.size;
	size.width = width;
	size.height = self.size.height / self.size.width * width;
	return [self gg_setSize:size scale:scale];
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
							  direction:(GGImageGradientDirection)direction
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
		case GGImageGradientDirectionTopToBottom:{
			startPoint = CGPointMake(size.width / 2.0, 0.0);
			endPoint = CGPointMake(size.width / 2.0, size.height);
			break;
		}
		case GGImageGradientDirectionLeftToRight:{
			startPoint = CGPointMake(0.0, size.height / 2.0);
			endPoint = CGPointMake(size.width, size.height / 2.0);
			break;
		}
		case GGImageGradientDirectionTopLeftToBottomRight:{
			startPoint = CGPointMake(0.0, 0.0);
			endPoint = CGPointMake(size.width, size.height);
			break;
		}
		case GGImageGradientDirectionBottomLeftToTopRight:{
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

+ (UIImage *)gg_joinImagesVertically:(NSArray<UIImage *> *)images withSpacing:(CGFloat)spacing backgroundColor:(UIColor *)backgroundColor {
    CGFloat totalHeight = 0;
    CGFloat maxWidth = 0;
    
    // 计算总高度和最大宽度
    for (UIImage *image in images) {
        totalHeight += image.size.height;
        maxWidth = MAX(maxWidth, image.size.width);
    }
    
    totalHeight += (images.count - 1) * spacing;
    
    // 创建一个画布，大小为拼接后的图片大小
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(maxWidth, totalHeight), NO, 0.0);
    
    // 设置背景色
    [backgroundColor setFill];
    UIRectFill(CGRectMake(0, 0, maxWidth, totalHeight));
    
    CGFloat currentY = 0;
    
    // 将每张图片绘制到画布上
    for (UIImage *image in images) {
        [image drawInRect:CGRectMake(0, currentY, maxWidth, image.size.height)];
        currentY += image.size.height + spacing;
    }
    
    // 获取拼接后的图片
    UIImage *joinedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束画布绘制
    UIGraphicsEndImageContext();
    
    return joinedImage;
}

- (BOOL)gg_saveToPath:(NSString *)path{
	BOOL result = [UIImagePNGRepresentation(self) writeToFile:path  atomically:YES];
	return result;
}

@end
