//
//  NSAttributedString+GG.h
//  GGExtensionDemo
//
//  Created by yg on 2022/8/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (GG)

//计算富文本高度
- (CGFloat)gg_heightWithContainWidth:(CGFloat)width;

//异步解析html字符串
+ (void)gg_attributedStringWithHtmlString:(NSString *)string block:(void(^)(NSAttributedString *attString))block;

//同步解析html字符串
+ (NSAttributedString *)gg_attributedStringWithHtmlString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
