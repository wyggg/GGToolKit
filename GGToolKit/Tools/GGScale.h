//
//  GGTools.h
//  Pods
//
//  Created by yg on 2023/4/12.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GGScale : NSObject

@property (class,readonly) UIWindow *mainWindow;
@property (class,readonly) CGFloat safeAreaBottom;//返回安全距离的底边
@property (class,readonly) CGFloat safeAreaTop;//返回安全距离的顶边
@property (class,readonly) CGFloat safeStatusBarBottom;//返回状态栏底边
@property (class,readonly) CGFloat safeNavigationBottom; //返回导航栏底边
@property (class,readonly) CGFloat tabbarHeight; //tabbarHeight;
@property (class,readonly) float zoomProportion;//返回在标准375宽度的缩放比例

+ (CGFloat)scale:(CGFloat)scale;

@end
