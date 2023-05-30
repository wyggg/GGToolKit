//
//  GGGridView.h
//  GGToolKit
//
//  Created by yg on 2023/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//9宫格封装
@interface GGGridView : UIView

@property (nonatomic, assign) NSInteger warpCount; //折行点
@property (nonatomic, assign) CGFloat rowSpacing;   //行间距
@property (nonatomic, assign) CGFloat columnSpacing;//列间距
@property (nonatomic, assign) CGFloat itemWidth;   //宽度
@property (nonatomic, assign) CGFloat itemHeight;//高度

- (void)insertItem:(UIView *)item;

@end

NS_ASSUME_NONNULL_END
