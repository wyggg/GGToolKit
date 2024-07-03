//
//  UIImage+GG.h
//  unzip
//
//  Created by yg on 2021/11/16.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GGImageGradientDirection) {
	GGImageGradientDirectionTopToBottom,
	GGImageGradientDirectionLeftToRight,
	GGImageGradientDirectionTopLeftToBottomRight,
	GGImageGradientDirectionBottomLeftToTopRight
};


@interface UIImage (GG)

//设置图片的大小
- (UIImage *)gg_setSize:(CGSize)size scale:(CGFloat)scale;
- (UIImage *)gg_setWidth:(CGFloat)width scale:(CGFloat)scale;
- (UIImage *)gg_setSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;
- (UIColor *)gg_imageToColor;
- (UIImage *)gg_setTintColor:(UIColor *)tintColor;

//创建渐变色Image
+ (UIImage *)gg_gradientImageWithColors:(NSArray<UIColor *> *)colors 
                              direction:(GGImageGradientDirection)direction
                              imageSize:(CGSize)imageSize
                               location:(NSArray <NSNumber *>*)location;

+ (UIImage *)gg_joinImagesVertically:(NSArray<UIImage *> *)images withSpacing:(CGFloat)spacing backgroundColor:(UIColor *)backgroundColor;



@end

