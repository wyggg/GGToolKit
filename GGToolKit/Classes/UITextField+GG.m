	//
	//  UITextField+GGTextField.m
	//  FactoryCollection
	//
	//  Created by iOS-吴港 on 2018/5/24.
	//  Copyright © 2018年 yg. All rights reserved.
	//

#import "UITextField+GG.h"
#import <objc/runtime.h>

static const char * __gg_inputType = "gg_inputType";
static const char * __gg_maximumTextQuantity = "gg_maximumTextQuantity";
static const char * __gg_maximumNumber = "gg_maximumNumber";

static const char * __gg_textFieldDidChangedBlcok = "gg_textFieldDidChangedBlcok";
static const char * __gg_textFieldDidEndBlock = "gg_textFieldDidEndBlock";
static const char * __gg_textFieldDidBegenBlock = "gg_textFieldDidBegenBlock";




@implementation UITextField (GGTextField)

+ (UITextField *)gg_textFieldWithInputType:(GGTextFieldInputType)inputType{
	UITextField *textField = [[UITextField alloc] init];
	textField.clearButtonMode = UITextFieldViewModeNever;
	textField.gg_inputType = inputType;
	return textField;
}

+ (UITextField *)gg_textFieldWithCover:(UIView *)cover text:(NSString *)text inputType:(GGTextFieldInputType)inputType didChangedBlcok:(void(^)(UITextField *tf,UIView *cover))didChangedBlcok didEndBlcok:(void(^)(UITextField *tf,UIView *cover))didEnddBlcok{
	
	UITextField *textField = [[UITextField alloc] init];
	textField.gg_inputType = inputType;
	textField.text = text;
	textField.gg_textFieldDidChangedBlcok = ^(UITextField *tf) {
		if (didChangedBlcok == nil) {return;}
		didChangedBlcok(tf,cover);
	};
	textField.gg_textFieldDidEndBlock = ^(UITextField *tf) {
		[tf removeFromSuperview];
		if (didEnddBlcok == nil) {return;}
		didEnddBlcok(tf,cover);
	};
	[cover addSubview:textField];
	textField.frame = cover.bounds;
	textField.backgroundColor = UIColor.whiteColor;
	return textField;
}



- (void)setGg_inputType:(GGTextFieldInputType)gg_inputType{
	[self addTarget:self action:@selector(gg_textFieldDidBegen:) forControlEvents:(UIControlEventEditingDidBegin)];
	[self addTarget:self action:@selector(gg_textFieldDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
	[self addTarget:self action:@selector(gg_textFieldDidEnd:) forControlEvents:(UIControlEventEditingDidEnd)];
	if (gg_inputType == GGTextFieldInputTypePhoneNumber) {
		self.keyboardType = UIKeyboardTypeNumberPad;
		self.gg_maximumTextQuantity = 11;
		self.secureTextEntry = NO;
	}
	if (gg_inputType == GGTextFieldInputTypeNumber){
		self.keyboardType = UIKeyboardTypeNumberPad;
		self.gg_maximumTextQuantity = 0;
		self.secureTextEntry = NO;
	}
	
	if (gg_inputType == GGTextFieldInputTypePassword) {
		self.gg_maximumTextQuantity = 0;
		self.secureTextEntry = YES;
	}
	
	if (gg_inputType == GGTextFieldInputTypeFloat) {
		self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		self.gg_maximumTextQuantity = 0;
		self.gg_maximumNumber = -1;
		self.secureTextEntry = NO;
	}
	
	objc_setAssociatedObject(self, __gg_inputType, @(gg_inputType), OBJC_ASSOCIATION_ASSIGN);
}

	///开始编辑
- (void)gg_textFieldDidBegen:(UITextField *)textField{
	if (self.gg_textFieldDidBegenBlock) {
		self.gg_textFieldDidBegenBlock(textField);
	}
}

	///编辑中
- (void)gg_textFieldDidChanged:(UITextField *)textField{
	NSString *text = textField.text;
		///兼容系统九宫格输入法 如果有被选中的文字 不限制输入
	UITextRange *selectedRange = [textField markedTextRange];
	UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];//高亮
	if (position) {
		return;
	}
		//最大限制判断
	if (textField.gg_maximumTextQuantity>0) {
		if (text.length>textField.gg_maximumTextQuantity) {
			text = [text substringWithRange:NSMakeRange(0, textField.gg_maximumTextQuantity)];
			textField.text = text;
		}
	}
	
		//输入类型判断
	if (self.gg_inputType == GGTextFieldInputTypeAllText) {
			///不做操作
	}else if (self.gg_inputType == GGTextFieldInputTypePhoneNumber || self.gg_inputType == GGTextFieldInputTypeNumber) {
		
		NSError *error = nil;
		NSRegularExpression *reguleExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:&error];
		NSArray <NSTextCheckingResult *>*array = [reguleExpression matchesInString:text options:0 range:NSMakeRange(0, text.length)];
		NSMutableString *mText = [[NSMutableString alloc] init];
		[array enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[mText appendString:[text substringWithRange:obj.range]];
		}];
		text = mText;
		textField.text = text;
	}
	
	if (self.gg_textFieldDidChangedBlcok) {
		self.gg_textFieldDidChangedBlcok(textField);
	}
}

	///结束编辑
- (void)gg_textFieldDidEnd:(UITextField *)textField{
	if (self.gg_inputType == GGTextFieldInputTypeNumber) {
		double number = textField.text.doubleValue;
		if (number > self.gg_maximumNumber && self.gg_maximumNumber > 0) {
			textField.text = [NSString stringWithFormat:@"%.0f",self.gg_maximumNumber];
		}
	}
	if (self.gg_inputType == GGTextFieldInputTypeFloat){
		double number = textField.text.doubleValue;
		if (number > self.gg_maximumNumber && self.gg_maximumNumber > 0) {
			textField.text = [NSString stringWithFormat:@"%.2f",self.gg_maximumNumber];
		}
	}
	if (self.gg_textFieldDidEndBlock) {
		self.gg_textFieldDidEndBlock(textField);
	}
}

- (void)gg_setPlaceholder:(NSString *)placeholder
					 font:(UIFont *)font
					color:(UIColor *)color{
	if (placeholder==nil) {
		placeholder = @"";
	}
	NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
	[attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, placeholder.length)];
	[attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, placeholder.length)];
	self.attributedPlaceholder = attStr;
}

#pragma mark - set And get

- (GGTextFieldInputType)gg_inputType{
	
	if (@available(iOS 9.0, *)) {
		return [objc_getAssociatedObject(self, __gg_inputType) integerValue];;
	}else{
		return 0;
	}
	
}

- (void)setGg_maximumTextQuantity:(NSUInteger)gg_maximumTextQuantity{
	[self addTarget:self action:@selector(gg_textFieldDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
	objc_setAssociatedObject(self, __gg_maximumTextQuantity, @(gg_maximumTextQuantity), OBJC_ASSOCIATION_COPY);
}

- (NSUInteger)gg_maximumTextQuantity{
	return [objc_getAssociatedObject(self, __gg_maximumTextQuantity) integerValue];
}

- (void)setGg_textFieldDidEndBlock:(void (^)(UITextField *))gg_textFieldDidEndBlock{
	objc_setAssociatedObject(self, __gg_textFieldDidEndBlock, gg_textFieldDidEndBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UITextField *))gg_textFieldDidEndBlock{
	return objc_getAssociatedObject(self, __gg_textFieldDidEndBlock);
}

- (void)setGg_textFieldDidChangedBlcok:(void (^)(UITextField *))gg_textFieldDidChangedBlcok{
	objc_setAssociatedObject(self, __gg_textFieldDidChangedBlcok, gg_textFieldDidChangedBlcok, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UITextField *))gg_textFieldDidBegenBlock{
	return objc_getAssociatedObject(self, __gg_textFieldDidBegenBlock);
}

- (void)setGg_textFieldDidBegenBlock:(void (^)(UITextField *))gg_textFieldDidBegenBlock{
	objc_setAssociatedObject(self, __gg_textFieldDidBegenBlock, gg_textFieldDidBegenBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UITextField *))gg_textFieldDidChangedBlcok{
	return objc_getAssociatedObject(self, __gg_textFieldDidChangedBlcok);
}

- (void)setGg_maximumNumber:(double)gg_maximumNumber{
	objc_setAssociatedObject(self, __gg_maximumNumber, @(gg_maximumNumber), OBJC_ASSOCIATION_COPY);
}

- (double)gg_maximumNumber{
	return [objc_getAssociatedObject(self, __gg_maximumNumber) doubleValue];
}

@end


static const char * __gg_inputTextField = "gg_inputTextField";

@implementation UIView (ggAddInput)

- (void)gg_addInputWithText:(NSString *)text inputType:(GGTextFieldInputType)inputType didChangedBlcok:(void(^)(UITextField *tf,UIView *cover))didChangedBlcok didEndBlcok:(void(^)(UITextField *tf,UIView *cover))didEnddBlcok{
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputTapGesture)];
	[self addGestureRecognizer:tapGesture];
	self.userInteractionEnabled = YES;
	
	UITextField *tf = [UITextField gg_textFieldWithCover:self text:text inputType:inputType didChangedBlcok:didChangedBlcok didEndBlcok:didEnddBlcok];
	self.gg_inputTF = tf;
	[tf removeFromSuperview];
	
}

- (void)inputTapGesture{
	[self.gg_inputTF becomeFirstResponder];
	[self addSubview:self.gg_inputTF];
	self.gg_inputTF.frame = self.bounds;
}

- (void)setgg_inputTF:(UITextField *)gg_inputTF{
	objc_setAssociatedObject(self, __gg_inputTextField, gg_inputTF, OBJC_ASSOCIATION_RETAIN);
}

- (UITextField *)gg_inputTF{
	return objc_getAssociatedObject(self, __gg_inputTextField);
}


@end
