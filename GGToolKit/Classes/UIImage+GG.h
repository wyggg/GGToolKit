//
//  UIImage+GG.h
//  unzip
//
//  Created by yg on 2021/11/16.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GGGradientDirection) {
	GGGradientDirectionVertical,   // 纵向
	GGGradientDirectionHorizontal, // 横向
	GGGradientDirectionTopLeftToBottomRight, // 从左上角到右下角
	GGGradientDirectionBottomLeftToTopRight // 从左下角到右上角
};


@interface UIImage (GG)

//设置图片的大小
- (UIImage *)gg_setSize:(CGSize)size scale:(CGFloat)scale;//改变UIImage的Size生成新的图片  scale：规模 @1 @2 @3
- (UIImage *)gg_setSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;
- (UIColor *)gg_imageToColor;//图片转到颜色
- (UIImage *)gg_setTintColor:(UIColor *)tintColor;//改变UIImage的颜色生成新的图片

//创建渐变色Image
+ (UIImage *)gg_gradientImageWithColors:(NSArray<UIColor *> *)colors direction:(GGGradientDirection)direction imageSize:(CGSize)imageSize location:(NSArray <NSNumber *>*)location;


//保存到路径
- (BOOL)gg_saveToPath:(NSString *)path;

@end

