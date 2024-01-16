//
//  UINavigationController+GG.h
//  unzip
//
//  Created by yg on 2021/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (GG)

- (BOOL)gg_popToAppiontViewController:(Class)vcClass;//pop到指定类型控制器
- (void)gg_popToNoExistViewController:(UIViewController *)viewController behindOfViewController:(Class)aClass;
- (BOOL)gg_containViewControlerToClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
