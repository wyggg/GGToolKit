//
//  UINavigationController+GG.m
//  unzip
//
//  Created by yg on 2021/11/16.
//

#import "UINavigationController+GG.h"

@implementation UINavigationController (GG)

- (BOOL)gg_popToAppiontViewController:(Class)vcClass{
	
	if (![self gg_containViewControlerToClass:vcClass]) {
		return NO;
	}
	
	for (UIViewController *vc in self.viewControllers) {
		if ([vc isKindOfClass:vcClass]) {
			[self popToViewController:vc animated:YES];
			return YES;
		}
	}
	return NO;
}

/**
 返回到某个不存在的页面
 
 @param viewController 跳转页面class
 @param aClass 前一个页面class
 */
- (void)gg_popToNoExistViewController:(UIViewController *)viewController behindOfViewController:(Class)aClass{
	
	NSMutableArray *pageArray = [self.viewControllers mutableCopy];
	for (int i = 0; i < pageArray.count; i++)
	{
		id vc = pageArray[i];
			//找到要插入页面的前一个界面
		if ([vc isKindOfClass:aClass])
		{
				//插入界面栈
			[pageArray insertObject:viewController atIndex:i + 1];
			[self setViewControllers:pageArray animated:NO];
			[self popToViewController:viewController animated:YES];
			return;
		}
	}
}

- (BOOL)gg_containViewControlerToClass:(Class)aClass{
	
	for (UIViewController *vc in self.viewControllers) {
		if ([vc isKindOfClass:aClass]) {
			return YES;
		}
	}
	NSLog(@"当前NavgationController中不存在 ----> %@ !!!",NSStringFromClass(aClass));
	return NO;
}

@end
