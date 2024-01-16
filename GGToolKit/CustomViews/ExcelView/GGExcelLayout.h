//
//  GGExcelLayout.h
//  GGToolKitDemo
//
//  Created by yg on 2024/1/10.
//

#import <UIKit/UIKit.h>

@class GGExcelLayout;

@protocol GGExcelLayout <UICollectionViewDelegate>
@optional
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView hiddenForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView updateInContentSize:(CGSize)contentSize;

@end

@interface GGExcelLayout : UICollectionViewLayout

@property (nonatomic, assign,readonly) CGSize layoutContentSize;
@property (nonatomic, assign) CGSize itemSize;

@end

