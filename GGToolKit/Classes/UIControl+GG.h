//
//  UIControl+GG.h
//  unzip
//
//  Created by yg on 2021/11/15.
//

#import <UIKit/UIKit.h>


typedef void (^UIControlActionBlock)(__kindof UIControl *weakSender);

@interface UIControl (GG)

///添加UIControlEventTouchUpInside的block点击事件
- (void)gg_addActionBlock:(UIControlActionBlock)actionBlock;

///移除UIControlEventTouchUpInside的block点击事件
- (void)gg_removeActionBlock;

///添加点击事件
- (void)gg_addActionBlockForActionId:(NSString *)actionId controlEvents:(UIControlEvents)controlEvents withBlock:(UIControlActionBlock)actionBlock;

///根据ID移除点击事件
-  (void)gg_removeActionBlockForActionId:(NSString *)actionId;

///添加点击Block
- (void)gg_addActionBlockForControlEvents:(UIControlEvents)controlEvents withBlock:(UIControlActionBlock)actionBlock;

///移除点击Block
-  (void)gg_removeActionBlocksForControlEvents:(UIControlEvents)controlEvents;

///设置按钮点击冷却时间
@property (nonatomic, assign) NSTimeInterval gg_acceptEventInterval;//点击事件冷却
@property (nonatomic, assign) BOOL gg_isIgnoreEvent;//是否忽略点击事件

@end


@interface UIControlActionBlockWrapper : NSObject

@property (nonatomic, copy) NSString *actionId;
@property (nonatomic, copy) UIControlActionBlock actionBlock;
@property (nonatomic, assign) UIControlEvents controlEvents;

- (void)invokeBlock:(id)sender;

@end

