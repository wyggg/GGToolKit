//
//  ViewController.h
//  GGToolKitDemo
//
//  Created by yg on 2023/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (GG)

//系统提示床单
+ (void)showActionSheetWithTitle:(NSString *)title 
                         message:(NSString *)message
                     cancelTitle:(NSString *)cancelTitle
                destructiveTitle:(NSString *)destructiveTitle
                           items:(NSArray *)items
                           style:(UIAlertControllerStyle)style
                    atController:(UIViewController *)controller
                          action:(void(^)(NSUInteger itemIndex))itemAction;

//带输入框的系统提示框
+ (void)showTextFieldActionWithTitle:(NSString *)title 
                             message:(NSString *)message
                         placeholder:(NSString *)placeholder
                       textFieldText:(NSString *)textFieldText
                               items:(NSArray *)items
                        atController:(UIViewController *)controller
                              action:(void(^)(NSUInteger itemIndex,UITextField *textField))itemAction;

@end

NS_ASSUME_NONNULL_END
