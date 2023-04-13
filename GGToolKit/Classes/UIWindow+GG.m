//
//  UIWindow+GG.m
//  unzip
//
//  Created by yg on 2021/11/16.
//

#import "UIWindow+GG.h"

@implementation UIWindow (GG)

- (UIViewController*)gg_topMostController
{
	UIViewController *topController = [self rootViewController];
	
		//  Getting topMost ViewController
	while ([topController presentedViewController])    topController = [topController presentedViewController];
	
		//  Returning topMost ViewController
	return topController;
}

- (UIViewController*)gg_currentViewController
{
	UIViewController *currentViewController = [self gg_topMostController];
	
	while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
		currentViewController = [(UINavigationController*)currentViewController topViewController];
	
	return currentViewController;
}

@end
