//
//  GGTools.h
//  Pods
//
//  Created by yg on 2023/4/12.
//

#import "GGScale.h"

@implementation GGScale

+ (UIWindow *)mainWindow{
    return [[UIApplication sharedApplication].delegate window];
}

+ (CGFloat)safeAreaTop{
	if (@available(iOS 11.0, *)) {
		return [[UIApplication sharedApplication].delegate window].safeAreaInsets.top;
	}else{
		return 22;
	}
}

+ (CGFloat)safeAreaBottom{
	if (@available(iOS 11.0, *)) {
		return [[UIApplication sharedApplication].delegate window].safeAreaInsets.bottom;
	}else{
		return 0;
	}
}

+ (CGFloat)safeStatusBarBottom{
    UIStatusBarManager *statusBarManager = self.mainWindow.windowScene.statusBarManager;
    CGFloat statusBarHeight = statusBarManager.statusBarFrame.size.height;
	return statusBarHeight;
}

+ (CGFloat)safeNavigationBottom{
	return self.safeStatusBarBottom + 44;
}

+ (CGFloat)tabbarHeight{
	return 49 + [[self class] safeAreaBottom];
}

static float _zoomProportion;
+ (float)zoomProportion{
	_zoomProportion = 375.f / self.mainWindow.frame.size.width;
	return _zoomProportion;
}

+ (CGFloat)scale:(CGFloat)scale{
    return (scale * MIN(self.mainWindow.frame.size.width, self.mainWindow.frame.size.width/375.0f));
}

@end
