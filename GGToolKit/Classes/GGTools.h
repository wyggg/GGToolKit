//
//  GGTools.h
//  Pods
//
//  Created by yg on 2023/4/12.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UINavigationController+GG.h"
#import "UIImage+GG.h"
#import "NSString+GG.h"
#import "NSObject+GG.h"
#import "UIView+GG.h"
#import "UIWindow+GG.h"
#import "UIControl+GG.h"
#import "UITextField+GG.h"
#import "UIButton+GG.h"
#import "UIColor+GG.h"
#import "UIImage+GG.h"
#import "UIView+GGScrollComponent.h"
#import "NSArray+GGMasonryLayout.h"
#import "UIWindow+GG.h"

#define GGSafeAreaBottom (GGTools.safeAreaBottom)
#define GGSafeAreaTop (GGTools.safeAreaTop)
#define GGSafeStatusBarBottom (GGTools.safeStatusBarBottom)
#define GGSafeNavigationBottom (GGTools.safeNavigationBottom)
#define GGZoomProportion (GGTools.zoomProportion)
#define GGMainWindow (GGTools.mainWindow)
#define GGScreenHeight [[UIScreen mainScreen] bounds].size.height
#define GGScreenWidth [[UIScreen mainScreen] bounds].size.width
#define GGWindowHeight [GGMainWindow bounds].size.height
#define GGWindowWidth [GGMainWindow bounds].size.width

#define GGWeakSelf __weak typeof(self) weakSelf = self;
#define GGStrongSelf __weak typeof(weakSelf) strongSelf = weakSelf;
#define GGColorHax(hax) ([UIColor gg_colorWithHax:hax])
#define GGColorHaxA(hax,a) ([UIColor gg_colorWithHax:hax alpha:a])
#define GGColorRGB(r,g,b) ([UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1])
#define GGColorRGBA(r,g,b,a) ([UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a])



@interface GGTools : NSObject

//系统提示床单
+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle items:(NSArray *)items style:(UIAlertControllerStyle)style atController:(UIViewController *)controller action:(void(^)(NSUInteger itemIndex))itemAction;

//带输入框的系统提示框
+ (void)showTextFieldActionWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder textFieldText:(NSString *)textFieldText items:(NSArray *)items atController:(UIViewController *)controller action:(void(^)(NSUInteger itemIndex,UITextField *textField))itemAction;

//快速弹出一句话
+ (void)showToast:(NSString *)toast;

//代理是否开启的判断 一般抓包时会开启代理
+ (BOOL)getProxyStatus;

@property (class,readonly) UIWindow *mainWindow;
@property (class,readonly) CGFloat safeAreaBottom;//返回安全距离的底边
@property (class,readonly) CGFloat safeAreaTop;//返回安全距离的顶边
@property (class,readonly) CGFloat safeStatusBarBottom;//返回状态栏底边
@property (class,readonly) CGFloat safeNavigationBottom; //返回导航栏底边
@property (class,readonly) CGFloat tabbarHeight; //tabbarHeight;
@property (class,readonly) float zoomProportion;//返回在标准375宽度的缩放比例

@end
