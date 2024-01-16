//
//  GGExcelBaseCell.h
//  GGToolKitDemo
//
//  Created by yg on 2024/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GGExcelBaseCell : UICollectionViewCell

@property (nonatomic, strong ,readonly) UIView *separatorLeftView;
@property (nonatomic, strong ,readonly) UIView *separatorRightView;
@property (nonatomic, strong ,readonly) UIView *separatorTopView;
@property (nonatomic, strong ,readonly) UIView *separatorBottomView;

@property (nonatomic, assign) CGFloat separatorLeftScale;
@property (nonatomic, assign) CGFloat separatorRightScale;
@property (nonatomic, assign) CGFloat separatorTopScale;
@property (nonatomic, assign) CGFloat separatorBottomScale;

@property (nonatomic, assign) CGFloat separatorLeftMargin;
@property (nonatomic, assign) CGFloat separatorRightMargin;
@property (nonatomic, assign) CGFloat separatorTopMargin;
@property (nonatomic, assign) CGFloat separatorBottomMargin;



@end

NS_ASSUME_NONNULL_END
