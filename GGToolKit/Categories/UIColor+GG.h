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
+ (UIColor *)gg_colorWithRGB:(CGFloat)R G:(CGFloat)G B:(CGFloat)B A:(CGFloat)A;
+ (UIColor *)gg_colorWithImage:(UIImage *)image precision:(CGFloat)precision;//图片转到颜色 precision：0-1
- (UIImage *)gg_colorToImage;
- (UIImage *)gg_colorToImageWithWidth:(CGFloat)width height:(CGFloat)height;
- (NSDictionary *)gg_colorToRGBValues;
- (NSString *)gg_colorToHaxString;


@end

NS_ASSUME_NONNULL_END
