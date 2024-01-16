//
//  UIControl+GG.m
//  unzip
//
//  Created by yg on 2021/11/15.
//

#import "UIControl+GG.h"
#import <objc/runtime.h>

static const void *UIControlActionBlockDictionary = &UIControlActionBlockDictionary;

@implementation UIControl (GG)

- (void)gg_addActionBlock:(UIControlActionBlock)actionBlock {
	[self gg_addActionBlockForControlEvents:UIControlEventTouchUpInside withBlock:actionBlock];
}

- (void)gg_removeActionBlock{
	[self gg_removeActionBlocksForControlEvents:UIControlEventTouchUpInside];
}

///添加点击Block
- (void)gg_addActionBlockForControlEvents:(UIControlEvents)controlEvents withBlock:(UIControlActionBlock)actionBlock{
	[self gg_addActionBlockForActionId:nil controlEvents:controlEvents withBlock:actionBlock];
}

- (void)gg_addActionBlockForActionId:(NSString *)actionId controlEvents:(UIControlEvents)controlEvents withBlock:(UIControlActionBlock)actionBlock{
	
	NSMutableDictionary *actionBlocksDictionary = [self actionBlocksDictionary];
	
	UIControlActionBlockWrapper *blockActionWrapper = [[UIControlActionBlockWrapper alloc] init];
	blockActionWrapper.actionBlock = actionBlock;
	blockActionWrapper.controlEvents = controlEvents;
	
	NSString *key = actionId == nil ? [NSString stringWithFormat:@"events_%lu",(unsigned long)controlEvents] : actionId;
	
	//移除之前的事件
	UIControlActionBlockWrapper *lastBlockActionWrapper = actionBlocksDictionary[key];
	if (lastBlockActionWrapper) {
		[self gg_removeActionBlockForActionId:lastBlockActionWrapper.actionId];
	}
	
	[actionBlocksDictionary setObject:blockActionWrapper forKey:key];
	[self addTarget:blockActionWrapper action:@selector(invokeBlock:) forControlEvents:controlEvents];
}

	///根据ID移除点击事件
-  (void)gg_removeActionBlockForActionId:(NSString *)actionId{
	NSMutableDictionary *actionBlocksDictionary = [self actionBlocksDictionary];
	for (NSString *key in actionBlocksDictionary.allKeys) {
		UIControlActionBlockWrapper *wrapperTmp = actionBlocksDictionary[key];
		if ([actionId isEqualToString:key]) {
			[actionBlocksDictionary removeObjectForKey:key];
			[self removeTarget:wrapperTmp action:@selector(invokeBlock:) forControlEvents:wrapperTmp.controlEvents];
		}
	}
}
//移除点击Block
-  (void)gg_removeActionBlocksForControlEvents:(UIControlEvents)controlEvents{
	NSMutableDictionary *actionBlocksDictionary = [self actionBlocksDictionary];
	for (NSString *key in actionBlocksDictionary.allKeys) {
		UIControlActionBlockWrapper *wrapperTmp = actionBlocksDictionary[key];
		if (wrapperTmp.controlEvents == controlEvents) {
			[actionBlocksDictionary removeObjectForKey:key];
			[self removeTarget:wrapperTmp action:@selector(invokeBlock:) forControlEvents:controlEvents];
		}
	}
}


- (NSMutableDictionary *)actionBlocksDictionary {
	NSMutableDictionary *actionBlocksDictionary = objc_getAssociatedObject(self, UIControlActionBlockDictionary);
	if (!actionBlocksDictionary) {
		actionBlocksDictionary = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, UIControlActionBlockDictionary, actionBlocksDictionary, OBJC_ASSOCIATION_RETAIN);
	}
	return actionBlocksDictionary;
}

#pragma mark - 防止按钮重复点击

//static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
//
//- (NSTimeInterval)gg_acceptEventInterval{
//	return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
//}
//
//- (void)setGg_acceptEventInterval:(NSTimeInterval)gg_acceptEventInterval{
//	objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(gg_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void)setGg_isIgnoreEvent:(BOOL)gg_isIgnoreEvent{
//	objc_setAssociatedObject(self, @selector(gg_isIgnoreEvent), @(gg_isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (BOOL)gg_isIgnoreEvent{
//	return [objc_getAssociatedObject(self, _cmd) boolValue];
//}
//
//	///注册AcceptEventInterval属性 否则不可用
//+ (void)load{
//
//		//确保只执行一次
//	static dispatch_once_t onceToken;
//	dispatch_once(&onceToken, ^{
//			//替换系统方法
//		SEL    oldSel  = @selector(sendAction:to:forEvent:);
//		SEL    newSel  = @selector(newSendAction:to:forEvent:);
//
//		Method oldMet  = class_getInstanceMethod(self, oldSel);
//		Method newMet  = class_getInstanceMethod(self, newSel);
//
//		IMP    oldImp  = method_getImplementation(oldMet);
//		IMP    newImp  = method_getImplementation(newMet);
//
//		const char * oldType = method_getTypeEncoding(oldMet);
//		const char * newType = method_getTypeEncoding(newMet);
//
//			//动态添加Method
//		BOOL isAdd = class_addMethod(self, newSel, newImp, newType);
//		if (isAdd) {
//				//替换
//			class_replaceMethod(self, newSel, oldImp, oldType);
//		}else{
//				//交换
//			method_exchangeImplementations(oldMet, newMet);
//		}
//	});
//}
//
//	//替换的方法
//- (void)newSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
//
//		//    NSLog(@"按钮冷却中...");
//	if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
//
//		self.gg_acceptEventInterval = self.gg_acceptEventInterval ==0?0.3:self.gg_acceptEventInterval;
//		if (self.gg_isIgnoreEvent){
//			return;
//		}else if (self.gg_acceptEventInterval > 0){
//			[self performSelector:@selector(resetState) withObject:nil afterDelay:self.gg_acceptEventInterval];
//		}
//	}
//
//	self.gg_isIgnoreEvent = YES;
//
//		//这里实际执行的是系统的 sendAction 方法
//	[self newSendAction:action to:target forEvent:event];
//}
//
//	//解除限制
//- (void)resetState{
//	[self setGg_isIgnoreEvent:NO];
//}



@end

@implementation UIControlActionBlockWrapper

- (void)invokeBlock:(id)sender {
	if (self.actionBlock) {
		self.actionBlock(sender);
	}
}

@end
