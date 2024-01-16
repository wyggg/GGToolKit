//
//  UIColor+GG.m
//  GGExtensionDemo
//
//  Created by yg on 2022/8/2.
//

#import "UIColor+GG.h"

@implementation UIColor (GG)

//随机色
+ (UIColor *)gg_randomColor{
	CGFloat hue = (arc4random()%256/256.0);
	CGFloat saturation = (arc4random()%128/256.0)+0.5;
	CGFloat brightness = (arc4random()%128/256.0)+0.5;
	return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

//图片转颜色
+ (UIColor *)gg_colorWithImage:(UIImage *)image precision:(CGFloat)precision{

	CGSize size = CGSizeMake(precision, precision);
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
	int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
	int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL,size.width,size.height,8,size.width*4,colorSpace,bitmapInfo);

	CGRect drawRect = CGRectMake(0, 0, size.width, size.height);
	CGContextDrawImage(context, drawRect, image.CGImage);
	CGColorSpaceRelease(colorSpace);

		//取每个点的像素值
	unsigned char* data = CGBitmapContextGetData (context);


	if (data == NULL){
		CGContextRelease(context);
		return nil;
	}

	NSCountedSet *cls=[NSCountedSet setWithCapacity:size.width*size.height];

	for (int x=0; x<size.width; x++) {
		for (int y=0; y<size.height; y++) {

			int offset = 4*(x*y);

			int red = data[offset];
			int green = data[offset+1];
			int blue = data[offset+2];
			int alpha =  data[offset+3];

			NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
			[cls addObject:clr];

		}
	}
	CGContextRelease(context);
		//找到出现次数最多的那个颜色
	NSEnumerator *enumerator = [cls objectEnumerator];
	NSArray *curColor = nil;

	NSArray *MaxColor=nil;
	NSUInteger MaxCount=0;

	while ( (curColor = [enumerator nextObject]) != nil )
	{
		NSUInteger tmpCount = [cls countForObject:curColor];

		if ( tmpCount < MaxCount ) continue;

		MaxCount=tmpCount;
		MaxColor=curColor;

	}

	return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f)
						   green:([MaxColor[1] intValue]/255.0f)
							blue:([MaxColor[2] intValue]/255.0f)
						   alpha:([MaxColor[3] intValue]/255.0f)];
}

//获得颜色RGB的值
- (NSDictionary *)gg_colorToRGBValues{

	CGFloat components[3];

	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	unsigned char resultingPixel[4];
	CGContextRef context = CGBitmapContextCreate(&resultingPixel,1,1,8,4,rgbColorSpace,(CGBitmapInfo)kCGImageAlphaNoneSkipLast);
	CGContextSetFillColorWithColor(context, [self CGColor]);
	CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
	CGContextRelease(context);
	CGColorSpaceRelease(rgbColorSpace);
	for (int component = 0; component < 3; component++) {
		components[component] = resultingPixel[component];
	}
	return @{@"R":@(components[0]),
			 @"G":@(components[1]),
			 @"B":@(components[2])};
}

+ (UIColor *)gg_colorWithHax:(NSString *)hax{
	NSString *colorString = [[hax stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	if ([colorString length] < 6) {
		return [UIColor clearColor];
	}

	if ([colorString hasPrefix:@"0X"] || [colorString hasPrefix:@"0x"])
		colorString = [colorString substringFromIndex:2];

	if ([colorString hasPrefix:@"#"])
		colorString = [colorString substringFromIndex:1];

	if ([colorString length] < 6)
		return [UIColor clearColor];

	if (colorString.length == 6) {
		return [self gg_colorWithHax:hax alpha:1];
	} else if (colorString.length == 8){
		NSRange range;
		range.location = 0;
		range.length = 2;
		NSString *aString = [colorString substringWithRange:range];

		range.location = 2;
		NSString *rString = [colorString substringWithRange:range];

		range.location = 4;
		NSString *gString = [colorString substringWithRange:range];

		range.location = 6;
		NSString *bString = [colorString substringWithRange:range];

		unsigned int a, r, g, b;
		[[NSScanner scannerWithString:aString] scanHexInt:&a];
		[[NSScanner scannerWithString:rString] scanHexInt:&r];
		[[NSScanner scannerWithString:gString] scanHexInt:&g];
		[[NSScanner scannerWithString:bString] scanHexInt:&b];

		return [UIColor colorWithRed:((float) r / 255.0f)
							   green:((float) g / 255.0f)
								blue:((float) b / 255.0f)
							   alpha:((float) a / 255.0f)];
	} else {
		return [UIColor clearColor];
	}
}

+ (UIColor *)gg_colorWithHax:(NSString *)hax alpha:(CGFloat)alpha{

	NSString *colorString = [[hax stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

	if ([colorString length] < 6) {
		return [UIColor clearColor];
	}

	if ([colorString hasPrefix:@"0X"] || [colorString hasPrefix:@"0x"])
		colorString = [colorString substringFromIndex:2];

	if ([colorString hasPrefix:@"#"])
		colorString = [colorString substringFromIndex:1];

	if ([colorString length] < 6)
		return [UIColor clearColor];

	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [colorString substringWithRange:range];
	range.location = 2;
	NSString *gString = [colorString substringWithRange:range];
	range.location = 4;
	NSString *bString = [colorString substringWithRange:range];

	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (UIColor *)gg_colorWithRGB:(CGFloat)R G:(CGFloat)G B:(CGFloat)B A:(CGFloat)A{
	UIColor * color = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A];
	return color;
}

- (UIImage *)gg_colorToImage{
	return [self gg_colorToImageWithWidth:1 height:1];
}

- (UIImage *)gg_colorToImageWithWidth:(CGFloat)width height:(CGFloat)height{
	UIImage *colorImage = nil;
	CGRect rect = CGRectMake(0, 0, width, height);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, self.CGColor);
	CGContextFillRect(context, rect);
	colorImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return colorImage;
}

- (NSString *)gg_colorToHaxString{
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	CGColorGetComponents(self.CGColor);
	CGFloat r = components[0];
	CGFloat g = components[1];
	CGFloat b = components[2];
	return [NSString stringWithFormat:@"#%02lX%02lX%02lX",lroundf(r * 255),lroundf(g * 255),lroundf(b * 255)];
}

@end
