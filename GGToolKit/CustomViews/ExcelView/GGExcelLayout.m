//
//  GGExcelLayout.m
//  GGToolKitDemo
//
//  Created by yg on 2024/1/10.
//

#import "GGExcelLayout.h"

@interface GGExcelLayout ()

@property (nonatomic, strong) NSMutableDictionary *layoutInfo;

@end


@implementation GGExcelLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layoutInfo = [NSMutableDictionary dictionary];
        NSMakeRange(1, 1);
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat contentWidth = 0;//滚动宽度
    CGFloat contentHeight = 0;//滚动高度
    
    NSInteger sectionCount = [self.collectionView numberOfSections];//所以区的数量
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
       
        CGFloat sectionWidth = 0;//区宽度统计
        CGFloat sectionHeight = 0;//区高度统计
        
        for (NSInteger item = 0; item < itemCount; item++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGSize itemSize = [self itemSizeAtIndexPath:indexPath];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(sectionWidth, contentHeight, itemSize.width, itemSize.height);
            BOOL isHidden = [self itemHiddenAtIndexPath:indexPath];
            if (isHidden) {
                itemAttributes.hidden = YES;
            }else{
                itemAttributes.hidden = NO;
                sectionWidth = sectionWidth + itemSize.width;
                sectionHeight = MAX(sectionHeight, itemSize.height);
            }
            [self.layoutInfo setObject:itemAttributes forKey:indexPath];
        }
        contentHeight = contentHeight + sectionHeight;
        contentWidth = MAX(contentWidth, sectionWidth);
    }
    _layoutContentSize = CGSizeMake(contentWidth, contentHeight);
    id <GGExcelLayout>delegate = (id<GGExcelLayout>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:updateInContentSize:)]) {
        [delegate collectionView:self.collectionView updateInContentSize:_layoutContentSize];
    }
}

- (CGSize)collectionViewContentSize {
    return _layoutContentSize;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray array];
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    return allAttributes;
}

#pragma mark - Helper Methods

- (CGSize)itemSizeAtIndexPath:(NSIndexPath *)indexPath {
    id <GGExcelLayout>delegate = (id<GGExcelLayout>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:sizeForItemAtIndexPath:)]) {
        return [delegate collectionView:self.collectionView sizeForItemAtIndexPath:indexPath];
    }else{
        return self.itemSize;
    }
}

- (BOOL)itemHiddenAtIndexPath:(NSIndexPath *)indexPath {
    id <GGExcelLayout>delegate = (id<GGExcelLayout>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:hiddenForItemAtIndexPath:)]) {
        return [delegate collectionView:self.collectionView hiddenForItemAtIndexPath:indexPath];
    }else{
        return NO;
    }
}


@end
