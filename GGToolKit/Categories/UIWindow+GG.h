//
//  UIWindow+GG.h
//  unzip
//
//  Created by yg on 2021/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (GG)

//在层次结构中返回当前最热门的视图控制器
- (UIViewController*)gg_topMostController;

//返回topMostController堆栈中的topViewController。
- (UIViewController*)gg_currentViewController;


@end

NS_ASSUME_NONNULL_END
