//
//  GGRichTextView.h
//  GGToolKit
//
//  Created by yg on 2023/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GGRichTextLineCellModel,GGRichTextImageCellModel;

//图文显示
@interface GGRichTextView : UIView

- (void)addText:(NSString *)text;
- (void)addImage:(UIImage *)image;
- (void)confitContentWithHtml:(NSString *)html;

@end

@interface GGRichTextLineCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic, strong) GGRichTextLineCellModel *model;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) void(^textChange)(GGRichTextLineCell *cell);

@end

@interface GGRichTextLineCellModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) UIFont *font;
@property (nonatomic, assign) CGFloat height;

- (CGFloat)calculatedHeightWithWidth:(CGFloat)width;

@end

@interface GGRichTextImageCell : UITableViewCell

@property (nonatomic, strong) GGRichTextImageCellModel *model;
@property (nonatomic, strong) UIImageView *attachmentsImageView;

@end


@interface GGRichTextImageCellModel : NSObject

@property (nonatomic, copy) UIImage *image;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) NSInteger imageAlignmentMode;
@property (nonatomic, assign) CGFloat height;

- (CGFloat)calculatedHeightWithWidth:(CGFloat)width;

@end




NS_ASSUME_NONNULL_END
