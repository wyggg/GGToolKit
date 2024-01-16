	//
	//  UITextField+GGTextField.h
	//  FactoryCollection
	//
	//  Created by iOS-吴港 on 2018/5/24.
	//  Copyright © 2018年 yg. All rights reserved.
	//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GGTextFieldInputType){
	GGTextFieldInputTypeAllText = 0,
	GGTextFieldInputTypePhoneNumber = 1,//范围文字：0-9数字   位数：0-11
	GGTextFieldInputTypeNumber = 2,//0-9
	GGTextFieldInputTypePassword = 3,//密码
	GGTextFieldInputTypeFloat = 4,//最终会被格式化为两位小数
};

@interface UITextField (GGTextField)

@property (nonatomic, assign) NSUInteger gg_maximumTextQuantity;
@property (nonatomic, assign) double gg_maximumNumber;//在GGTextFieldInputTypeFloat情况下的最大数字 负数为随意输入 默认-1
@property (nonatomic, assign) GGTextFieldInputType gg_inputType;
@property (nonatomic, copy) void(^gg_textFieldDidBegenBlock)(UITextField *tf);
@property (nonatomic, copy) void(^gg_textFieldDidChangedBlcok)(UITextField *tf);
@property (nonatomic, copy) void(^gg_textFieldDidEndBlock)(UITextField *tf);

+ (UITextField *)gg_textFieldWithInputType:(GGTextFieldInputType)inputType;

- (void)gg_setPlaceholder:(NSString *)placeholder
                     font:(UIFont *)font
                    color:(UIColor *)color;

+ (UITextField *)gg_textFieldWithCover:(UIView *)cover 
                                  text:(NSString *)text
                             inputType:(GGTextFieldInputType)inputType
                       didChangedBlcok:(void(^)(UITextField *tf,UIView *cover))didChangedBlcok
                           didEndBlcok:(void(^)(UITextField *tf,UIView *cover))didEnddBlcok;

@end

@interface UIView (GGAddInput)

@property (nonatomic, strong) UITextField *gg_inputTF;

//向一个view动态的添加一个textField，使其支持输入，失去焦点时textField会被移除
- (void)gg_addInputWithText:(NSString *)text 
                  inputType:(GGTextFieldInputType)inputType
            didChangedBlcok:(void(^)(UITextField *tf,UIView *cover))didChangedBlcok
                didEndBlcok:(void(^)(UITextField *tf,UIView *cover))didEnddBlcok;

@end
