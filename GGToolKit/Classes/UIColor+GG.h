//
//  UIColor+GG.h
//  GGExtensionDemo
//
//  Created by yg on 2022/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (GG)

+ (UIColor *)gg_randomColor;//随机色

+ (UIColor *)gg_colorWithHax:(NSString *)hax;
+ (UIColor *)gg_colorWithHax:(NSString *)hax alpha:(CGFloat)alpha;
+ (UIColor *)gg_colorWithRGB:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;
+ (UIColor *)gg_colorWithImage:(UIImage *)image precision:(CGFloat)precision;//图片转到颜色 precision：0-1

- (UIImage *)gg_colorToImage;//颜色转到图像
- (UIImage *)gg_colorToImageWithWidth:(CGFloat)width height:(CGFloat)height;//颜色转图片
- (NSDictionary *)gg_colorToRGBValues;//获得颜色RGB的值
- (NSString *)gg_colorToHaxString;//获得颜色16进制字符串


@end

NS_ASSUME_NONNULL_END
