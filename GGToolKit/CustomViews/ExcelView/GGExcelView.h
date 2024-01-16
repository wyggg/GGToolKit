//
//  GGExcelView.h
//  GGToolKitDemo
//
//  Created by yg on 2024/1/3.
//

#import <UIKit/UIKit.h>
#import "GGExcelBaseCell.h"
#import "GGExcelTextCell.h"

@class GGExcelView;

@protocol GGExcelViewDelegate<NSObject>

@optional

//返回一共有多少行
- (NSInteger)numberOfSectionsInExcelView:(GGExcelView *)excelView;

//返回每一行显示多少个Cell
- (NSInteger)excelView:(GGExcelView *)excelView numberOfItemsInSection:(NSInteger)section;

//返回每个Cell的的大小
- (CGSize)excelView:(GGExcelView *)excelView sizeForCellAtIndexPath:(NSIndexPath *)indexPath;

//从布局中隐藏指定Cell 用于数据筛选
- (BOOL)excelView:(GGExcelView *)excelView hiddenForItemAtIndexPath:(NSIndexPath *)indexPath;

//返回每个自定义Cell
- (__kindof GGExcelBaseCell *)excelView:(GGExcelView *)excelView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

//每个Cell的点击事件
- (void)excelView:(GGExcelView *)excelView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GGExcelView : UIView

@property (nonatomic, weak) id <GGExcelViewDelegate>delegate;

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, strong) NSIndexPath *fixedPath;
@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) BOOL bounces;

//布局参数供外部使用
@property (nonatomic, assign, readonly) CGFloat fixedWidth;
@property (nonatomic, assign, readonly) CGFloat fixedHeight;
@property (nonatomic, assign, readonly) CGSize topLeftContentSize;
@property (nonatomic, assign, readonly) CGSize topRightContentSize;
@property (nonatomic, assign, readonly) CGSize btmLeftContentSize;
@property (nonatomic, assign, readonly) CGSize btmRightContentSize;
@property (nonatomic, assign, readonly) CGFloat contentTotalWidth;
@property (nonatomic, assign, readonly) CGFloat contentTotalHeight;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (__kindof GGExcelBaseCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)reloadData;
- (void)calculateFrames;
- (void)outputImage:(void(^)(UIImage *))done;

@end


