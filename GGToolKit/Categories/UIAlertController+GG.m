//
//  ViewController.m
//  GGToolKitDemo
//
//  Created by yg on 2023/12/14.
//


@implementation UIAlertController (GG)

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

@end
