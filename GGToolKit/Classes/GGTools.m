//
//  GGTools.h
//  Pods
//
//  Created by yg on 2023/4/12.
//

#import "GGTools.h"

@implementation GGTools

//actionSheet
+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle items:(NSArray *)items style:(UIAlertControllerStyle)style atController:(UIViewController *)controller action:(void(^)(NSUInteger itemIndex))itemAction
{
	UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
	if (cancelTitle) {
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
		[actionSheetController addAction:cancelAction];
	}
	if (destructiveTitle) {
		UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:nil];
		[actionSheetController addAction:destructiveAction];
	}

	[items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		UIAlertAction *sheetAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			itemAction(idx);
		}];
		[actionSheetController addAction:sheetAction];
	}];
	[controller presentViewController:actionSheetController animated:YES completion:nil];
}

//actionSheet
+ (void)showTextFieldActionWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder textFieldText:(NSString *)textFieldText items:(NSArray *)items atController:(UIViewController *)controller action:(void(^)(NSUInteger itemIndex,UITextField *textField))itemAction
{
	UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
	[actionSheetController addAction:cancelAction];

	[actionSheetController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		textField.placeholder = placeholder;
		textField.returnKeyType = UIReturnKeyDone;
		textField.text = textFieldText;
	}];

	__weak UIAlertController *weakActionSheetController = actionSheetController;
	[items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		UIAlertAction *sheetAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			itemAction(idx,weakActionSheetController.textFields.firstObject);
		}];
		[actionSheetController addAction:sheetAction];
	}];
	[controller presentViewController:actionSheetController animated:YES completion:nil];
}

NSMutableArray *toastPool;
NSTimer *toastTimer;
+ (void)showToast:(NSString *)toast{
	if (toast.length == 0) {
		return;
	}
	if (toastPool == nil){
		toastPool = [NSMutableArray array];
	}

	dispatch_async(dispatch_get_main_queue(), ^{
		UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];

		UIView *shadowView = [[UIView alloc] init];
		shadowView.backgroundColor = [UIColor blackColor];
		shadowView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
		shadowView.layer.shadowOffset = CGSizeMake(0, 0);
		shadowView.layer.shadowOpacity = 1;
		shadowView.layer.shadowRadius = 10;
		shadowView.layer.cornerRadius = 7.5;
		[mainWindow addSubview:shadowView];

		UILabel *label = [[UILabel alloc] init];
		label.text = toast;
		label.font = [UIFont boldSystemFontOfSize:20];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = NSTextAlignmentCenter;
		[shadowView addSubview:label];

		CGSize size = [label sizeThatFits:CGSizeMake(0, 0)];
		shadowView.frame = CGRectMake(0, 0, size.width + 30, size.height + 20);
		shadowView.gg_centerX = mainWindow.frame.size.width / 2;
		shadowView.gg_bottom = mainWindow.frame.size.height - GGSafeAreaBottom - 50;
		UIView *lastView = [toastPool lastObject];
		if (lastView){
			shadowView.gg_bottom = lastView.gg_top - 10;
		}
		label.frame = shadowView.bounds;

		[toastPool addObject:shadowView];

		__weak UIView *weakView = shadowView;
		shadowView.alpha = 0;
		shadowView.transform = CGAffineTransformMakeScale(0.8, 0.8);
		[UIView animateWithDuration:0.4 animations:^{
			weakView.alpha = 1;
			weakView.transform = CGAffineTransformMakeScale(0.9, 0.9);
		} completion:^(BOOL finished) {

		}];

		[toastTimer invalidate];
		toastTimer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
			for (UIView *temp in toastPool) {
				[temp removeFromSuperview];
			}
			[toastPool removeAllObjects];
			[timer invalidate];
		}];
	});

}

+ (BOOL)getProxyStatus {
	NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
	NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
	NSDictionary *settings = [proxies objectAtIndex:0];

	NSLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
	NSLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
	NSLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);

	if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
		//没有设置代理
		return NO;
	}else{
		//设置代理了
		return YES;
	}
}

+ (UIWindow *)mainWindow{
	return [UIApplication sharedApplication].delegate.window;
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
	return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+ (CGFloat)safeNavigationBottom{
	return self.safeStatusBarBottom + 44;
}

+(CGFloat)tabbarHeight{
	return 49 + [[self class] safeAreaBottom];
}

static float _zoomProportion;
+ (float)zoomProportion{
	_zoomProportion = 375.f / self.mainWindow.frame.size.width;
	return _zoomProportion;
}


@end
